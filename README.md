# ACME Lego Cron

This repository builds the pinned current `main` commit of Lego used by the
Lighthouse stack. GitHub Actions publishes an immutable candidate and
`:latest` to GitHub Container Registry and verifies the development version
and retained cron entrypoint without production credentials. The commit and
archive checksum keep the moving upstream branch reproducible at each update.

The production Compose configuration, ACME state, and DNS provider secrets
remain managed by the Lighthouse deployment.

## Version tags

Each published build also has a `sha-<commit>` tag. To give a build a version, push a git tag named `vYYYY.MM.DD-ys.N` on a commit of `main` whose image has finished publishing. The `Tag released image` workflow then adds `ghcr.io/yusoofsh/acme-lego-cron:YYYY.MM.DD-ys.N` to that exact image. It never moves a version tag that already exists, and a tag push does not rebuild or redeploy anything. Pin deployments to the version tag.
