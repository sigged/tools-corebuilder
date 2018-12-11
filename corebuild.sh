#!/bin/bash   

#find -name '*sln'

echo "
 ▄████▄  ▒█████   ██▀███  ▓█████     ▄▄▄▄    █    ██  ██▓ ██▓    ▓█████▄ ▓█████  ██▀███  
▒██▀ ▀█ ▒██▒  ██▒▓██ ▒ ██▒▓█   ▀    ▓█████▄  ██  ▓██▒▓██▒▓██▒    ▒██▀ ██▌▓█   ▀ ▓██ ▒ ██▒
▒▓█    ▄▒██░  ██▒▓██ ░▄█ ▒▒███      ▒██▒ ▄██▓██  ▒██░▒██▒▒██░    ░██   █▌▒███   ▓██ ░▄█ ▒
▒▓▓▄ ▄██▒██   ██░▒██▀▀█▄  ▒▓█  ▄    ▒██░█▀  ▓▓█  ░██░░██░▒██░    ░▓█▄   ▌▒▓█  ▄ ▒██▀▀█▄  
▒ ▓███▀ ░ ████▓▒░░██▓ ▒██▒░▒████▒   ░▓█  ▀█▓▒▒█████▓ ░██░░██████▒░▒████▓ ░▒████▒░██▓ ▒██▒
░ ░▒ ▒  ░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░░ ▒░ ░   ░▒▓███▀▒░▒▓▒ ▒ ▒ ░▓  ░ ▒░▓  ░ ▒▒▓  ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░
  ░  ▒    ░ ▒ ▒░   ░▒ ░ ▒░ ░ ░  ░   ▒░▒   ░ ░░▒░ ░ ░  ▒ ░░ ░ ▒  ░ ░ ▒  ▒  ░ ░  ░  ░▒ ░ ▒░
░       ░ ░ ░ ▒    ░░   ░    ░       ░    ░  ░░░ ░ ░  ▒ ░  ░ ░    ░ ░  ░    ░     ░░   ░ 
░ ░         ░ ░     ░        ░  ░    ░         ░      ░      ░  ░   ░       ░  ░   ░     
░                                         ░                       ░                      "
echo "  --== By Sigged ==--"
echo ""

C_RESET="\033[0m"
C_RED="\033[31m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_BOLDRED="\033[1m\033[31m"
C_BOLDGREEN="\033[1m\033[32m"
C_BOLDYELLOW="\033[1m\033[33m"
									 
DIRS=$(ls -l | grep "^d" | wc -l)
printf ">> Scanning directories...    "
printf "${C_BOLDYELLOW}$DIRS${C_RESET} directories found\n"

declare -a SLNS=$(echo "("; find -name '*sln' -printf '"%p" '; echo ")")

printf ">> Scanning solutions...      "
printf "${C_BOLDYELLOW}${#SLNS[@]}${C_RESET} solutions found\n"


printf ">> Scanning dotnet runtime... "
DOTNETVER=$(dotnet --version 2> /dev/null)
if [[ $DOTNETVER =~ ^$ ]]
then
	printf "${C_BOLDRED}NOT FOUND\n\n${C_RESET}"
   
	printf "${C_BOLDRED}dotnet runtime was not found!\n${C_RESET}";
	printf "${C_BOLDRED}Termination program.\n${C_RESET}";
else
	printf "${C_BOLDGREEN}$DOTNETVER\n\n\n${C_RESET}";
fi

printf "${C_BOLDYELLOW}Ready to compile ${#SLNS[@]} solutions\n${C_RESET}"
read -r -p "Continue? [y/N] " response

case "$response" in
	[yY][eE][sS]|[yY])

		SUCCEEDED=0
		FAILED=0
		for SLN in "${SLNS[@]}"
		do
			printf "Building $SLN ... "
			RESULT=$(dotnet build "./$SLN" 2> /dev/null)
			if [[ $RESULT =~ (.*)0.Error\(s\)(.*) ]]
			then
			printf "${C_BOLDGREEN}SUCCEEDED\n${C_RESET}";
			SUCCEEDED=$((SUCCEEDED+1))
			else
			printf "${C_BOLDRED}FAILED\n${C_RESET}";
			FAILED=$((FAILED+1))
			fi
		done
        
		printf "\n"
		printf ">> ${C_BOLDGREEN}$SUCCEEDED ${C_RESET} solutions built succesfully\n" 
		printf ">> ${C_BOLDRED}$FAILED ${C_RESET} solutions failed to build\n" 
		printf "\n"
		printf "\tkthx bye!\n"
		;;
    *)
        printf ">> ${C_BOLDRED}Operation aborted${C_RESET}"
        ;;
esac

