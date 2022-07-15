FROM openjdk:bullseye
ARG BASTILLION_VERSION
RUN wget https://github.com/bastillion-io/Bastillion/releases/download/v${BASTILLION_VERSION}.0/bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz \
  && tar -xzvf bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz \
  && rm -f bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz

COPY startup.sh /
RUN chmod +x /startup.sh
EXPOSE 8443
ENTRYPOINT ["/startup.sh"]
