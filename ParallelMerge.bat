@echo off

REM code by Rodrigo Miranda (rodrigo.qmiranda@gmail.com)
REM and Josicleda Galvincio (josicleda@gmail.com)

REM n=1 means first proc
REM n>1 means rest of procs

set first=%1
set procs=%2
set file=%3

if %first%==0 goto :first
if %first%==1 goto :rest

:first
copy ParallelSwatpy\worker1\Par_Name.Out Par_Name.Out
copy ParallelSwatpy\worker1\Echo\*.* Echo
exit

:rest
for /l %%n in (1,1,%procs%) do (
	for /f "tokens=*" %%l in (ParallelSwatpy\worker%%n\SUFI2.OUT\%file%) do (
		echo %%l >> SUFI2.OUT\%file%
	)
)
exit