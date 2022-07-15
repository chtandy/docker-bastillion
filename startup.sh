#!/bin/bash
# 2FA 持久化
SourceFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/bastillion.jceks
DistinationFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/bastillion.jceks
BatillionConfig=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties

function savejceks {
    cp $SourceFile $DistinationFile
}

trap savejceks EXIT

if [ -f $DistinationFile ];  then
    cp $DistinationFile $SourceFile
fi


sed -i -e 's|^dbPassword.*|dbPassword=Bastillion-jetty|' ${BatillionConfig}
sed -i -e 's|^keyManagementEnabled.*|keyManagementEnabled=false|' ${BatillionConfig}
sed -i -e 's|^forceUserKeyGeneration.*|forceUserKeyGeneration=false|' ${BatillionConfig}


if [ ! -z $PRIVATEKEYNAME ] && [ ! -z $PUBLICKEYNAME ]; then
    sed -i -e "s|^privateKey.*|privateKey=/data/$PRIVATEKEYNAME|" ${BatillionConfig}
    sed -i -e "s|^publicKey.*|publicKey=/data/$PUBLICKEYNAME|" ${BatillionConfig}
fi   

if [ ${EnableInternalAudio} == 'true' ]; then
    sed -i -e "s|enableInternalAudit.*|enableInternalAudit=true|" ${BatillionConfig}
fi

cd /Bastillion-jetty/jetty;
java ${JAVA_OPTS} -jar start.jar
