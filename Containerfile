# Containerfile for Konflux build of zot (OCI container registry)
# Rebuild of project-zot/zot for Konflux. Upstream is included as a git submodule at zot/.

ARG ZOT_VERSION

# Build stage
FROM registry.access.redhat.com/ubi9/go-toolset:latest AS builder

ARG ZOT_VERSION

WORKDIR /workspace/zot

COPY zot/go.mod zot/go.sum ./
RUN go mod download

COPY zot/ ./

RUN CGO_ENABLED=0 go build -a -installsuffix cgo \
    -ldflags="-w -X main.Version=${ZOT_VERSION}" \
    -o /tmp/zot-binary ./cmd/zot

# Runtime stage
FROM registry.access.redhat.com/ubi10-micro:10.1-1769518576

WORKDIR /srv/zot

COPY --from=builder /tmp/zot-binary /usr/local/bin/zot

# Enterprise Contract required labels
LABEL description="Zot is a production-ready vendor-neutral OCI-native container image and artifact registry."
LABEL distribution-scope="public"
LABEL com.redhat.component="zot"
LABEL io.k8s.description="Zot is a production-ready vendor-neutral OCI-native container image and artifact registry."
LABEL name="zot"
LABEL release="1"
LABEL url="https://github.com/project-zot/zot"
LABEL vendor="Red Hat\, Inc."
LABEL version="1"
LABEL org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.description="Zot is a production-ready vendor-neutral OCI-native container image and artifact registry." \
      org.opencontainers.image.documentation=https://zotregistry.dev \
      org.opencontainers.image.source=https://github.com/project-zot/zot \
      org.opencontainers.image.title=zot \
      org.opencontainers.image.vendor="Red Hat\, Inc." \
      org.opencontainers.image.version=${ZOT_VERSION}

USER 1001

ENTRYPOINT ["/usr/local/bin/zot", "serve"]
CMD ["/srv/zot/config.json"]
