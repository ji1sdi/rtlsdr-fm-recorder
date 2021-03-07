
freq="84.7M"

if [ ! -z "$1" ];then
    freq=$1
fi

#rtl_fm -M wfm -f $freq -m 2.4m -s 170k  -r 32000 -E deemp,rtlagc,rdc,adc  - | aplay -r 32000 -f S16_LE
rtl_fm -M wfm -f $freq -m 2.4m -s 170k  -r 32000 -E deemp,rtlagc,rdc,adc  - |\
    ffmpeg -f s16le -ar 32000 -ac 1 -i - \
    -c:v libx264 -b:v 1000k -bufsize 1000k \
        -flags +cgop+loop-global_header \
        -bsf:v h264_mp4toannexb \
        -f segment -segment_format mpegts -segment_time 10 \
        -segment_wrap 5 \
        -segment_list ~/public_html/rtlsdr_streaming/stream.m3u8 ~/public_html/rtlsdr_streaming/segment%06d.ts
