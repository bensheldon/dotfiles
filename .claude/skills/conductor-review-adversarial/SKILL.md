---
name: conductor-review-adversarial
disable-model-invocation: true
description: Run an adversarial code review loop with a different model in a separate Conductor session. If you are Claude, start a Codex reviewer. If you are Codex, start a Claude reviewer. The main session reads each review, decides which findings to act on, applies the fixes and asks for a re-review. The loop runs for at most 5 rounds, or until the reviewer has nothing left. The user invokes it explicitly with /conductor-review-adversarial, and that gives the main session permission to edit files.
---

This skill runs a review loop. A reviewer on the other model reviews the changes in this workspace. You are the main session. You judge its findings and apply the ones you accept. Then you ask it to review again. Repeat until you both agree, for at most **5 rounds**.

The user may pass arguments that narrow the review, such as a path, "only the migration" or "focus on concurrency". Pass them on to the reviewer.

## 1. Setup

1. Call `mcp__conductor__WhoAmI` to find out which agent you are and which workspace you're in.
2. Pick the reviewer. If you are `claude`, the reviewer is `codex`. Otherwise the reviewer is `claude`.
3. Don't pass `model` or `effort`, so that the reviewer uses its default model. Call `mcp__conductor__ListModels` only if `CreateSession` rejects the call.
4. Find the branch to compare against. It is usually `origin/main`. Check that there is something to review by running these two commands:

   ```sh
   git diff <target>...
   git status --porcelain --untracked-files=all
   ```

   If both print nothing, stop and tell the user.

## 2. Start the reviewer

Copy `review-guidelines.md` from this skill's folder to `.context/adversarial-review-guidelines.md` in the workspace. Create `.context/` if it doesn't exist. Conductor's Review button passes its guidelines the same way.

Then call `mcp__conductor__CreateSession` with these arguments:

- new UUIDs for `sessionId` and `messageId`
- `agent` set to the reviewer
- `title: "Adversarial review"`
- no `workspaceId`, so that the reviewer works in this workspace

If the result has a `messageError`, the session exists but didn't get the prompt. Resend the prompt with `mcp__conductor__SendSessionMessage`, using the same `messageId` for every retry. If it still fails, stop and tell the user.

Send this message:

> You are an adversarial code reviewer. Read `.context/adversarial-review-guidelines.md` and follow it. Pay close attention to its output format and its rules about side effects.
>
> Review the changes in this workspace against `<target>`. Use `mcp__conductor__GetWorkspaceDiff` if you have it. Otherwise run `git --no-optional-locks diff --no-ext-diff --no-textconv <target>...`, and check uncommitted and untracked files with `git --no-optional-locks status --porcelain --untracked-files=all`.<scope or focus, if given>
>
> Reply with a numbered list of findings that ends with `END OF FINDINGS (N total)`. If you have no findings, reply with exactly `NO FINDINGS`.

Tell the user that the reviewer has started and which agent it uses.

## 3. Loop for rounds 1 to 5

### Step 1: Wait for the reviewer

Call `mcp__conductor__WaitForSessions` with `ids: [reviewerId]`, `until: "allSettled"` and `timeoutMs: 50000`. If the result has `timedOut: true`, call it again. Give up after 20 minutes in one round. If that happens, tell the user that the reviewer seems stuck, link to it and stop.

When the reviewer settles, check its state:

- `error`: tell the user and stop.
- `waiting_for_user`: read its last message. If it is asking for a tool or permission approval, tell the user and stop. If it asks a question you can answer, answer it with `SendSessionMessage` and wait again. This doesn't count as a new round. If you can't answer it, tell the user and stop.
- `idle`: go on to the next step.

### Step 2: Read the reply

Call `mcp__conductor__ListSessionMessages`. Sort by index in ascending order, and set `filter.afterIndex` to the last index you read. Follow `nextCursor` until it is null, because the findings may not be on the first page. Save `lastIndex` only after you have read every page.

If the reviewer's session ID is in `missingIds`, the session is gone. Tell the user and stop.

Long messages get truncated, so check that you have the whole reply before you judge it. Sort it into one of three cases:

- **Complete.** The reply is `NO FINDINGS`. Or it ends with `END OF FINDINGS (N total)`, and you have every finding from 1 to N in full. Count findings from this reply together with any resends in this round, and match them by their original numbers.
- **Partial.** The reply has numbered findings, but something is missing. The end marker may be missing, some numbers may be missing, or a finding may be cut off. Ask the reviewer for the missing or cut-off findings by number. If the end marker is missing, ask for the total and for every finding from the first one you couldn't confirm. Ask the reviewer to keep the original numbers and to repeat the end marker. Then wait, add the new findings to the ones you have, and check again. You can ask twice per round, and this doesn't count as a new round.
- **No findings list.** The reply has no numbered findings at all, for example when it is only a progress update. Ask for the full review once more.

If the reply still isn't complete after these retries, tell the user that the round didn't finish and stop.

### Step 3: Check whether you're done

Stop the loop if the reviewer replied `NO FINDINGS`. Also stop if you already rejected every finding in an earlier round and the reviewer gave no new argument.

### Step 4: Judge each finding

Check each finding against the code yourself. Don't take the reviewer's word for it. Decide one of these:

- **Accept.** The finding is real. Fix it, and add or update a test when the risk calls for one.
- **Reject.** The finding is wrong, out of scope or not worth the cost. Write a one-line reason.
- **Partly accept.** Fix the problem in a different way than the reviewer suggested, and write down why.

### Step 5: Apply the fixes

Apply the fixes you accepted. Then run the relevant tests yourself, and run the project's linter if it has one, such as `bin/lint --all`. The reviewer may run a few targeted tests, but not the full suite or the linter. Don't commit unless the user asked you to.

### Step 6: Ask for a re-review

In round 5, don't send another message. Go to Finish.

In earlier rounds, send a new message with `mcp__conductor__SendSessionMessage`, using a new `messageId` and `mode: "queue"`. Send it whether or not you changed anything:

> Round N+1. Here is how I handled your review:
> - #1 accepted: <what changed>
> - #2 rejected: <reason>
> - ...
>
> Re-review the current changes, with the same scope and still without editing files. Check that my fixes are correct and complete, and look for new problems that they introduced. If you disagree with a rejection, argue it once with evidence. Reply in the same format, ending with `END OF FINDINGS (N total)`, or reply `NO FINDINGS`.

If you rejected everything in this round, the message gives the reviewer one chance to push back. If the reviewer only repeats the same points, treat the loop as done.

## 4. Finish

Leave the reviewer session open so that the user can read it. Don't archive it.

Report to the user:

- how many rounds ran, and whether the loop finished or stopped at the 5-round limit
- a table of every finding, with its round, severity, your decision and what you changed or why you rejected it
- any findings that you and the reviewer still disagree on, so that the user can decide
- the test results after the last fixes
- a link to the reviewer session, from its `appUrl`
