FROM mcr.microsoft.com/windows/servercore:ltsc2016

# setup chocolatey
ENV chocolateyUseWindowsCompression=false
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
RUN choco config set cachelocation C:\chococache

# install prereqs for test engine
RUN choco install \
openjdk13 \
--confirm \
&& rmdir /S /Q C:\chococache

EXPOSE 8080 8443

COPY maven C:/maven/
COPY entry-point.cmd C:/maven/

WORKDIR C:/maven/

ENTRYPOINT ["C:/maven/entry-point.cmd"]
