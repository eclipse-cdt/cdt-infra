# escape=`
FROM mcr.microsoft.com/windows/servercore:1809
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Download and install https://chocolatey.org as our package manager
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#### Install mingw64 tools (gcc, gdb) ####
# I can't install mingw using chocolatey because it has outofdate gdbserver with this bug: https://github.com/bminor/binutils-gdb/commit/906994d9d50eb40dc89a5bf0830e15ed10938641
# If chocolatey gets a version newer than 8.1 of gdbserver then the following block can be replaced with just installing mingw!
# Instead install msys2 and use msys2 to install mingw64
# Updating msys2 requires pacman to be be updated in a "weird" way that causes docker build to hang - therefore we don't update the core
# of msys2 and instead, just install the mingw64 packages we want.
RUN choco  install --yes --nocolor --no-progress msys2 --params /NoUpdate
# I had trouble getting pacman to run via powershell, so temporaily change to cmd.
SHELL ["cmd.exe", "/c"]
RUN c:\tools\msys64\usr\bin\bash.exe -lc "pacman --noconfirm -Sy mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb"

