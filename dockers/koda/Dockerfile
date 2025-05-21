
ARG USERNAME=kuser
ARG GROUPNAME=kgroup
ARG UID=5001
ARG GID=5001
ARG HOME_PATH=/home/$USER
ARG PROJECT_PATH=$HOME_PATH/koda

FROM debian:12.9-slim AS base
ARG PROJECT_PATH
ARG HOME_PATH
ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID

RUN apt-get update  \
    && apt-get -y --no-install-recommends install  \
        curl=7.88.1-10+deb12u8 \
        ca-certificates=20230311 \
        python3=3.11.2-1+b1 \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV MISE_DATA_DIR="${HOME_PATH}/mise"
ENV MISE_CONFIG_DIR="${HOME_PATH}/mise"
ENV MISE_CACHE_DIR="${HOME_PATH}/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"

ENV PATH="${HOME_PATH}/mise/shims:$PATH"
ENV MISE_VERSION="2025.2.7"
RUN curl https://mise.run | sh

RUN groupadd --gid "${GID}" "${GROUPNAME}" \
    && useradd --uid $UID --gid "${GID}" \
        --create-home --home-dir "${HOME_PATH}" \
        --shell /bin/bash "${USERNAME}" \
    && chown -R "${USERNAME}":"${GROUPNAME}" "${HOME_PATH}"

USER "${USERNAME}"
RUN mkdir -p "${PROJECT_PATH}"

ENV VIRTUAL_ENV="${PROJECT_PATH}/.venv/"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR "${PROJECT_PATH}"
COPY --chown="${USERNAME}":"${GROUPNAME}"  mise.toml .

# FIXME: KOD-26 Hack needed for removing pyproject entry 
RUN sed -i 's/^poetry.*/poetry = { version = "2.1.1" }/' mise.toml

COPY --chown="${USERNAME}":"${GROUPNAME}"  pyproject.toml .
COPY --chown="${USERNAME}":"${GROUPNAME}"  poetry.lock .

RUN mise trust \
    && mise install \
    && poetry config virtualenvs.in-project true

FROM base AS dev
ARG PROJECT_PATH
RUN poetry install
COPY --chown="${USERNAME}":"${GROUPNAME}"  . "${PROJECT_PATH}"

FROM base AS prod
ARG PROJECT_PATH
ARG USERNAME
ARG GROUPNAME
RUN poetry install --without dev
COPY --chown="${USERNAME}":"${GROUPNAME}"  . "${PROJECT_PATH}"
# Delete anything that is not needed for running the code in production
RUN find "${PROJECT_PATH}" -type d -name "tests" -exec rm -rf {} + \
    && find "${PROJECT_PATH}" -type f \( -name "test_*.py" -o -name "*_test.py" \) -delete \
    && find "${PROJECT_PATH}" -type f -name "Dockerfile" -exec rm -f {} + \
    && rm -rf "${PROJECT_PATH}/build" \
    && rm -rf "${PROJECT_PATH}/deploy" \
    && rm -rf "${PROJECT_PATH}/ideas" \
    && rm -rf "${PROJECT_PATH}/.tasks/development" \
    && rm -rf "${PROJECT_PATH}/mise.toml" \
    && rm -rf "${PROJECT_PATH}/poetry.lock" \
    && rm -rf "${PROJECT_PATH}/pyproject.toml" \
    && rm -rf "${PROJECT_PATH}/README.md"