# Minimal runtime image for pre-compiled binaries
FROM debian:bookworm-slim
WORKDIR /app

# Install certificates
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Automatically select the correct Linux binary based on Docker host architecture
ARG TARGETARCH
COPY znt-linux-${TARGETARCH:-amd64} ./znt
COPY ui ./ui
COPY config.yaml ./
COPY README.md ./

EXPOSE 8080

ENTRYPOINT ["./znt"]
