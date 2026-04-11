---
name: github-actions-status
description: Check GitHub Actions CI status, wait for runs to complete, get logs from failed jobs, and download artifacts. Use when the user asks about CI status, wants to wait for CI, or needs to investigate a test failure from a GitHub Actions URL.
---

Check GitHub Actions CI status and wait for completion.

If given a GitHub Actions URL, extract the run ID and job ID from it. If given a branch name, find the latest run. If not given either, use the current branch.

## Checking status

List recent runs for a branch:
```sh
gh run list --repo OWNER/REPO --branch BRANCH --limit 3 --json databaseId,status,conclusion
```

Find which jobs failed in a run:
```sh
gh api repos/OWNER/REPO/actions/runs/RUN_ID/jobs \
  --jq '[.jobs[] | select(.conclusion=="failure")] | map("\(.id) \(.name)")[]'
```

## Waiting for CI

Use `gh run watch` to block until a run completes:
```sh
gh run watch RUN_ID --repo OWNER/REPO --exit-status
```

Run this in the background with `run_in_background` so you can continue working while waiting.

## Getting logs

Full logs from a specific job (only works after run completes):
```sh
gh run view RUN_ID --repo OWNER/REPO --job JOB_ID --log
```

Search logs for specific content:
```sh
gh run view RUN_ID --repo OWNER/REPO --job JOB_ID --log 2>&1 | grep -E "FAILED|error pattern"
```

## Downloading log artifacts

Artifacts (like Rails test.log) contain more detail than CI stdout:
```sh
# List artifacts
gh api repos/OWNER/REPO/actions/runs/RUN_ID/artifacts \
  --jq '.artifacts[] | "\(.id) \(.name)"'

# Download and extract
gh api repos/OWNER/REPO/actions/artifacts/ARTIFACT_ID/zip > logs.zip
unzip -o logs.zip
```

## Re-running jobs

Rerun failed jobs from a run:
```sh
gh run rerun RUN_ID --repo OWNER/REPO --failed
```

Rerun the entire run:
```sh
gh run rerun RUN_ID --repo OWNER/REPO
```

Rerun a specific job (use databaseId, not the number from the URL):
```sh
# Get the correct job ID first
gh run view RUN_ID --repo OWNER/REPO --json jobs --jq '.jobs[] | {name, databaseId}'

# Then rerun it
gh run rerun --repo OWNER/REPO --job JOB_DATABASE_ID
```
