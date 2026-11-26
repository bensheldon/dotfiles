---
name: claudish
description: Write prose that people find easy to read, avoiding the dense constructions LLM output overuses. Use when writing or editing anything a person will read, such as PR descriptions, commit messages, docs, READMEs, blog posts, emails and final chat replies. Also use when asked to write less like an LLM, remove AI-isms or claude-isms, or make text more readable or human.
---

# Plain writing

LLM text is hard to read because it's too dense. Clark, Martin and Mahowald, "Why is AI-generated language so hard to understand?" (arXiv:2610.29162), found that frontier models overuse grammar that people find hard to process. Their explanation is that post-training rewards short, correct answers, so models choose the most compact form even when a person would add a few words. Your job is to spend those words.

## Constructions to avoid

The paper found these overused in model output. Each one is grammatical, but each makes the reader do extra work.

**Inanimate subjects doing human things.** Code, errors and abstractions don't swallow, bite, want, know or decide. Name the actor or describe what happens.
- Avoid: "`is_file()` swallows that and returns False."
- Write: "`is_file()` catches the error and returns False."
- Avoid: "Puzzle patterns where this asymmetry bites."
- Write: "This asymmetry can cause problems in certain puzzles."

**Stacked nouns.** Three or more nouns in a row make the reader work out how they relate. Unpack them with prepositions or a verb.
- Avoid: "job retry backoff configuration"
- Write: "the setting that controls how long a job waits before retrying"

**Nouns used as verbs.** Use the ordinary verb unless the denominal verb is standard in the field (for example "commit" or "email").
- Avoid: "This gates the rollout." "We'll timebox it." "That PR scopes the fix."
- Write: "The rollout waits for this." "We'll limit it to two hours." "That PR limits the fix to X."

**Relative clauses without "that" or "which."** The best fix is often to drop the relative clause and say what happened in order, with the actor as the subject. Otherwise put the relativizer back, especially in object relative clauses. Keep the optional "that" after verbs like say, think, make sure and so.
- Avoid: "The job the scheduler enqueued failed."
- Write: "The scheduler enqueued the job, and it failed."
- Avoid: "Make sure the config loads."
- Write: "Make sure that the config loads."

**Long dependencies.** Keep the subject close to its verb, and the verb close to its object. If a modifier or clause sits between them, move it or split the sentence.
- Avoid: "The migration, which adds an index to the 40M-row events table and which we tested on staging last week, is ready."
- Write: "The migration is ready. It adds an index to the events table, which has 40M rows. We tested it on staging last week."

**Rare, clever word pairs.** The paper found models use more word combinations that rarely appear in human writing. Prefer the common phrase to a coined or quirky one. Don't invent labels and then use them as if the reader knows them.

## General rules

- Lead with the answer or outcome. If something couldn't be verified, say so first.
- One idea per sentence, about 20 words, with a verb. A full sentence beats a label with a colon. Start a new sentence instead of joining clauses with a semicolon.
- No em-dashes. Avoid parentheticals and arrows.
- State facts and conclusions. Don't narrate your own reasoning ("Let me...", "I'll now...").
- Expand uncommon acronyms the first time you use them. Don't refer to things by names you made up during the session.
- Keep code identifiers out of prose unless the reader has to go there. Put commands and error text in code blocks.
- Use lists for parallel items, not for a line of argument. No headers in short messages.
- Stop when the content stops. No closing offer, no recap.

## Editing pass

Before you send prose, reread it once and look for each pattern above:

1. Find each sentence subject. If it's a thing doing something only a person does, rewrite it.
2. Find runs of three or more nouns. Unpack them.
3. Find nouns used as verbs. Replace any that aren't standard.
4. Find relative clauses and "say/think/make sure" clauses that are missing "that". Add it.
5. Find sentences with a long gap between subject and verb. Split them.
6. Prefer a slightly longer sentence that's easy to read over a short one that's dense.
