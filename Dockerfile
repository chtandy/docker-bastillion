FROM openjdk:bullseye
ARG BASTILLION_VERSION
RUN wget https://github.com/bastillion-io/Bastillion/releases/download/v${BASTILLION_VERSION}.0/bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz \
  && tar -xzvf bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz \
  && rm -f bastillion-jetty-v${BASTILLION_VERSION}_00.tar.gz

## 開啟審計功能
RUN sed -i '/<Loggers>/a\        </Logger>' /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/log4j2.xml \
  && sed -i '/<Loggers>/a\            <AppenderRef ref="audit-appender"/' /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/log4j2.xml \
  && sed -i '/<Loggers>/a\        <Logger name="io.bastillion.manage.util.SystemAudit" level="info" additivity="false">' /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/log4j2.xml

## 修改entrypoint, 修改環境後執行bastillion 
RUN { \
     echo '#!/bin/bash'; \
     echo 'SourceFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/bastillion.jceks'; \
     echo 'DistinationFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/bastillion.jceks'; \
     echo 'BatillionConfig=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties'; \
     echo 'function savejceks {'; \
     echo '    cp $SourceFile $DistinationFile'; \
     echo '}'; \
     echo 'trap savejceks EXIT'; \
     echo 'if [ -f $DistinationFile ];  then'; \
     echo '    cp $DistinationFile $SourceFile'; \
     echo 'fi'; \
     echo 'sed -i -e "s|^dbPassword.*|dbPassword=Bastillion-jetty|" ${BatillionConfig}'; \
     echo 'sed -i -e "s|^keyManagementEnabled.*|keyManagementEnabled=false|" ${BatillionConfig}'; \
     echo 'sed -i -e "s|^forceUserKeyGeneration.*|forceUserKeyGeneration=false|" ${BatillionConfig}'; \
     echo 'if [ ! -z $PRIVATEKEYNAME ] && [ ! -z $PUBLICKEYNAME ]; then'; \
     echo '    sed -i -e "s|^privateKey.*|privateKey=/data/$PRIVATEKEYNAME|" ${BatillionConfig}'; \
     echo '    sed -i -e "s|^publicKey.*|publicKey=/data/$PUBLICKEYNAME|" ${BatillionConfig}'; \
     echo 'fi'; \
     echo 'if [ ${EnableInternalAudio} == "true" ]; then'; \
     echo '    sed -i -e "s|^enableInternalAudit.*|enableInternalAudit=true|" ${BatillionConfig}'; \
     echo 'fi'; \
     echo 'cd /Bastillion-jetty/jetty;'; \
     echo 'java ${JAVA_OPTS} -jar start.jar'; \
     } > /startup.sh \
     && chmod +x /startup.sh

EXPOSE 8443
ENTRYPOINT ["/startup.sh"]
