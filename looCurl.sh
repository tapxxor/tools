#! /bin/bash

# Short description: looPing pings in a loop a domain. if it is accessible 
#                    a notification window informs about the success other-
#                    wise a time out occurs after 30 minutes

# Author: tapxxor <tapxxor@gmail.org>
# 
# Version History
# Version   Date        User            Descrption        
# R1A01     10182017    tapxxor         Script creation

# uncomment the below line to debug the script
# set -x

function probe {
        sec="0"

	while [ $sec -lt 1800 ]
	do
	    curl GET $1 > /dev/null 2>&1
	    if [ $? -eq 0 ]; then
		return 0
	    else
		sec=$[$sec+1]
		sleep 1
	    fi
	done

	return 1
}

# read url from zenity input
site=$(zenity --entry --title="Probe a domain" --text "Enter the domain to probe:" --entry-text "www.google.com" 2>/dev/null);

# probe site until becomes reachable or 30 minutes are passed
probe $site

# exit
if [ $? -eq 0 ]; then
	notify-send "LooCurl" "$site is now reachable" --icon=dialog-information
	exit 0
else
    	notify-send "LooCurl" "$site is not reachable. Try again!" --category=error --icon=dialog-error
	exit 1
fi
