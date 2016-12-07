# Program:
#	SVN transfer to Git
# Author: Chonpin
# EMail: chonpin[at]gmail.com
# History:
# 2016/12/07	Chonpin		First release


clear
#echo ""
#echo " .oooooo..o oooooo     oooo ooooo      ooo      .oooo.        .oooooo.     o8o      .  " 
#echo "d8P'    `Y8  `888.     .8'  `888b.     `8'    .dP''Y88b      d8P'  `Y8b    `o'    .o8  " 
#echo "Y88bo.        `888.   .8'    8 `88b.    8           ]8P'    888           oooo  oo888oo" 
#echo " `Y88888o.     `888. .8'     8   `88b.  8         .d8P'     888           `888    888  " 
#echo "     `Y888b     `888.8'      8     `88b.8       .dP'        888     ooooo  888    888  " 
#echo "oo     .d8P      `888'       8       `888     .oP     .o    `88.    .88'   888    888 ."
#echo "88888888P'        `8'       o8o        `8     8888888888     `Y8bood8P'   o888o   '8888"
#echo ""
#echo "                                                                    Create by : Chonpin"
#echo "                                                                   chonpin[at]gmail.com"
#echo ""





# Config
# =================================================================================
config_repository=http://172.19.1.26/repos/ncc/trunk/offline_SQL
config_revision=10000
config_folder=/d/git/test123
config_user=chonpin.hsu
config_repository_git=https://github.com/chonpin/svn2gitxxxxxx.git
# =================================================================================


function func_start() {
	while true; do
		echo "Choice option :"
		echo "1. Transfer SVN to Git"
		echo "2. Push existing Git repository to GitLab"
		echo "3. Exit"
		read -p "" option
		echo ""

		case $option in
			"1")
				func_svn
				func_git 1
				func_bye
				;;
			"2")
				func_git 2
				func_bye
				;;
			"3")
				func_bye
				;;
			*)
				func_start
				;;
		esac
	done
}


function func_svn() {
	read -p "Git Repository (${config_repository_git}) : " repository_git
	read -p "SVN Repository (${config_repository}) : " repository
	read -p "Revision number (Empty or 9999) : " revision
	read -p "Checkout folder (${config_folder}) : " folder
	read -p "UserName (${config_user}) : " user

	repository_git=${repository_git:-$config_repository_git}
	repository=${repository:-$config_repository}
	revision=${revision:-$config_revision}
	folder=${folder:-$config_folder}
	user=${user:-$config_user}

	echo ""
	echo "Project info : "
	echo "Git repository : ${repository_git}"
	echo "SVN repository : ${repository}"
	echo "revision : ${revision}"
	echo "folder : ${folder}"
	echo "user : ${user}"
	echo ""
	echo ""
	echo ""
	echo "*****   Important!!! this action will delete your destination folder.   *****"
	echo ""
	echo ""
	echo ""

	while true; do
		read -p "Are you sure to transfer this project [Y/N]?:" choice
		case $choice in
			"Y")
				set rCommand=
				if [ "$revision" != "Empty" ]; then 
					rCommand=-r${revision}:HEAD
				fi

				echo "Get author list and save to author.txt"
				#svn log ${repository} --quiet | awk '/^r/ {print $3"="$3"<"$3"@104.com.tw>"}' | sort -u > author.txt

				echo "delete destination folder"
				#rm -rf $folder

				echo "Start transfer..."
				#git svn clone ${rCommand} ${repository} -A author.txt --username=${user} ${folder}

				echo "Transfer Finished..."
				break;
				;;
			"N")
				echo "transfer abort"
				func_bye
				;;
		esac
	done
}


function func_git() {
	if [ "${1}" == "2" ]; then
		read -p "Git Repository (${config_repository_git}) : " repository_git
		read -p "Git folder (${config_folder}) : " folder
	fi
	repository_git=${repository_git:-$config_repository_git}
	folder=${folder:-$config_folder}

	cd $folder
	echo >> README.md
	git add README.md
	git commit -m "First git commit!!!"
	git remote rm origin
	git remote add origin ${repository_git}
	git push -u origin master
}

function func_bye(){
	echo "Thank you. Bye..."
	exit 0
}


# run shell script
clear
func_start