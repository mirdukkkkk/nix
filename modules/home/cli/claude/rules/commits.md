# Commit messages

- Use Conventional Commits: `<type>(<scope>): <summary>`.
- Types: `feat`, `fix`, `build`, `chore`, `refactor`, `perf`, `docs`, `style`, `test`, `ci`, `revert`.
- Scope is optional: a module, package or area, e.g. `feat(claude): add communication rules`, `build(deps): update flake`, `fix(iloader): bump to 2.3.8`.
- Summary: lowercase, imperative, no trailing period, max 72 characters.
- Mark breaking changes with `!`: `refactor(nix)!: drop stable channel`.
- No body unless a change needs explaining (e.g. benchmark numbers).
- Reference issues in a footer: `Fixes #48`.
- In other people's repos, follow that repo's convention instead (e.g. nixpkgs uses `pkg: 1.0 -> 1.1`).
