#!/bin/bash

#########################
#        R4V10L1        #
#########################
# Credits to Señor_Foo btw (<3)

normal_color="\e[1;0m"
green_color="\033[1;32m"
red_color="\033[1;31m"
red_color_slim="\033[0;031m"
white_color="\e[1;97m"

whereami="$(pwd)"
whatsmyname="$(ls $whereami | grep probe* )"

if ! [ -x "$(command -v gawk)" ]; then
    echo
    echo -e "  ${white_color}Gawk (GNU awk) is not installed. You can install gawk with ${green_color}apt-get install gawk${white_color} if you are using apt."
    echo
    exit 0
fi

channel_hop() {

	IEEE80211bg="1 2 3 4 5 6 7 8 9 10 11"
	IEEE80211bg_intl="$IEEE80211b 12 13 14"
	IEEE80211a="36 40 44 48 52 56 60 64 149 153 157 161"
	IEEE80211bga="$IEEE80211bg $IEEE80211a"
	IEEE80211bga_intl="$IEEE80211bg_intl $IEEE80211a"

	while true ; do
		for CHAN in $IEEE80211bg ; do
			sudo iwconfig $interface channel $CHAN
			sleep 2
		done
	done
}

if [[ $1 == "" || $1 == " " ]]
then
    echo -e "${white_color} USAGE: $whatsmyname -i ${normal_color}<interface> ${white_color}-c ${normal_color}<channel> ${white_color}-m ${normal_color}<mode>"
    echo -e "${white_color} Use ${normal_color}-h ${white_color}to see the full help.${normal_color}"
    exit 0
fi

if [[ $1 == "-h" || $1 == "--h" || $1 == "-help" || $1 == "--help" ]]
then
    echo -e "${green_color}┍━━━━━━━━━━━━━━━━━━${white_color}PROBE${green_color}━${white_color}SCANNER${green_color}━${white_color}HELP${green_color}━━━━━━━━━━━━━━━━━━┑${white_color}"
    echo
    echo -e "  -h --help       ${normal_color}Show this help ._.${white_color}"
    echo -e "  -i --inteface   ${normal_color}Select the interface to use.${white_color}"
    echo -e "  -c --channel    ${normal_color}Select a channel.${white_color}"
    echo -e "     -c h         ${normal_color}Use channel hopping mode.${white_color}"
    echo -e "  -m --mode       ${normal_color}Select a specific show mode.${white_color}"
    echo -e "     -m s         ${normal_color}Select short mode.${white_color}"
    echo -e "                  ${normal_color}(Just probes without macs)${white_color}"
    echo -e "     -m l         ${normal_color}Select complete / long mode."
    echo -e "                  ${normal_color}(Time, macs, probes and strength)${white_color}"
    echo -e "     -m           ${normal_color}Select normal mode."
    echo -e "                  ${normal_color}(Macs and probes)${white_color}"
    # echo
    echo -e "${green_color}┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙${white_color}"
    exit 0
fi

interface="FOO"
channel="FOO"
mode="FOO"

if [[ $1 == "-i" && $(echo -e "$2" | grep "-") == "" ]]
then
    interface="$2"
elif [[ $1 == "-i" && $(echo -e "$2" | grep "-") != "" ]]
then
    echo
    echo -e "${white_color}  You must use${red_color} -i <interface>${white_color}!!${normal_color}"
    echo
    exit 0
else
    echo
    echo -e "${red_color}  Interface error.${normal_color}"
    echo
    exit 0
fi

if [[ $3 == "-c" && $(echo -e "$4" | grep "-") == "" ]]
then
    channel="$4"
elif [[ $3 == "-c" && $(echo -e "$4" | grep "-") != "" ]]
then
    echo
    echo -e "${white_color}  You must use${red_color} -c <channel>${white_color}!!${normal_color}"
    echo
    exit 0
else
    echo
    echo -e "${red_color}  Channel error.${normal_color}"
    echo
    exit 0
fi

if [[ $4 != "h" && $4 != "1" && $4 != "2" && $4 != "3" && $4 != "4" && $4 != "5" && $4 != "6" && $4 != "7" && $4 != "8" && $4 != "9" && $4 != "10" && $4 != "11" ]]
then
    echo
    echo -e "${red_color}  Channel error. $4 is not a valid channel. ${white_color}(1-11) / (h)${normal_color}"
    echo
    exit 0
fi

if [[ $5 == "-m" && $(echo -e "$6" | grep "-") == "" ]]
then
    mode="$6"
elif [[ $5 == "-m" && $(echo -e "$6" | grep "-") != "" ]]
then
    echo
    echo -e "${white_color}  You can't use${red_color} $6${white_color} as a mode!!${normal_color}"
    echo
    exit 0
else
    mode="no_mode"
    clear
    echo
    echo -ne "${white_color}  No${red_color} mode${white_color} is set, using ${green_color}default${white_color} mode.${normal_color}"
    sleep 1
    echo
    echo
fi

if [[ $interface == "FOO" ]]
then
    echo
    echo -e "${red_color}  Interface error.${white_color} You must specify an interface.${normal_color}"
    echo
elif [[ $channel == "FOO" ]]
then
    echo
    echo -e "${red_color}  Channel error.${white_color} You must specify a channel.${normal_color}"
    echo
elif [[ $mode == "FOO" ]]
then
    echo
    echo -e "${red_color}  Mode error.${normal_color}"
    echo
fi


if [[ $mode == "no_mode" ]]
then
    awk_file_name="normal_awk.awk"
elif [[ $mode == "s" ]]
then
    awk_file_name="simple_awk.awk"
elif [[ $mode == "l" ]]
then
    awk_file_name="long_awk.awk"
else
    echo
    echo -e "${red_color}  Mode error.${white_color} I don't think${red_color} $mode${white_color} is a valid mode...${normal_color}"
    echo -e "${white_color}  Use ${normal_color}-h ${white_color}to see the full help.${normal_color}"
    echo
    exit 0
fi
## ACTUAL EXECUTION ##

if [[ $channel == "h" ]]
then
	# Start the channel hopping if $channel is "h"
	channel_hop &
else
    iwconfig $interface channel $channel
fi

FIND_AWK="$(ls gAWKs 2>/dev/null | grep $awk_file_name 2>/dev/null )"
if [[ $FIND_AWK == "" ]]
then
    echo
    echo -e "${red_color}  gAWK error.${white_color} I can't locate ${red_color}$awk_file_name ${white_color}in the gAWKs folder!!${normal_color}"
    echo
    exit 0
fi

mkdir logs 2>/dev/null
sudo tcpdump -l -I -i ${interface} -e -s 256 type mgt subtype probe-req | awk -f gAWKs/$awk_file_name | tee -a "logs/$(date).txt"



# exit 0
