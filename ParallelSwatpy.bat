@echo off
cls

REM code by Rodrigo Miranda (rodrigo.qmiranda@gmail.com)
REM and Josicleda Galvincio (josicleda@gmail.com)

REM Usage: ParallelSwatpy.bat <procs> <nodes> <sims> \\headnode\cluster_swatcup pontal.Sufi2.SwatCup

set procs=%1
set nodes=%2
set sims=%3
set wdir=%4
set proj=%5

:precheck
for /l %%n in (1,1,%procs%) do (
	for /D %%d in (*) do (
		if exist ParallelSwatpy\worker%%n (
			set clean=1
			goto :preclean
		)
	)
)
set clean=0

for /f  "usebackq  tokens=4 delims=. " %%i in (`job new /parentjobids:%id%`) do (
	set id=%%i
	goto :copy_files
)

:copy_files
setlocal
for /l %%n in (1,1,%procs%) do (
	for /D %%d in (*) do (
		if not %%d==ParallelProcessing (
			if not %%d==Iterations (
				if not %%d==ParallelSwatpy (
					if not exist ParallelSwatpy\worker%%n\%%d (
						job add %id% /name:create_tree /workdir:%wdir%\%proj%\ParallelSwatpy "md worker%%n\%%d"
					)
				)
			)
		)
		if %%d==Backup (
			job add %id% /depend:create_tree /workdir:%wdir%\%proj% "xcopy /D %%d\*.* ParallelSwatpy\worker%%n\%%d"
		)
		if %%d==SUFI2.IN (
			job add %id% /depend:create_tree /workdir:%wdir%\%proj% "xcopy /D %%d\*.* ParallelSwatpy\worker%%n\%%d"
		)
	)
	job add %id% /depend:create_tree /workdir:%wdir% "xcopy /D %proj%\*.* %proj%\ParallelSwatpy\worker%%n"
)
endlocal
job submit /id:%id% /jobname:"Distribute files" /numnodes:%nodes%

for /f  "usebackq  tokens=4 delims=. " %%i in (`job new /parentjobids:%id%`) do (
	set id=%%i
	goto :get_samples
)

:get_samples
setlocal
job add %id% /workdir:%wdir%\%proj% "ParallelSamples.bat %procs% %sims% %id%"
endlocal
job submit /id:%id% /jobname:"Organize samples"

for /f  "usebackq  tokens=4 delims=. " %%i in (`job new /parentjobids:%id%`) do (
	set id=%%i
	goto :run_swat
)

:run_swat
setlocal
for /l %%n in (1,1,%procs%) do (
	job add %id% /workdir:%wdir%\%proj%\ParallelSwatpy\worker%%n "start /W /I sufi2_execute.exe"
)
endlocal
job submit /id:%id% /jobname:"Run SWAT" /numnodes:%nodes%

echo Please wait Microsoft Windows HPC finish the jobs.
echo That may take a few hours...
:loop
for /f  "usebackq  tokens=3 delims=. " %%i in (`job view %id%`) do (
	if %%i==Finished goto :EOL
)
goto :loop
:EOL

for /f  "usebackq  tokens=4 delims=. " %%i in (`job new /parentjobids:%id%`) do (
	set id=%%i
	goto :merge_files
)

:merge_files
setlocal
REM talvez precise rever a quantd de args
job add %id% /name:first /workdir:%wdir%\%proj% "ParallelMerge.bat 0"
for %%f in (ParallelSwatpy\worker1\SUFI2.OUT\*.*) do (
	job add %id% /name:rest /depend:first /workdir:%wdir%\%proj% "ParallelMerge.bat 1 %procs% %%~nxf"
)
endlocal
job submit /id:%id% /jobname:"Collect results"

:preclean
for /f  "usebackq  tokens=4 delims=. " %%i in (`job new /parentjobids:%id%`) do (
	set id=%%i
	goto :cleanup
)

:cleanup
setlocal
for /l %%n in (1,1,%procs%) do (
	if exist ParallelSwatpy\worker%%n job add %id% /workdir:%wdir%\%proj%\ParallelSwatpy "rd worker%%n /s /q"
)
endlocal
job submit /id:%id% /jobname:"Cleanup temporary" /numnodes:%nodes%

echo Please wait Microsoft Windows HPC finish the jobs.
echo That may take a few hours...
:loop2
for /f  "usebackq  tokens=3 delims=. " %%i in (`job view %id%`) do (
	if %%i==Finished (
		if %clean%==1 goto :precheck
		if not %clean%==1 goto :EOF
	)
)
goto :loop2
:EOF