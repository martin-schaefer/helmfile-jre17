FROM ghcr.io/helmfile/helmfile-debian-stable-slim:v1.1.8
LABEL org.opencontainers.image.source="https://github.com/martin-schaefer/helmfile-jre"
LABEL org.opencontainers.image.description="A base container with git, helmfile, helm and Java 21 Runtime Environment (Temurin)"
LABEL org.opencontainers.image.licenses="Apache License v2.0"

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg \
    --no-install-recommends

# Add the Adoptium GPG key and repository
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor > /usr/share/keyrings/adoptium-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/adoptium-archive-keyring.gpg] https://packages.adoptium.net/artifactory/deb focal main" > /etc/apt/sources.list.d/adoptium.list

# Update package list and install Temurin-21
RUN apt-get update && apt-get install -y temurin-21-jre && apt-get install -y git

# Allow access for other users to /helm
RUN chmod -R a+rw /helm

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Print installed versions
CMD java -version;git --version;helm version;helmfile --version
