@echo off

REM code by Rodrigo Miranda (rodrigo.qmiranda@gmail.com)
REM and Josicleda Galvincio (josicleda@gmail.com)

set g=%1
set q=%2
set divs=%3
set vetor=%4

set /A calc=%vetor%/%divs%
set /A mod=%vetor%%%divs%

setlocal EnableDelayedExpansion
set n=1
set lock=0
for /l %%i in (1,%calc%,%vetor%) do (
    if !lock!==1 (
        set /A min=!max!+1
    ) else (
        set min=%%i
    )

    if !mod! NEQ 0 (
        set lock=1
        set /A mod=!mod!-1
        set /A max=!min!+%calc%
    ) else (
        set /A max=!min!+%calc%-1
    )

    if !max! GEQ %vetor% (
        set max=%vetor%
    )

    if !n!==%q% (
        if %g%==0 (
            exit /b !min!
        )
        if %g%==1 (
            exit /b !max!
        )
    )
    
    if !max! GEQ %vetor% (
        goto :eof
    ) else (
        set /A n=!n!+1
    )
)
endlocal