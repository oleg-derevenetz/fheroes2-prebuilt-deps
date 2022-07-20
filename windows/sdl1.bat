@echo off

if "%~1"=="" (
    echo Syntax: %~n0%~x0 OUTPUT_DIR
    exit /B 1
)

set OUTPUT_DIR=%~1

set SDL_FILE=SDL-devel-1.2.15-VC.zip
set SDL_MIXER_FILE=SDL_mixer-devel-1.2.12-VC.zip

set SDL_URL=https://www.libsdl.org/release/%SDL_FILE%
set SDL_MIXER_URL=https://www.libsdl.org/projects/SDL_mixer/release/%SDL_MIXER_FILE%

echo Downloading %SDL_URL%                                                                                         && ^
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%SDL_URL%',       '%TEMP%\%SDL_FILE%')"       && ^
echo Downloading %SDL_MIXER_URL%                                                                                   && ^
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%SDL_MIXER_URL%', '%TEMP%\%SDL_MIXER_FILE%')" || ^
exit /B 1

if not exist "%OUTPUT_DIR%\include"        ( mkdir "%OUTPUT_DIR%\include"        || exit /B 1 )
if not exist "%OUTPUT_DIR%\include\SDL"    ( mkdir "%OUTPUT_DIR%\include\SDL"    || exit /B 1 )
if not exist "%OUTPUT_DIR%\lib\%PLATFORM%" ( mkdir "%OUTPUT_DIR%\lib\%PLATFORM%" || exit /B 1 )

call :unpack_archive "%TEMP%\%SDL_FILE%"       "%TEMP%" && ^
call :unpack_archive "%TEMP%\%SDL_MIXER_FILE%" "%TEMP%" || ^
exit /B 1

echo Copying files...

xcopy /Y /S /Q "%TEMP%\SDL-1.2.15\include"       "%OUTPUT_DIR%\include\SDL" && ^
xcopy /Y /S /Q "%TEMP%\SDL-1.2.15\lib"           "%OUTPUT_DIR%\lib"         && ^
xcopy /Y /S /Q "%TEMP%\SDL_mixer-1.2.12\include" "%OUTPUT_DIR%\include\SDL" && ^
xcopy /Y /S /Q "%TEMP%\SDL_mixer-1.2.12\lib"     "%OUTPUT_DIR%\lib"         || ^
exit /B 1

exit /B

:unpack_archive

echo Unpacking %~n1%~x1

if "%CI%" == "true" (
    powershell -Command "Expand-Archive -LiteralPath '%~1' -DestinationPath '%~2' -Force" || exit /B 1
) else (
    powershell -Command "$shell = New-Object -ComObject 'Shell.Application'; $zip = $shell.NameSpace((Resolve-Path '%~1').Path); foreach ($item in $zip.items()) { $shell.Namespace((Resolve-Path '%~2').Path).CopyHere($item, 0x14) }" || exit /B 1
)

exit /B
