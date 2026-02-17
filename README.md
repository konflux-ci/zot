# Zot Registry Konflux Build

This repository contains the build configuration for creating Zot container images using Konflux CI. The upstream [project-zot/zot](https://github.com/project-zot/zot) project is included as a git submodule.

## Overview

[Zot](https://zotregistry.dev/) is a production-ready vendor-neutral OCI-native container image and artifact registry (purely based on the OCI Distribution Specification).

This repository provides:

- **Containerfile**: Multi-stage build configuration using Red Hat UBI images
- **Git submodule**: Links to the upstream [project-zot/zot](https://github.com/project-zot/zot) project
- **Konflux integration**: Multi-arch Tekton pipeline (`.tekton/`) for Konflux vanguard tenant

## Quick Start

1. **Initialize the submodule**:

   ```bash
   git submodule update --init --recursive
   ```

   **Note:** The submodule is configured to track version tags (not branches) for automated dependency updates via MintMaker/Renovate. This means `git submodule update --remote` will not work as expected. To manually update the submodule to a different tag, run:

   ```bash
   cd zot
   git fetch && git checkout <tag-name>
   ```

2. **Build locally** (with submodule populated):

   ```bash
   podman build -f Containerfile -t zot --build-arg ZOT_VERSION=v2.1.14 .
   ```

## Local Development

For local testing and development, use the upstream project's build system:

```bash
cd zot
make binary
```

## License

Apache-2.0 (see upstream [project-zot/zot](https://github.com/project-zot/zot) LICENSE).
