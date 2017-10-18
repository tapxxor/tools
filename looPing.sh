#!/bin/bash

function probe {
        sec="0"

	while [ $sec -lt 1800 ]
	do
	    ping -q -c 1 $1 > /dev/null 2>&1
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
	notify-send "LooPing" "$site is now reachable" --icon=dialog-information
	exit 0
else
    notify-send "LooPing" "$site is not reachable. Try again!" --category=error --icon=dialog-error
	exit 1
fi
