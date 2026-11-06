FROM alpine:3.20
RUN apk add --no-cache curl unzip ca-certificates
WORKDIR /app
RUN curl -fsSL -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
 && unzip -o xray.zip xray \
 && rm xray.zip \
 && chmod +x xray
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENV PORT=8080
ENV UUID=34eb6fde-d911-4547-bfa0-0f11d9fe3985
ENV WS_PATH=ws-d9c71cb1
EXPOSE 8080
CMD ["/app/entrypoint.sh"]
