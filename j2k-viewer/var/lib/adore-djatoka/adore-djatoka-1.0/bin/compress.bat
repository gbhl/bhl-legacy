@echo off

set DJATOKA_HOME=.
set KAKADU_HOME=.\Win32
set PATH=.\Win32;%JAVA_HOME%\bin
set JAVA_OPTS=-Djava.awt.headless=true  -Xmx512M -Xms64M -Dkakadu.home=%KAKADU_HOME%
set CLASSPATH=.;..\lib\adore-djatoka-1.0.jar;..\lib\commons-cli-1.1.jar;..\lib\ij.jar;..\lib\jai_codec.jar;..\lib\jai_core.jar;..\lib\kdu_jni.jar;..\lib\log4j-1.2.8.jar;..\lib\mlibwrapper_jai.jar;..\lib\oom.jar;..\lib\oomRef.jar

java %JAVA_OPTS% -classpath %CLASSPATH% gov.lanl.adore.djatoka.DjatokaCompress %*