@echo off

REM code by Rodrigo Miranda (rodrigo.qmiranda@gmail.com)
REM and Josicleda Galvincio (josicleda@gmail.com)

set procs=%1
set sims=%2
set id=%3

setlocal EnableDelayedExpansion
set /A "step=100/%procs%"
set count=0
for /l %%n in (1,1,%procs%) do (
	call SamplesSwatpy.bat 0 %%n %procs% %sims%
	set min=!ERRORLEVEL!
	echo !min! : starting simulation number > ParallelSwatpy\worker%%n\SUFI2_swEdit.def
	call SamplesSwatpy.bat 1 %%n %procs% %sims%
	set max=!ERRORLEVEL!
	echo !max! : ending simulation number >> ParallelSwatpy\worker%%n\SUFI2_swEdit.def
	set /A "pbar=%%n*%step%"
	set /A count+=1
	if !count!==%procs% job modify %id% /progress:100
	if not !count!==%procs% job modify %id% /progress:%pbar%
)
endlocal