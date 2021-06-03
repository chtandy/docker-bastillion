#!/bin/bash
# 2FA 持久化
SourceFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/bastillion.jceks
DistinationFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/bastillion.jceks

if [ ! -f $DistinationFile ];  then
    cp $SourceFile $DistinationFile
    ln -sf $DistinationFile $SourceFile 
else
    #rm -f $SourceFile
    ln -sf $DistinationFile $SourceFile
fi

if [ ! -z $PRIVATEKEYNAME ] && [ ! -z $PUBLICKEYNAME ]; then
    sed -i -e "s|^privateKey.*|privateKey=/data/$PRIVATEKEYNAME|" /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
    sed -i -e "s|^publicKey.*|publicKey=/data/$PUBLICKEYNAME|" /Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
fi   

cd jetty;
java ${JAVA_OPTS} -jar start.jar
