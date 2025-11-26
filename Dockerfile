FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    # Debian 12/13 use externally-managed Python; this lets us ignore PEP 668
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

# --- Base packages + toolchains (your original list) ---
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    clang-format \
    curl \
    diffutils \
    dos2unix \
    doxygen \
    git \
    jq \
    libhidapi-hidraw0 \
    python3 \
    python3-pip \
    rsync \
    sudo \
    tar \
    unzip \
    util-linux \
    wget \
    zip \
    zstd

# QMK-relevant toolchains (with C stdlib headers)
RUN apt-get update && apt-get install -y \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    libnewlib-arm-none-eabi \
 && rm -rf /var/lib/apt/lists/*

# --- Pin QMK CLI to a known-good version ---
ARG QMK_CLI_VERSION=1.1.8
RUN python3 -m pip install --no-cache-dir "qmk==${QMK_CLI_VERSION}"

# --- Pin the Python deps that go with that QMK version (reqs in root) ---
COPY requirements.txt /tmp/qmk_requirements.txt
RUN python3 -m pip install --no-cache-dir -r /tmp/qmk_requirements.txt \
 && rm /tmp/qmk_requirements.txt

WORKDIR /workspace
