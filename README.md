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

## Upstream

This repository follows [go-acme/lego](https://github.com/go-acme/lego). The history of the upstream `main` branch is part of this repository, so GitHub shows how far this build is behind it. The merge keeps this repository's files unchanged. The Dockerfile pins the upstream commit that the image builds. To update, change the pin and its checksum in a pull request, then merge the new upstream history with `git fetch upstream main` and `git merge -s ours upstream/main`.
