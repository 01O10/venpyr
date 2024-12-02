# Stage 1: Python Environment with UV and Python Packages
FROM python:3.10-slim AS python-env

# Install pip (it should already be present, but we ensure the latest version)
RUN pip install --upgrade pip

# Install UV using pip (no need for Rust installation)
RUN pip install uv

# Copy requirements.txt to the container
COPY requirements.txt /tmp/requirements.txt

# Install dependencies using uv
RUN uv pip install --system -r /tmp/requirements.txt

# Stage 2: R and Python Dependencies
FROM rocker/tidyverse:4.3.1 AS r-env

# Install R dependencies
RUN install2.r BH languageserver httpgd

# Install Python runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpython3.10-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy uv and Python packages from python-env
COPY --from=python-env /usr/local/bin/* /usr/local/bin/

# Install additional dependencies
RUN apt-get update && apt-get install -y openssh-client

# ---- Add Git Identity Script ---- #
# Copy the script into the container
COPY scripts/set-git-config.sh /root/scripts/set-git-config.sh

# Make the script executable
RUN chmod +x /root/scripts/set-git-config.sh

# ---- Optional Working Directory ---- #
WORKDIR /app

# ---- Default Command ---- #
CMD ["bash"]
