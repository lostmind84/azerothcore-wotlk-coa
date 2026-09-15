# 0002. Scenario-owned server settings and variant comparisons in gameplay tests

- Status: accepted
- Date: 2026-09-15

## Context

Issue #193 reports that `Rate.XP.Kill` and `Rate.XP.Quest` have no visible effect. Checking it needs the same
experience observation under two server configurations. The gameplay test runner generated `worldserver.conf` only
from the source config plus fixed harness values, so a scenario could not choose server settings, and one scenario
file ran in one server.

## Considered options

1. Scenario `config` written into the generated `worldserver.conf`, plus runner-level `variants` that run the same
   steps once per configuration and `compare` checks on named snapshots across variants.
2. A runtime action that changes a rate in the running server (`World::setRate`) or reloads edited configuration.
3. Two scenario files with hard-coded expected experience values.

## Decision

Option 1. Settings travel through the server's normal startup path (config file parsing, then
`World::LoadConfigSettings`), which is exactly the path a server operator uses. They join the generated harness
values, so module configs and inherited `AC_*` variables cannot silently replace them, and harness-owned settings
cannot be named. The runtime echoes each setting as its config manager read it, and the runner checks the echo.

Option 2 bypasses config parsing, the part an operator's change goes through, and would need a per-setting mapping
to internal enums. Option 3 duplicates steps and forces expected values derived from the implementation under test.

## Consequences

- Each variant repeats the database copy and server startup; a two-variant scenario takes about twice as long.
- Comparisons are ratios of snapshots, so expected values stay independent of base formulas.
- Scenario settings override `AC_*` variables for that run; an environment-variable misconfiguration on a real
  server is outside what these scenarios can reveal.
