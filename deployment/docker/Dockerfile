FROM docker.io/python:3.9.7 AS build

RUN set -eux \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /summarizer

COPY requirements.txt .

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

FROM docker.io/python:3.9.7-slim AS release

RUN set -eux \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get clean \
    && apt-get install -y \
        curl \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME
ENV USERNAME ${USERNAME:-"kaltura"}

RUN groupadd -r ${USERNAME} \
    && useradd -m -g ${USERNAME} ${USERNAME}

COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

WORKDIR /summarizer

COPY . .

ENV PYTHONUNBUFFERED 1

USER ${USERNAME}
