FROM alpine:3.20 AS builder

RUN apk add --no-cache unzip

ENV REDMINE_PLUGINS=/build/plugins
WORKDIR ${REDMINE_PLUGINS}

ARG PLUGINS_VERSION=latest

COPY plugins/ .

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
        echo "No plugins found"; \
    fi; \
    rm -f *.zip; \
    find . -type d -name "__MACOSX" -exec rm -rf {} + || true; \
    find . -type f -name "._*" -delete; \
    find . -type f -name ".DS_Store" -delete


FROM alpine:3.20

ARG PLUGINS_VERSION=latest

ENV REDMINE_PLUGINS=/usr/src/redmine/plugins
ENV INITDB=/docker-entrypoint-initdb.d

RUN mkdir -p ${REDMINE_PLUGINS} ${INITDB}

COPY --from=builder /build/plugins/ ${REDMINE_PLUGINS}/
COPY initdb/ ${INITDB}/

# Fix security vulnerability in CodeMirror (CVE-2020-7760)
RUN apk add --no-cache nodejs npm && \
    if [ -d "${REDMINE_PLUGINS}/redmineup_cms/assets/codemirror/node_modules/codemirror" ]; then \
        rm -rf "${REDMINE_PLUGINS}/redmineup_cms/assets/codemirror/node_modules/codemirror" && \
        cd "${REDMINE_PLUGINS}/redmineup_cms/assets/codemirror" && \
        npm install codemirror@5.65.2 --save 2>/dev/null || true && \
        npm cache clean --force || true; \
        apk del nodejs npm; \
    fi

RUN set -eux; \
    chown -R 999:999 ${REDMINE_PLUGINS}; \
    find ${REDMINE_PLUGINS} -type d -exec chmod 755 {} \; ; \
    find ${REDMINE_PLUGINS} -type f -exec chmod 644 {} \; ; \
    chmod 644 ${INITDB}/*.sql 2>/dev/null || true

VOLUME ${REDMINE_PLUGINS}
VOLUME ${INITDB}

LABEL org.opencontainers.image.title="redmine-plugins" \
      org.opencontainers.image.description="Preloaded Redmine plugins image" \
      org.opencontainers.image.version="${PLUGINS_VERSION}" \
      org.opencontainers.image.authors="afreisinger"