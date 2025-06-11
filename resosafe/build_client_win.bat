set STORE_SYMBOLS=true
set SIGN=true


set GIT_SERVER_REPOSITORY="git@github.com:resosafe/urbackup_backend.git"
set GIT_CLIENT_REPOSITORY="git@github.com:resosafe/urbackup_frontend_wx.git"

set BRANCH="resosafe_2.5.x"
set DEST_DIR="%~dp0/urbackup_backend_build"
set VISUAL_STUDIO_PATH="C:\Program Files\Microsoft Visual Studio\2022"


rmdir /s /q %DEST_DIR%
echo Cloning repository %GIT_SERVER_REPOSITORY% to %DEST_DIR%
git clone %GIT_SERVER_REPOSITORY% %DEST_DIR%
cd %DEST_DIR%
git checkout %BRANCH%
git clone %GIT_CLIENT_REPOSITORY% client
cd client
git checkout %BRANCH%
cd ..


./switch_build.sh client
cd resosafe
python3 replace_versions.py version.json
cd ..


call %VISUAL_STUDIO_PATH%"\Community\VC\Auxiliary\Build\vcvarsamd64_x86.bat"

msbuild UrBackupBackend.sln /p:Configuration=Release /p:Platform="win32"  /p:vcpkgTriplet="x86-windows-static-md"
if %errorlevel% neq 0 exit /b %errorlevel% 

msbuild UrBackupBackend.sln /p:Configuration=Release /p:Platform="x64"  /p:vcpkgTriplet="x64-windows-static-md"
if %errorlevel% neq 0 exit /b %errorlevel%

msbuild CompiledServer.vcxproj /p:Configuration="Release Service" /p:Platform="x64"  /p:vcpkgTriplet="x64-windows-static-md"
if %errorlevel% neq 0 exit /b %errorlevel%

msbuild CompiledServer.vcxproj /p:Configuration="Release Service" /p:Platform="win32"  /p:vcpkgTriplet="x86-windows-static-md"
if %errorlevel% neq 0 exit /b %errorlevel%




cd client
call build_client.bat
if %errorlevel% neq 0 exit /b %errorlevel%

if NOT "%STORE_SYMBOLS%" == "true" GOTO skip_symbols

echo|set /p="set build_revision=" > "build_revision.bat"
git rev-parse HEAD >> "build_revision.bat"
call build_revision.bat

cd "%~dp0"


copy /Y "Release\urbackupclient.dll" "Release\urbackup.dll"
copy /Y "x64\Release\urbackupclient.dll" "x64\Release\urbackup.dll"


FOR /F "tokens=*" %%G IN (pdb_dirs_client.txt) DO symstore add /compress /r /f "%~dp0%%G" /s "C:\symstore" /t "UrBackup Client /v "%build_revision%" /c "Release"

:skip_symbols

exit 0