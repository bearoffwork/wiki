FROM public.ecr.aws/docker/library/node:20-alpine as builder

RUN set -eux \
    && apk add --no-cache bash \
    && npm install -g node-gyp



FROM node:18-alpine as dev

CMD ["yarn", "start"]



FROM app as production

COPY --from=hedgedoc-builder /hedgedoc /hedgedoc
