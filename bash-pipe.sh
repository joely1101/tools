#!/bin/bash
#trap "echo kill_evetst;pkill evtest" EXIT
trap "pkill evtest" EXIT

action_2()
{
   echo  "${FUNCNAME[0]} - reboot device"
   #reboot
}

action_3()
{
    echo  "${FUNCNAME[0]} - do factory reset"
}

#key_press=$1
#key_release=$2
help()
{
    #echo "usage: $0 'key press callback/shell' 'key releas callback/shell'"
    echo "usage: $0 "
}
#help
env_check()
{
    if [[ $EUID -ne 0 ]]; then
      echo "You must be a root user" 2>&1
      exit 1
    fi
    
    if [ ! -c /dev/input/event0 ];then
        echo "/dev/input/event0 not found"
        exit 99
    fi
    #evtest -h &>/dev/null
    #if [ "$?" != "0" ];then
    #    echo "evtest not found.please install it by 'apt-get install evtest'"
    #    exit 99
    #fi
}


# Generate data, output to STDOUT.
evtest_run() {
        evtest /dev/input/event0
}

# run generator with its output dup'ed to FD #5


monitor()
{
    echo "start evtest"
    exec 5< <( evtest_run )
    echo "start watching 'erase button'"
    rtimeout=
    count=0
    while true;do
	read $rtimeout n <&5
	if [ "$?" = "0" ] ;then
            echo $n | grep -q "type 1 (EV_KEY), code 408 (KEY_RESTART), value 1"
            if [ "$?" = "0" ];then
                echo "button pressed count $count"
                #[ "$key_press" != "" ] && sh -c "$key_press"
                rtimeout="-t 1"
                count=$((count+1))
                continue
            fi
        
            echo $n | grep -q "type 1 (EV_KEY), code 408 (KEY_RESTART), value 0"
            if [ "$?" = "0" ];then
                echo "button release"
                rtimeout="-t 1"
                #[ "$key_release" != "" ] && sh -c "$key_release"
                continue
            fi
	else #timeout
	    #echo "===$count==="
	    if [ $count -gt 0 ];then
	        __callback=action_$count
    	    if [[ `declare -Ff $__callback` ]];then
    		   $__callback
            else
    		    echo "callback not found for press $count"
    	    fi
	    fi
	    count=0
	    rtimeout=""
	fi	
    done
}

env_check
monitor
