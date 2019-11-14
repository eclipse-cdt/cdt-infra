# escape=`
FROM mcr.microsoft.com/windows/servercore:1809
# FROM mcr.microsoft.com/dotnet/framework/sdk:4.8
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

### XXX: To future maintainers - I intended to use chocolatey, but the gdbserver (part of mingw64 package) that comes with 
### is version 8.1 that does not work on Windows, see https://github.com/bminor/binutils-gdb/commit/906994d9d50eb40dc89a5bf0830e15ed10938641
### The rest of this comment block was that work that I (Jonah) didn't want to delete yet.

# Download and install https://chocolatey.org as our package manager
# TODO Is there some cache of chocolatey that should be cleared out (similar to doing rm -rf /var/lib/apt/lists/* when using apt)
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Git - includes git bash on windows which we use as the entrypoint at the end
RUN choco  install --yes --nocolor --no-progress git

# COPY --from=cdt-infra-windows-toolchain:servercore-1809 C:\tools\msys64\mingw64 C:\tools\msys64\mingw64

RUN choco  install --yes --nocolor --no-progress make nodejs-lts yarn
ENV PYTHONIOENCODING UTF-8
# Use choco instead of this command: npm install --global --production windows-build-tools
RUN choco  install --yes --nocolor --no-progress python2
RUN choco  install --yes --nocolor --no-progress visualstudio2017buildtools
RUN npm config set msvs_version 2017
RUN mkdir c:/work
RUN git clone https://github.com/eclipse-cdt/cdt-gdb-adapter.git
# To use this image you can do (in powershell):
#  docker run --rm -it  -v ${pwd}:c:/work  -w c:/work IMAGENAME
ENTRYPOINT [ "\\Program Files\\Git\\bin\\bash" ]
