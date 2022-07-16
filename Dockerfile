FROM openjdk:bullseye
ARG BASTILLION_VERSION
RUN wget https://github.com/bastillion-io/Bastillion/releases/download/v${BASTILLION_VERSION}.0/bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz \
  && tar -xzvf bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz \
  && rm -f bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz

## 開啟審計功能
RUN sed -i '/<Loggers>/a\        </Logger>' /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/log4j2.xml \
  && sed -i '/<Loggers>/a\            <AppenderRef ref="audit-appender"/' /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/log4j2.xml \
  && sed -i '/<Loggers>/a\        <Logger name="io.bastillion.manage.util.SystemAudit" level="info" additivity="false">' /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/log4j2.xml

COPY startup.sh /
RUN chmod +x /startup.sh
EXPOSE 8443
ENTRYPOINT ["/startup.sh"]
