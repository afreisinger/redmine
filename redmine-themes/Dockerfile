FROM alpine:3.20 AS builder

RUN apk add --no-cache unzip

WORKDIR /build

ARG THEMES_VERSION=latest

COPY themes/ .

RUN set -eux; \
    ls -lah; \
    files=$(ls *.zip 2>/dev/null || true); \
    if [ -n "$files" ]; then \
        for f in $files; do \
            echo "==> Testing $f"; \
            unzip -t "$f"; \
        done; \
        for f in $files; do \
            echo "==> Extracting $f"; \
            unzip -oq "$f"; \
        done; \
    else \
        echo "No themes found"; \
    fi; \
    rm -f *.zip; \
    find . -type d -name "__MACOSX" -exec rm -rf {} + || true; \
    find . -type f -name "._*" -delete; \
    find . -type f -name ".DS_Store" -delete; \
    echo "==> Themes extraídos:"; \
    ls -lah


FROM alpine:3.20

ARG THEMES_VERSION=latest

ENV REDMINE_THEMES=/usr/src/redmine/themes

RUN mkdir -p ${REDMINE_THEMES}

COPY --from=builder /build/ ${REDMINE_THEMES}/

RUN set -eux; \
    echo "==> Verificando themes:"; \
    ls -lah ${REDMINE_THEMES}/; \
    chown -R 999:999 ${REDMINE_THEMES}; \
    find ${REDMINE_THEMES} -type d -exec chmod 755 {} \; ; \
    find ${REDMINE_THEMES} -type f -exec chmod 644 {} \;

VOLUME ${REDMINE_THEMES}

LABEL org.opencontainers.image.title="redmine-themes" \
      org.opencontainers.image.description="Preloaded Redmine themes image" \
      org.opencontainers.image.version="${THEMES_VERSION}" \
      org.opencontainers.image.authors="afreisinger"