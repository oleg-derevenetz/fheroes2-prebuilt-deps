@echo off

if "%~3"=="" (
    echo Syntax: %~n0%~x0 VCPKG_DIR PLATFORM OUTPUT_DIR
    exit /B 1
)

set VCPKG_DIR=%~1
set PLATFORM=%~2
set OUTPUT_DIR=%~3

set TRIPLET=%PLATFORM%-windows

echo Building sdl2 and dependencies...

"%VCPKG_DIR%\vcpkg" --triplet "%TRIPLET%" install fluidsynth[buildtools,sndfile] sdl2 sdl2-mixer[fluidsynth,nativemidi] sdl2-image zlib || ^
exit /B 1

if not exist "%OUTPUT_DIR%\include"        ( mkdir "%OUTPUT_DIR%\include"        || exit /B 1 )
if not exist "%OUTPUT_DIR%\include\SDL2"   ( mkdir "%OUTPUT_DIR%\include\SDL2"   || exit /B 1 )
if not exist "%OUTPUT_DIR%\lib\%PLATFORM%" ( mkdir "%OUTPUT_DIR%\lib\%PLATFORM%" || exit /B 1 )

echo Copying files...

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\FLAC*.dll"          "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\gio*.dll"           "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\glib*.dll"          "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\gmodule*.dll"       "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\gobject*.dll"       "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\gthread*.dll"       "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\iconv*.dll"         "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\intl*.dll"          "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\libffi*.dll"        "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\libfluidsynth*.dll" "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\libmp3lame*.dll"    "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\libpng*.dll"        "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\mpg123*.dll"        "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\ogg*.dll"           "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\opus*.dll"          "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\pcre*.dll"          "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\SDL2*.dll"          "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\sndfile*.dll"       "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\vorbis*.dll"        "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\zlib*.dll"          "%OUTPUT_DIR%\lib\%PLATFORM%" || ^
exit /B 1

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\SDL2\*.*" "%OUTPUT_DIR%\include\SDL2" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\zconf.h"  "%OUTPUT_DIR%\include"      && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\zlib.h"   "%OUTPUT_DIR%\include"      || ^
exit /B 1

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\lib\SDL2*.lib" "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\lib\zlib*.lib" "%OUTPUT_DIR%\lib\%PLATFORM%" || ^
exit /B 1
