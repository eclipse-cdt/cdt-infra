# escape=`
FROM mcr.microsoft.com/windows/servercore:1809
# FROM mcr.microsoft.com/dotnet/framework/sdk:4.8
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Download and install https://chocolatey.org as our package manager
# TODO Is there some cache of chocolatey that should be cleared out (similar to doing rm -rf /var/lib/apt/lists/* when using apt)
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Git - includes git bash on windows which we use as the entrypoint at the end
RUN choco  install --yes --nocolor --no-progress git

RUN choco  install --yes --nocolor --no-progress make nodejs-lts yarn

COPY --from=cdt-infra-windows-toolchain:servercore-1809 C:\tools\msys64\mingw64 C:\tools\msys64\mingw64

RUN mkdir c:/work
RUN git clone https://github.com/eclipse-cdt/cdt-gdb-adapter.git
# Setting environment variables properly in Windows containers cannot be done with ENV - for 
# our purposes using a .bashrc is a good workaround. See https://github.com/moby/moby/issues/22017
COPY cdt-infra-windows\servercore-1809\windows.bashrc c:\Users\ContainerAdministrator\.bashrc
# To use this image you can do (in powershell):
#  docker run --rm -it  -v ${pwd}:c:/work  -w c:/work IMAGENAME
ENTRYPOINT [ "\\Program Files\\Git\\bin\\bash" ]
