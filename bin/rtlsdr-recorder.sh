
freq="84.7M"
ofname="test.mp3"
duration=60

if [ ! -z "$1" ];then
    freq=$1
fi
if [ ! -z "$2" ]; then
    ofname=$2
fi
if [ ! -z "$3" ]; then
    duration=$3
fi

#rtl_fm -M wfm -f $freq -m 2.4m -s 170k  -r 32000 -E deemp,rtlagc,rdc,adc  - | aplay -r 32000 -f S16_LE
rtl_fm -M wfm -f $freq -m 2.4m -s 170k  -r 32000 -E deemp,rtlagc,rdc,adc  - | ffmpeg -y -f s16le -ar 32000 -ac 1 -i - -t $duration $ofname
