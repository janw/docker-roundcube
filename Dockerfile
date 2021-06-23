FROM roundcube/roundcubemail:latest

WORKDIR /tmp
COPY install-plugins.sh ./
RUN ./install-plugins.sh \
    "kitist/html5_notifier" \
    "texxasrulez/persistent_login" \
    "prodrigestivill/gravatar" \
    "random-cuber/responses"
