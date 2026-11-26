---
name: metabase
description: Query Metabase and build or save questions and dashboards via the Metabase MCP server. Use when the user asks a data question that maps to a Metabase-connected database, or asks to save a chart, question, or dashboard.
---

Lessons for working with the Metabase MCP. The server documents itself: run `learn()` for its topic list and read the matching topic before your first complex write (`query-dialect`, `native-parameters`, `dashboard-filters`, `dashboard-layout`, `visualization-settings`). Tool names and parameters change, so trust the current tool docs over this file.

## Discover before you query

- Read `glossary()` first. The instance's definition of a business term overrides your reading of it.
- Search with both keywords and a natural-language query. Domain words often don't match table names (e.g. "application" → `snap_apps`).
- Read a table's full field list before querying it. Check descriptions and FKs, and don't invent column names.
- Many tables and columns have no description. If a term is ambiguous, ask rather than guess.

## Prefer MBQL over SQL

Use `execute_query` and save with `question_write`'s structured `query`. Those cards edit natively in the Metabase UI and take dashboard filters as-is. Use `native` SQL only for what MBQL can't express (CTEs, window functions, engine-specific functions) or when asked.

## Native SQL filters

Read `learn("native-parameters")` before adding template tags. The mistakes that bite most:

- Write a field filter bare: `WHERE {{created_at}}`, not `WHERE created_at = {{created_at}}`.
- Don't alias the filtered table. Metabase expands the filter to `table.column`, which `FROM table t` hides.
- Give date filters a `default` (e.g. `past3days`) so the card stays bounded before anyone touches it.
- For a table big enough that a full scan is dangerous, also hard-code an outer bound: `WHERE created_at > now() - interval '30 days' [[AND {{created_at}}]]`. An empty filter then still can't scan everything.

## Check results before saving

- Run the query once and confirm the numbers look plausible before saving a card or dashboard.
- The database reports its session timezone in results. If "today" means a different day for the user, translate or say so.
- After a write, read the response (`collection_path`, `url`) or the card itself via `get_content` to confirm what was stored and where. Report the URL.

## Saved content is shared

Questions and dashboards are visible to everyone who can see their collection. Confirm the collection (personal or shared) unless the user already said.

## Fix metadata upstream

Missing FKs, wrong semantic types and empty descriptions are gaps in Metabase's data model or the source schema. Don't work around them in each query; flag them so they get fixed once (Metabase Admin UI, or in Postgres with `COMMENT ON` and real FK constraints, which Metabase syncs).

If a task needs something the MCP can't do (permissions, database connections, syncs), check the current tool list, then point the user to the Metabase Admin UI or REST API.
