FROM ghcr.io/helmfile/helmfile-debian-stable-slim:v1.4.3
LABEL org.opencontainers.image.source="https://github.com/martin-schaefer/helmfile-jre"
LABEL org.opencontainers.image.description="A base container with git, helmfile, helm, Java 21 Runtime Environment (Temurin) and Claude Code"
LABEL org.opencontainers.image.licenses="Apache License v2.0"

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    --no-install-recommends

# Add the Adoptium GPG key and repository
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor > /usr/share/keyrings/adoptium-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/adoptium-archive-keyring.gpg] https://packages.adoptium.net/artifactory/deb focal main" > /etc/apt/sources.list.d/adoptium.list

# Update package list and install Temurin-21 and Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y temurin-21-jre git nodejs

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Allow access for other users to /helm
RUN chmod -R a+rw /helm

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Print installed versions
CMD java -version; git --version; helm version; helmfile --version; node -v; npm -v; claude --version
