# Preflight Timeout Check

- Time: 2026-03-19 00:14:10 CST
- Agent timeoutSeconds target: 1000s

## Tooling
- [x] timeout: /usr/bin/timeout
- [x] iconv: /usr/bin/iconv
- [x] docker: /usr/bin/docker
- [ ] mdb-tables: MISSING
- [ ] mdb-export: MISSING
- [ ] mdb-schema: MISSING
- [ ] jq: MISSING
- [x] rsync: /usr/bin/rsync

## Size Snapshot
- files: 670
- 11M	/home/mo/sofoyo/www/Databases
- 67M	/home/mo/sofoyo/www/uploadpic
- 152K	/home/mo/sofoyo/www/uploads
- 5.7M	/home/mo/sofoyo/www/image
- 1.7M	/home/mo/sofoyo/www/banner
- 6.1M	/home/mo/sofoyo/www/propic

## Timeout Risk Verdict
- DB size small (~11M), but missing mdbtools currently blocks export and may cause repeated retries.
- Asset copy can exceed one-shot safe window if done as single recursive operation.
- Mitigation: chunk by directory + checkpoint + per-step timeout < 600s.
