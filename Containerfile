FROM alpine:3.19

ENV SYNC_OUTPUT_ENV_FILE=/out/secrets.env
ENV SYNC_INTERVAL_SECONDS=3600

RUN mkdir /out /app; \
  echo https://downloads.1password.com/linux/alpinelinux/stable/ >> /etc/apk/repositories; \
  wget https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub -P /etc/apk/keys; \
  apk update; apk add 1password-cli powershell

WORKDIR /app
ADD portainer-sync.ps1 .

CMD [ "/usr/bin/pwsh", "portainer-sync.ps1" ]