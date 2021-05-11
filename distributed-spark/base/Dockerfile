FROM ubuntu:latest

ARG shared_workspace=/opt/workspace
ARG openjdk_version="14"

# Install Python, Java and other useful components
RUN mkdir -p ${shared_workspace}/data && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y \
    python \
    curl \
    tini \
    wget \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV SHARED_WORKSPACE=${shared_workspace}

VOLUME ${shared_workspace}

CMD ["bash"]