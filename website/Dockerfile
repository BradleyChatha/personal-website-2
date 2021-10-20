FROM pierrezemb/gostatic:latest

COPY website/dist/ /dist

EXPOSE 8080
ENTRYPOINT [ "/goStatic", "-enable-health", "-port", "8080", "-path", "/dist" ]