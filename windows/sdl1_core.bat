@echo off

if "%~1"=="" (
    echo Syntax: %~n0%~x0 OUTPUT_DIR
    exit /B 1
)

set OUTPUT_DIR=%~1

set SDL_FILE=SDL-devel-1.2.15-VC.zip
set SDL_FILE_SHA256=7443EE5CD1BD2A0F9FA8C01ACBEB4C779D0B03F9CE8A2AA47B0637D2A5461E50
set SDL_URL=https://www.libsdl.org/release/%SDL_FILE%

set SDL_MIXER_FILE=SDL_mixer-devel-1.2.12-VC.zip
set SDL_MIXER_FILE_SHA256=25084EB2B3C49FEA38D01E24B172109BAE07C0AC82B1765D5C179026A164387B
set SDL_MIXER_URL=https://www.libsdl.org/projects/SDL_mixer/release/%SDL_MIXER_FILE%

call :download_archive "%SDL_URL%"       "%TEMP%\%SDL_FILE%"       "%SDL_FILE_SHA256%"       && ^
call :download_archive "%SDL_MIXER_URL%" "%TEMP%\%SDL_MIXER_FILE%" "%SDL_MIXER_FILE_SHA256%" || ^
exit /B 1

if not exist "%OUTPUT_DIR%\include\SDL" ( mkdir "%OUTPUT_DIR%\include\SDL" || exit /B 1 )
if not exist "%OUTPUT_DIR%\lib"         ( mkdir "%OUTPUT_DIR%\lib"         || exit /B 1 )

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

:download_archive

echo Downloading %~1

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%~1', '%~2')" || ^
exit /B 1

set HASH_CALCULATED=false

for /F "usebackq delims=" %%H in (`powershell -Command "(Get-FileHash -Path '%~2' -Algorithm SHA256).Hash"`) do (
    set HASH_CALCULATED=true

    if not "%%H" == "%~3" (
        echo Invalid hash for %~n1%~x1: expected %~3, got %%H
        exit /B 1
    )
)

if not "%HASH_CALCULATED%" == "true" (
    echo Failed to calculate hash for %~n1%~x1
    exit /B 1
)

exit /B

:unpack_archive

echo Unpacking %~n1%~x1

powershell -Command "Expand-Archive -LiteralPath '%~1' -DestinationPath '%~2' -Force" || ^
exit /B 1

exit /B
