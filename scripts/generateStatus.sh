TARGET=${HOME}/public_html/RecRadiko/index.html
function put (){
    if [ ! -z "$1" ]; then
        echo "$1" >> ${TARGET}
    else
        return 1;
    fi
    return 0;
}

function parse-timers (){
put "<table><tr><th>NEXT</th><th>LAST</th><th>NAME</th><th>REPORT</th></tr>"
IFS=$'\n'
header=$(systemctl --user list-timers | head -n1)
indNext=$(echo $header | awk '{print index($0, "NEXT")}')
indLast=$(echo $header | awk '{print index($0, "LAST")}')
indTimer=$(echo $header | awk '{print index($0, "UNIT")}')
indName=$(echo $header | awk '{print index($0, "ACTIVATES")}')
for line in $(systemctl --user list-timers | head -n-3 | tail -n+2 | grep record);
do
    put "<tr>"
    put "$(echo $line | awk '{print "<td>"substr($0,'$indNext',23)" ("substr($0,'$indNext+28','$indLast-$indNext-29')")</td><td>"substr($0,'$indLast',23)" ("substr($0,'$indLast+28','$indTimer-$indLast-29')")</td><td>"substr($0,'$indName',99)"</td>"}')"
    local laststatus=$(echo $line | awk '{print substr($0,'$indName',50)}' | xargs systemctl --user status | grep "Main PID")
    #echo $laststatus
    if [ -z "$laststatus" ]; then
        put "<td>N/A</td>"
    else
        put "$(echo $laststatus| awk 'BEGIN{FS="[(,=)]"}{print "<td>"$3" ("$5")</td>"}')"
    fi
    put "</tr>"
done
put "</table>"
}

rtldev=$(lsusb | grep RTL)
echo "<!DOCTYPE html>" > ${TARGET}
put "<html>"
put "    <head>"
put "        <meta charset="UTF-8">"
put "    </head>"
put "    <body>"
put " <p> Last modified: $(date) </p>"
put "<h1>RTL-SDR devices</h1>"
if [ -z "$rtldev" ]; then
    put "<b>RTL-SDR device is missing!!</b>"
else
    put "RTL-SDR is running: ($rtldev)"
fi
put "<h1>Systemd timers</h1>"
parse-timers
put "    </body>"
put "</html>"
