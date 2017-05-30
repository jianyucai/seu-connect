#!/bin/bash

echo "    Getting cookies from http://w.seu.edu.cn/......"

cookie=`curl -I "http://w.seu.edu.cn/" 2> /dev/null | grep -o "PHPSESSID=.*;" | cut -d '=' -f 2 | cut -d ';' -f 1`

echo "    Cookie received: y"$cookie

echo "    Connecting seu-wlan......"

COOKIE="think_language=zh-CN; sunriseUsername=????????; PHPSESSID="$cookie

reply_json=`curl -d "username=????????&password=????????&enablemacauth=0" http://w.seu.edu.cn/index.php/index/login  --cookie $COOKIE 2> /dev/null`


python test_status.py $reply_json

if [ $? == "0" ]
then
    echo "    Status: 0"
    info=`echo $reply_json | cut -d ',' -f 2 | cut -d '"' -f 4 | cut -d '}' -f 1`
    echo "    "`python UTF8-CHN.py $info`

else
    echo "    Status: 1"
    info=`echo $reply_json | cut -d ',' -f 1 | cut -d '"' -f 4`
    echo "    "`python UTF8-CHN.py $info`
    ip=`echo $reply_json | cut -d ',' -f 5 | cut -d ':' -f 2 | cut -d '"' -f 2`
    echo "    ip: "$ip
fi
