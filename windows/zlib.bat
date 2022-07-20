@echo off

if "%~3"=="" (
    echo Syntax: %~n0%~x0 VCPKG_DIR PLATFORM OUTPUT_DIR
    exit /B 1
)

set VCPKG_DIR=%~1
set PLATFORM=%~2
set OUTPUT_DIR=%~3

set TRIPLET=%PLATFORM%-windows

echo Building zlib...

"%VCPKG_DIR%\vcpkg" --triplet "%TRIPLET%" install zlib || ^
exit /B 1

if not exist "%OUTPUT_DIR%\include"        ( mkdir "%OUTPUT_DIR%\include"        || exit /B 1 )
if not exist "%OUTPUT_DIR%\lib\%PLATFORM%" ( mkdir "%OUTPUT_DIR%\lib\%PLATFORM%" || exit /B 1 )

echo Copying files...

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\zlib*.dll" "%OUTPUT_DIR%\lib\%PLATFORM%" || ^
exit /B 1

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\zconf.h" "%OUTPUT_DIR%\include" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\zlib.h"  "%OUTPUT_DIR%\include" || ^
exit /B 1

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\lib\zlib*.lib" "%OUTPUT_DIR%\lib\%PLATFORM%" || ^
exit /B 1
