
:: Собираем скрипты с учетом конфига
call :make_sh "input=sh\make_dump.dist.sh" "output=sh\make_dump.sh"
call :make_sh "input=sh\download_dump.dist.scr" "output=sh\download_dump.scr"

:: Делаем дамп на удаленном хосте
bin\plink.exe -ssh %host% -l %usr% -pw %pswd% -m sh\make_dump.sh

:: Тянем дамп с удаленного хоста
bin\psftp.exe -v -C -2 -b sh\download_dump.scr %usr%@%host% -pw %pswd%

:: Разархивируем дамп
bin\unrar x tmp\dump.rar tmp

:: Разворачиваем базу
%mysqlPath% -u root -e "DROP DATABASE IF EXISTS %localDBname%;CREATE DATABASE %localDBname% CHARACTER SET utf8 COLLATE utf8_general_ci"
%mysqlPath% -u %localDBusr% %localDBname% < tmp\dump.sql

:: Заметаем следы
del tmp\dump.rar
del tmp\dump.sql



:make_sh
	@echo off & setlocal
	setlocal enabledelayedexpansion
	
	::input var
	call set %%1%
	::output var
	call set %%2%

	(for /f "delims=" %%l in (%input%) do (
		set "line=%%l"
		set "line=!line:{DBname}=%DBname%!"
		set "line=!line:{DBusr}=%DBusr%!"
		set "line=!line:{DBpswd}=%DBpswd%!"
		echo(!line!
	))>"%output%"
	endlocal
exit /b
