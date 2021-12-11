
proc=$(pgrep rtl_fm)
if [ ! -z "$proc" ]; then
    pkill -TERM rtl_fm && sleep 3 && pkill -TERM rtl_fm
fi
proc=$(pgrep rtl_tcp)
if [ ! -z "$proc" ]; then
    pkill -TERM rtl_tcp && sleep 3 && pkill -TERM rtl_tcp
fi
sleep 5

freq="84.7M"
ofname="test.DATE.mp3"
duration=60

date=$(date +%y%m%d%H%M%S)

if [ ! -z "$1" ];then
    freq=$1
fi
if [ ! -z "$2" ]; then
    ofname=$2
fi
if [ ! -z "$3" ]; then
    duration=$3
fi

echo [debug] $(lsusb)
#rtl_fm -M wfm -f $freq -m 2.4m -s 170k  -r 32000 -E deemp,rtlagc,rdc,adc  - | aplay -r 32000 -f S16_LE
rtl_fm -M wfm -f $freq -m 2.4m -s 170k  -r 32000 -E deemp -E rtlagc -E rdc -E adc -T -O 'agc=1'  - | ffmpeg -y -f s16le -ar 32000 -ac 1 -i - -t $duration ${ofname/DATE/${date}}
if [ ! $? -eq 0 ]; then
    echo Failed something
    echo [debug] $(lsusb)
    exit 1;
fi
