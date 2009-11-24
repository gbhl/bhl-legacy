@echo off

rem Ensure you have JAVA_HOME and CATALINA_HOME variables set
rem set JAVA_HOME=...\jdk1.5.0_16
rem set CATALINA_HOME=...\apache-tomcat-5.5.27
rem set PATH=%PATH%;%JAVA_HOME%\bin

set DJATOKA_HOME=.
set KAKADU_HOME=Win32
set PATH=%KAKADU_HOME%;%JAVA_HOME%\bin;%PATH%
set JAVA_OPTS=-Djava.awt.headless=true -Xmx512M -Xms64M -Dkakadu.home=%KAKADU_HOME% -Djava.library.path=%KAKADU_HOME%

"%CATALINA_HOME%/bin/catalina.bat" start


