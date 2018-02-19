#!/system/bin/sh
###test we did:
###1,remove wl;in this case wl cisdump will fail,and wl ciswrite will fail too,so dont worry
###2,remove bcm943455_pciehdr_follow_M8.bin; in this case log tell no such file and will setprop to 0,
###   and it will try again next time


##### writed == ""  and writed == 0 is the same
writed=`getprop persist.sys.wlan.writeotp`
echo "writed is " $writed
case "$writed" in
  "")
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
        setprop persist.sys.wlan.writeotp 1
    else
        echo NOT get "0xff 0xff" in cisdumpstr
        wl ciswrite /system/vendor/firmware/bcm943455_pciehdr_follow_M8.bin
        if [ $? -eq 0 ];then
#            echo "wl ciswrite success"
#            setprop persist.sys.wlan.writeotp 1
            cisdumpstr=`wl cisdump`
            echo "$cisdumpstr"
            echo "$cisdumpstr" | grep "0xff 0xff"
            if [ $? -eq 0 ];then
                echo get "0xff 0xff" in cisdumpstr
                setprop persist.sys.wlan.writeotp 1
            else
                echo "wl ciswrite FAIL111"
                setprop persist.sys.wlan.writeotp 0
            fi
        else
            echo "wl ciswrite FAIL"
            setprop persist.sys.wlan.writeotp 0
        fi
    fi
#######we need to rm mac_addr because ifconfig wlan0 up make mac_addr root group,and supplicant can not access it
    rm /data/calibration/mac_addr
    ifconfig wlan0 down

exit;;
  0)
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
        setprop persist.sys.wlan.writeotp 1
    else
        echo NOT get "0xff 0xff" in cisdumpstr
        wl ciswrite /system/vendor/firmware/bcm943455_pciehdr_follow_M8.bin
        if [ $? -eq 0 ];then
#            echo "wl ciswrite success"
#            setprop persist.sys.wlan.writeotp 1
            cisdumpstr=`wl cisdump`
            echo "$cisdumpstr"
            echo "$cisdumpstr" | grep "0xff 0xff"
            if [ $? -eq 0 ];then
                echo get "0xff 0xff" in cisdumpstr
                setprop persist.sys.wlan.writeotp 1
            else
                echo "wl ciswrite FAIL111"
                setprop persist.sys.wlan.writeotp 0
            fi
        else
            echo "wl ciswrite FAIL"
            setprop persist.sys.wlan.writeotp 0
        fi
    fi
#######we need to rm mac_addr because ifconfig wlan0 up make mac_addr root group,and supplicant can not access it
    rm /data/calibration/mac_addr
    ifconfig wlan0 down

exit;;
  1) echo "otp is already write" && exit;;
  *) echo "writed wrong input" && exit;;
esac
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
