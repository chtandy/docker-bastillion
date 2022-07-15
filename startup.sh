#!/bin/bash
# 2FA 持久化
SourceFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/bastillion.jceks
DistinationFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/bastillion.jceks
BatillionConfig=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties

if [ ! -f $DistinationFile ];  then
    mv $SourceFile $DistinationFile
    ln -sf $DistinationFile $SourceFile
else
    rm -f $SourceFile
    ln -sf $DistinationFile $SourceFile
fi

sed -i -e 's|^dbPassword.*|dbPassword=Bastillion-jetty|' ${BatillionConfig}
sed -i -e 's|^keyManagementEnabled.*|keyManagementEnabled=false|' ${BatillionConfig}
sed -i -e 's|^forceUserKeyGeneration.*|forceUserKeyGeneration=false|' ${BatillionConfig}



if [ ! -z $PRIVATEKEYNAME ] && [ ! -z $PUBLICKEYNAME ]; then
    sed -i -e "s|^privateKey.*|privateKey=/data/$PRIVATEKEYNAME|" ${BatillionConfig}
    sed -i -e "s|^publicKey.*|publicKey=/data/$PUBLICKEYNAME|" ${BatillionConfig}
fi   


cd /Bastillion-jetty/jetty;
java ${JAVA_OPTS} -jar start.jar
