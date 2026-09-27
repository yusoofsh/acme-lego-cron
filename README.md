# ACME Lego Cron

This repository builds the pinned current `main` commit of Lego used by the
Lighthouse stack. GitHub Actions publishes an immutable candidate and
`:latest` to GitHub Container Registry and verifies the development version
and retained cron entrypoint without production credentials. The commit and
archive checksum keep the moving upstream branch reproducible at each update.

The production Compose configuration, ACME state, and DNS provider secrets
remain managed by the Lighthouse deployment.
