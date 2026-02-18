# Zot Registry Konflux Build

Build configuration for Zot container images using Konflux CI. Upstream: [project-zot/zot](https://github.com/project-zot/zot) (git submodule at `zot/`).

## Overview

[Zot](https://zotregistry.dev/) is a production-ready, vendor-neutral OCI-native container image and artifact registry (based on the [OCI Distribution Specification](https://github.com/opencontainers/distribution-spec)).

This repository provides:

- **Containerfile**: Multi-stage build using Red Hat UBI images (go-toolset builder, UBI10-micro runtime)
- **Git submodule**: Links to upstream [project-zot/zot](https://github.com/project-zot/zot), tracking version tags for Renovate/MintMaker
- **Konflux integration**: Multi-arch Tekton pipeline (`.tekton/`) for the Konflux vanguard tenant

## Quick Start

```bash
git submodule update --init --recursive
podman build -f Containerfile -t zot --build-arg ZOT_VERSION=v2.1.12 .
```

**Note:** The submodule is configured to track version tags (not branches) for automated dependency updates via MintMaker/Renovate. This means `git submodule update --remote` will not work as expected. To manually update the submodule to a different tag, run:

```bash
cd zot
git fetch && git checkout <tag-name>
```

## Testing the image

**Binary runs and shows version/help:**

```bash
podman run --rm zot --help
podman run --rm zot -v
```

**Run the registry:**  
Mount `config-test.json` at `/srv/zot/config.json`. Do **not** add `serve /srv/zot/config.json` — the image default is already `zot serve /srv/zot/config.json`. Use `:z` on the volume so the config is readable (SELinux).

```bash
podman run --rm -u 0 -p 8080:8080 \
  -v "$(pwd)/config-test.json:/srv/zot/config.json:ro,z" \
  -v zot-data:/var/lib/zot \
  zot
```

To use a different config path, pass it as the only argument: `podman run ... /path/to/config.json`.

Then from another terminal: `curl -s http://127.0.0.1:8080/v2/` (expect 401 or 200).

## Pipeline

Tekton pipeline in `.tekton/` (zot-pipeline, zot-push, zot-pull-request). Namespace: `konflux-vanguard-tenant`. SA: `build-pipeline-zot`.
