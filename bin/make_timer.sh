#!/bin/sh

function printUsage () {
    echo "Usage: $0 FREQ DURATION OFNAME CALENDER PROG"
    echo "FREQ: e.g. 84.7M (for Yokohama-FM)"
    echo "DURATION: recording time in sec., e.g. 60"
    echo "OFNAME: path-to-output-file including directory"
    echo "CALENDER: systemd-specific calender used on firing timer"
    echo "PROG: user specified ID"
    echo
    echo "Example:"
    echo "  $0 91.6M 35:00 ${HOME}/tmp/HinatazakaNoHi.mp3 \"Sun 18:29\" HinatazakaNoHi"



}

if [ "$#" -ne 5 ]; then
    printUsage
    exit 1
fi
echo FREQ=$1
echo DURATION=$2
echo OFNAME=$3
echo CALENDER=$4
echo PROG=$5
BIN=/home/shota/Projects/rtlsdr-fm-recorder/bin/rtlsdr-recorder.sh

systemd-analyze calendar \"$4\"

sed -e 's/FREQ/\"'$1'\"/;' ./templates/template.timer | sed -e "s!CALENDAR!$4!; s!PROG!$5!" > ./timers/record-$5-$1-$2.timer
sed -e 's/FREQ/'$1'/;s/PROG/'$5'/;s/TIMEWINDOW/'$2'/;s!BIN!'$BIN'!;s!OFNAME!'$3'!' ./templates/template.service  > ./timers/record-$5-$1-$2.service
