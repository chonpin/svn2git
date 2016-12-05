@echo off
clear
echo.
echo.
echo  .oooooo..o oooooo     oooo ooooo      ooo      .oooo.        .oooooo.     o8o      .   
echo d8P'    `Y8  `888.     .8'  `888b.     `8'    .dP''Y88b      d8P'  `Y8b    `o'    .o8   
echo Y88bo.        `888.   .8'    8 `88b.    8           ]8P'    888           oooo  oo888oo 
echo  `Y88888o.     `888. .8'     8   `88b.  8         .d8P'     888           `888    888   
echo      `Y888b     `888.8'      8     `88b.8       .dP'        888     ooooo  888    888   
echo oo     .d8P      `888'       8       `888     .oP     .o    `88.    .88'   888    888 . 
echo 88888888P'        `8'       o8o        `8     8888888888     `Y8bood8P'   o888o   '8888
echo.
echo                                                                     Create by : Chonpin
echo                                                                    chonpin[at]gmail.com
echo.





rem Config
rem =================================================================================
set repository=http://172.19.1.26/repos/ncc/trunk/[PROJECT_NAME]
set revision=Empty
set folder=/d/git/[PROJECT_NAME]
set user=[USERNAME]
set repository_git=https://github.com/chonpin/svn2git.git
rem =================================================================================







cls
:start
	echo Choice option :
	echo 1. Transfer SVN to Git
	echo 2. Push existing Git repository to GitLab
	echo 3. Exit
	set /P option=
	If "%option%"=="1" goto svn 
	If "%option%"=="2" goto git
	If "%option%"=="3" goto bye
	goto start

:svn
	set /P repository_git=Git Repository (%repository_git%) : 
	set /P repository=SVN Repository (%repository%) : 
	set /P revision=Revision number (Empty or 9999) : 
	set /P folder=Checkout folder (%folder%) : 
	set /P user=UserName (%user%) : 

	echo.
	echo Project info : 
	echo Git repository : %repository_git%
	echo SVN repository : %repository%
	echo revision : %revision%
	echo folder : %folder%
	echo user : %user%

	:choice
		SET /p choice=Are you sure to transfer this project [Y/N]?:
		If "%choice%"=="Y" goto yes 
		If "%choice%"=="N" goto no
		goto choice


	:yes
		set rCommand=
		IF "%revision%" NEQ "Empty" set rCommand=-r%revision%:HEAD

		echo Get author list and save to author.txt
		@echo on
		svn log %repository% --quiet | awk '/^r/ {print $3"="$3"<"$3"@104.com.tw>"}' | sort -u > author.txt

		@echo off
		echo Start transfer...
		@echo on
		git svn clone %rCommand% %repository% -A author.txt --username=%user% %folder%

		goto git
		echo Transfer Finished...

	:no
		echo transfer abort
		goto bye


:git
	IF "%option%"=="2" set /P repository_git=Git Repository (%repository_git%) : 
	IF "%option%"=="2" set /P folder=Git folder (%folder%) : 
	set disk=%folder:~1,1%
	set folder=%folder:~2%
	cd %disk%:
	cd %folder%
	echo >> README.md
	git add README.md
	git commit  -m "First git commit!!!"
	git remote add origin %repository_git%
	git push -u origin master
	goto bye

:bye
	echo Thank you. Bye...
	exit
