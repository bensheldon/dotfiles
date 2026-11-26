---
name: screenshot-rspec
description: Takes screenshots at specific points in a system test using the Ruby debugger. Use when the user wants to capture screenshots of a UI flow or page state during a system test without modifying test files.
---

Take screenshots at specific points in a system test using the Ruby debugger to inject `page.save_screenshot` calls non-invasively.

## Task

The user wants screenshots of: $ARGUMENTS

## Instructions

### 1. Find the relevant code

Search `spec/system/` for the relevant test file, and `spec/support/system/` for helper methods. Read the file to find the exact lines where screenshots should be taken.

### 2. Identify line numbers and names

For each screenshot point, determine:

- The line number (debugger breaks before the line executes)
- A short descriptive name for the file, e.g. `before_upload_v1`, `after_upload_v1`

Always use a version suffix (e.g. `-v1`, `-v2`) in the filename to avoid browser/viewer caching across sessions.

### 3. Build and run the command

Always prepend `USE_BROWSER=1`. Use `bundle exec rdbg` with one `-e` flag per breakpoint and a final `-e 'continue'`. Use bare filenames — Capybara prepends its own save path (`tmp/capybara/`) automatically:

```bash
USE_BROWSER=1 bundle exec rdbg \
  -e 'break path/to/file.rb:LINE do: eval page.save_screenshot("name_v1.png", full: true)' \
  -e 'break path/to/file.rb:LINE2 do: eval page.save_screenshot("name2_v1.png", full: true)' \
  -e 'continue' \
  -- bin/rspec path/to/spec.rb:LINE_NUMBER
```

**Always pass `full: true`** to `page.save_screenshot` to capture the entire scrollable page, not just the viewport.

Run the **specific example** (not the whole file) to avoid unrelated screenshots.

When an "after" screenshot depends on an async UI update, wait for a Capybara condition before saving:

```ruby
do: eval (expect(page).to(have_button("Remove")); page.save_screenshot("after_upload_v1.png", full: true))
```

**Example for the identity page:**

```bash
USE_BROWSER=1 bundle exec rdbg \
  -e 'break spec/support/system/apply_helpers.rb:46 do: eval page.save_screenshot("before_upload_v1.png", full: true)' \
  -e 'break spec/support/system/apply_helpers.rb:51 do: eval (expect(page).to(have_button("Remove")); page.save_screenshot("after_upload_v1.png", full: true))' \
  -e 'continue' \
  -- bin/rspec spec/system/apply/solo_spec.rb:5
```

#### Element screenshots

If you need to crop to a specific element, use the Cuprite driver method directly:

```ruby
do: eval page.driver.browser.screenshot(path: "tmp/capybara/name_v1.png", selector: ".my-component")
```

Note: the Cuprite driver method requires an explicit `tmp/capybara/` path prefix and does **not** support `full:` the same way. Prefer `page.save_screenshot(..., full: true)` for full-page shots as it works reliably in the debugger context.

### 4. Display the screenshots

Use the Read tool on each file at `tmp/capybara/NAME.png` to display them inline. Always output the file path alongside a short description, e.g.:

`tmp/capybara/before_upload_v1.png` — Upload button, no file selected yet.
`tmp/capybara/after_upload_v1.png` — File uploaded, Remove button visible.

Do not use base64 inline images or markdown image syntax — use the Read tool only.

### 5. Write durable tests

After taking screenshots, write real system tests for the behavior you just verified visually. Do **not** leave temporary screenshot-only tests in the codebase. The durable tests should assert on page content (headings, key text) using the same sign-in flow, but without any screenshot calls.

## Notes

- File paths in `-e` flags must be relative to `Rails.root`
- The `do:` clause evaluates in the test's execution context so `page` and all Capybara helpers are available
- The debugger breaks **before** the line executes — to capture state after an action, place the breakpoint on the line *following* that action
- Do **not** use `RUBY_DEBUG_COMMANDS` env var or `-n`/`--nonstop`—use multiple `-e` flags with a final `-e 'continue'`
- If `page.save_screenshot` fails, confirm `USE_BROWSER=1` is set (rack_test driver does not support screenshots). Check `spec/support/system/` for a configuration file that switches the Capybara driver based on this env var, e.g. `driven_by ENV["USE_BROWSER"] ? :selenium_chrome : :rack_test`
- CSS `text-transform: uppercase` makes rendered text appear uppercase in the browser even when the source is mixed-case. Use case-insensitive regex (e.g. `/before the call/i`) in `have_content` assertions to avoid fragile matches
