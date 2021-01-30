
freq="84.7M"

if [ ! -z "$1" ];then
    freq=$1
fi

rtl_fm -M wfm -f $freq -m 2.4m -s 170k  -r 32000 -E deemp,rtlagc,rdc,adc  - | aplay -r 32000 -f S16_LE
