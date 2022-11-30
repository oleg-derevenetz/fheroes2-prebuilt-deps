@echo off

if "%~3"=="" (
    echo Syntax: %~n0%~x0 VCPKG_DIR PLATFORM OUTPUT_DIR
    exit /B 1
)

set VCPKG_DIR=%~1
set PLATFORM=%~2
set OUTPUT_DIR=%~3

set TRIPLET=%PLATFORM%-windows-v140

echo Adding triplets...

xcopy /Y /Q "%~dp0\vcpkg_triplets\*.cmake" "%VCPKG_DIR%\triplets\community\" || ^
exit /B 1

echo Building sdl2 and dependencies...

set VCPKG_ROOT=%VCPKG_DIR%

"%VCPKG_DIR%\vcpkg" --triplet "%TRIPLET%" install libpng fluidsynth[buildtools,sndfile] sdl2 sdl2-mixer[fluidsynth,nativemidi] sdl2-image zlib || ^
exit /B 1

if not exist "%OUTPUT_DIR%\include\SDL2"         ( mkdir "%OUTPUT_DIR%\include\SDL2"         || exit /B 1 )
if not exist "%OUTPUT_DIR%\include\libpng16"     ( mkdir "%OUTPUT_DIR%\include\libpng16"     || exit /B 1 )
if not exist "%OUTPUT_DIR%\lib\%PLATFORM%"       ( mkdir "%OUTPUT_DIR%\lib\%PLATFORM%"       || exit /B 1 )
if not exist "%OUTPUT_DIR%\lib\debug\%PLATFORM%" ( mkdir "%OUTPUT_DIR%\lib\debug\%PLATFORM%" || exit /B 1 )

echo Copying files...

call :copy_dll "FLAC*"          && ^
call :copy_dll "gio*"           && ^
call :copy_dll "glib*"          && ^
call :copy_dll "gmodule*"       && ^
call :copy_dll "gobject*"       && ^
call :copy_dll "gthread*"       && ^
call :copy_dll "iconv*"         && ^
call :copy_dll "intl*"          && ^
call :copy_dll "libffi*"        && ^
call :copy_dll "libfluidsynth*" && ^
call :copy_dll "libmp3lame*"    && ^
call :copy_dll "libpng*"        && ^
call :copy_dll "mpg123*"        && ^
call :copy_dll "ogg*"           && ^
call :copy_dll "opus*"          && ^
call :copy_dll "pcre*"          && ^
call :copy_dll "SDL2*"          && ^
call :copy_dll "sndfile*"       && ^
call :copy_dll "vorbis*"        && ^
call :copy_dll "zlib*"          || ^
exit /B 1

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\debug\lib\SDL2*.lib"             "%OUTPUT_DIR%\lib\debug\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\debug\lib\libpng*.lib"           "%OUTPUT_DIR%\lib\debug\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\debug\lib\zlib*.lib"             "%OUTPUT_DIR%\lib\debug\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\debug\lib\manual-link\SDL2*.lib" "%OUTPUT_DIR%\lib\debug\%PLATFORM%" || ^
exit /B 1

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\SDL2\*.h"     "%OUTPUT_DIR%\include\SDL2"     && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\libpng16\*.h" "%OUTPUT_DIR%\include\libpng16" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\png.h"        "%OUTPUT_DIR%\include"          && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\pngconf.h"    "%OUTPUT_DIR%\include"          && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\pnglibconf.h" "%OUTPUT_DIR%\include"          && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\zconf.h"      "%OUTPUT_DIR%\include"          && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\include\zlib.h"       "%OUTPUT_DIR%\include"          || ^
exit /B 1

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\lib\SDL2*.lib"             "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\lib\libpng*.lib"           "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\lib\zlib*.lib"             "%OUTPUT_DIR%\lib\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\lib\manual-link\SDL2*.lib" "%OUTPUT_DIR%\lib\%PLATFORM%" || ^
exit /B 1

exit /B

:copy_dll

xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\%~1.dll"       "%OUTPUT_DIR%\lib\%PLATFORM%"       && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\bin\%~1.pdb"       "%OUTPUT_DIR%\lib\%PLATFORM%"       && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\debug\bin\%~1.dll" "%OUTPUT_DIR%\lib\debug\%PLATFORM%" && ^
xcopy /Y /Q "%VCPKG_DIR%\installed\%TRIPLET%\debug\bin\%~1.pdb" "%OUTPUT_DIR%\lib\debug\%PLATFORM%" || ^
exit /B 1

exit /B
