# Stage 1: Python Environment with Poetry and Python Packages
FROM python:3.10-slim AS python-env

# Set up environment variables for Poetry
ENV POETRY_VERSION='1.8.0' \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local'

# Install dependencies for Poetry
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Copy requirements.txt to temporary directory
COPY requirements.txt /tmp/requirements.txt

# Create a temporary Poetry project (packages-dependencies)
RUN poetry new packages-dependencies && \
    cd packages-dependencies && \
    poetry init --no-interaction --name "packages-dependencies" --version "0.1.0" --author "venpyr <>" && \
    poetry add $(cat /tmp/requirements.txt)

# Export Poetry dependencies to requirements.txt
RUN cd packages-dependencies && poetry export -f requirements.txt --without-hashes -o /tmp/requirements.txt

# Stage 2: R and Python Dependencies
FROM rocker/tidyverse:4.3.1 AS r-env

# Install R dependencies
RUN install2.r BH languageserver httpgd

# Install Python runtime dependencies to allow poetry to function correctly
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpython3.10-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy Poetry and Python packages from python-env
COPY --from=python-env /usr/local /usr/local

# Copy the pyproject.toml, poetry.lock, and requirements.txt files from the temporary Poetry project
COPY --from=python-env /tmp/requirements.txt /tmp/requirements.txt
COPY --from=python-env /packages-dependencies/pyproject.toml /tmp/pyproject.toml
COPY --from=python-env /packages-dependencies/poetry.lock /tmp/poetry.lock

WORKDIR /tmp
RUN poetry install --no-root

# Remove the temporary Poetry project
RUN rm -rf /packages-dependencies

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