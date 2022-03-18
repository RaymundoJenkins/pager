FROM alpine
MAINTAINER Richard Anthony <public.rant@pm.me>

ARG pkg

RUN apk add $pkg
RUN apk add gettext

