ARG N8N_VERSION="1.123.25"

FROM n8nio/n8n:${N8N_VERSION}

COPY ./entrypoint.sh /custom-entrypoint.sh

ENV SHELL /bin/sh
USER node

ENTRYPOINT ["/custom-entrypoint.sh"]
