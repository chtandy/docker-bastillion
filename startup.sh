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

cd jetty;
java ${JAVA_OPTS} -jar start.jar
