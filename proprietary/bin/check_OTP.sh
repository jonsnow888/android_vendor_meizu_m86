#!/system/bin/sh
####this script is only used to check OTP is writed or not

##### writed == ""  and writed == 0 is the same
writed=`getprop persist.sys.wlan.writeotp`
echo "writed is " $writed
svc wifi disable
ifconfig wlan0 down
echo "/system/vendor/firmware/mfg_fw.bin" > /sys/module/bcmdhd/parameters/firmware_path
ifconfig wlan0 up
#### what is there is no wl? it will gose to  not get 0xff 0xff branch,and not able to write OTP
cisdumpstr=`wl cisdump`
echo "$cisdumpstr"
echo "$cisdumpstr" | grep "0xff 0xff"
if [ $? -eq 0 ];then
echo get "0xff 0xff" in cisdumpstr
else
echo NOT get "0xff 0xff" in cisdumpstr
fi

#echo "$?"
#echo ${#cisdumpstr}
#echo ${cisdumpstr:3100:40}
#echo ${cisdumpstr:3140:2}
#echo "$isotpwrite}"
#case "$isotpwrite" in
#    "")
#    echo "not write OTP!!!"
#    ;;
#    *)
#    echo "already write OTP!!!"
#    ;;
#esac
