#!/bin/bash

# 2FA 持久化
SourceFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/bastillion.jceks
DistinationFile=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb/bastillion.jceks
DistinationDir=/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/keydb

if [ ! -f $DistinationFile ];  then
    mv $SourceFile $DistinationFile
    ln -s $DistinationFile $SourceFile 
elif [ -f $DistinationDir ]; then
    rm -f $SourceFile
    ln -s $DistinationFile $SourceFile
fi

cd jetty;
java ${JAVA_OPTS} -jar start.jar
