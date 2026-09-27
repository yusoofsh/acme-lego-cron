# ACME Lego Cron

This repository builds the pinned Lego based certificate renewal helper used
by the Lighthouse stack. GitHub Actions publishes an immutable candidate to
GitHub Container Registry and verifies Lego 5.2.2 and the retained cron
entrypoint without production credentials.

The production Compose configuration, ACME state, and DNS provider secrets
remain managed by the Lighthouse deployment.

