FROM pierrezemb/gostatic:latest

COPY dist/ /dist

EXPOSE 8080
ENTRYPOINT [ "/goStatic", "-enable-health", "-port", "8080", "-path", "/dist" ]