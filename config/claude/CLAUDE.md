# How I work

## Language
- Reply to me in Spanish.
- Keep replies brief and concise.
- Commit messages, code (identifiers, comments) and documentation in English.

## Commands I run myself
- Git: Claude only runs read-only commands (status, log, diff, show).
  add, commit, branch, checkout, push, etc. are mine: give me the exact
  command and a suggested commit message.
- `gh`, `aws`, `cdk` or `terraform`: never run them, give them to me.
  Exception, always after asking: `terraform fmt`, `terraform validate`,
  `terraform init -backend=false` and `terraform test` (mocked providers only).
- `~/.claude/settings.json` enforces these rules with allow/ask/deny permissions.

## Commits, pushes and PRs
- At most 10 files per commit (renames and deletions count). If a change is
  bigger, split it into batches and stop at the end of each one.
- When working on a branch, remind me to push every 3 commits
  (check `git status -sb` / `git log @{u}..` for unpushed commits).
- PR descriptions live in `pr-body.md` at the repo root, which must be
  git-ignored (add it to `.gitignore` if missing). Keep it up to date as the
  PR evolves; never write it elsewhere (e.g. a scratchpad).
- Never create or edit PRs yourself: suggest me the exact command, reading the
  description from `pr-body.md`:
  - GitHub (`gh`):
    `gh pr create --title "<title>" --body-file pr-body.md`
    `gh pr edit <number> --body-file pr-body.md`
  - AWS CodeCommit (`aws codecommit`):
    `aws codecommit create-pull-request --title "<title>" --description file://pr-body.md --targets repositoryName=<repo>,sourceReference=<branch>,destinationReference=main`
    `aws codecommit update-pull-request-description --pull-request-id <id> --description file://pr-body.md`

## Tooling
- Keep tooling minimal: don't add extra tools without asking.
- Dev environments are nix flakes (devShell) with only what's needed.
