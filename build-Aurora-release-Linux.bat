@ECHO OFF

set folderName="Aurora-Sim-0.8-Release"

rem ## Default architecture (86 (for 32bit), 64, AnyCPU)
set bits=AnyCPU

rem ## Whether or not to add the .net3.5 flag
set framework=4_0

rem ## Default "configuration" choice ((r)elease, (d)ebug)
set configuration=d

set conditionals=LINUX;

echo ====================================
echo ========== GETTING AURORA ==========
echo ====================================
echo.

git clone --progress -v git://github.com/aurora-sim/Aurora-Sim.git "%folderName%"

cd %folderName%

echo ====================================
echo ========= AURORA  BUILDING =========
echo ====================================
echo.

if exist Compile.*.bat (
    echo Deleting previous compile batch file...
    echo.
    del Compile.*.bat
)

bin\Prebuild.exe /target vs2010 /targetframework v%framework% /conditionals %conditionals%NET_%framework%

set fpath=C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\msbuild
if %bits%==x64 set args=/p:Platform=x64
if %bits%==x86 set args=/p:Platform=x86
if %configuration%==r  (
    set cfg=/p:Configuration=Release
    set configuration=release
)
if %configuration%==d  (
set cfg=/p:Configuration=Debug
set configuration=debug
)
if %configuration%==release set cfg=/p:Configuration=Release
if %configuration%==debug set cfg=/p:Configuration=Debug
set filename=Compile.VS2010.net%framework%.%bits%.%configuration%.bat

echo %fpath% Aurora.sln %args% %cfg% > %filename% /p:DefineConstants="%conditionals%NET_%framework%"

call %filename%

echo Finished building the release
pause