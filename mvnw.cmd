@REM Maven Wrapper (only-script) para Windows
@echo off
setlocal
set "BASEDIR=%~dp0"
set "PROPS=%BASEDIR%.mvn\wrapper\maven-wrapper.properties"
for /f "usebackq tokens=1,* delims==" %%A in ("%PROPS%") do if "%%A"=="distributionUrl" set "DIST_URL=%%B"
for %%F in ("%DIST_URL%") do set "DIST_FILE=%%~nxF"
set "DIST_NAME=%DIST_FILE:-bin.tar.gz=%"
if "%MAVEN_USER_HOME%"=="" set "MAVEN_USER_HOME=%USERPROFILE%\.m2"
set "WRAPPER_HOME=%MAVEN_USER_HOME%\wrapper\dists\%DIST_NAME%"
set "MAVEN_HOME=%WRAPPER_HOME%\%DIST_NAME%"
if not exist "%MAVEN_HOME%\bin\mvn.cmd" (
  if not exist "%WRAPPER_HOME%" mkdir "%WRAPPER_HOME%"
  echo mvnw: descargando %DIST_URL%
  powershell -NoProfile -Command "Invoke-WebRequest -UseBasicParsing -Uri '%DIST_URL%' -OutFile '%WRAPPER_HOME%\%DIST_FILE%'" || exit /b 1
  tar -xzf "%WRAPPER_HOME%\%DIST_FILE%" -C "%WRAPPER_HOME%" || exit /b 1
  del "%WRAPPER_HOME%\%DIST_FILE%"
)
"%MAVEN_HOME%\bin\mvn.cmd" -f "%BASEDIR%pom.xml" %*
