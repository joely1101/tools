#!/bin/bash
if [ "$EUID" -ne 0 ];then
    echo "Please run as root"
    exit
fi 
 
help()
{
    echo "$0 [add|rm] interface docker-instance"
    exit
}
env_init()
{
    if type docker &>/dev/null;then
        container_tool=docker
        isdocker=1
    elif type podman &>/dev/null;then
        container_tool=podman
    else
        echo "docker/podman not found, please install it"
        exit 99
    fi
}
instance_running()
{
    local XX=`${container_tool} ps -q -f name=$1`
    if [ "$XX" = "" ];then
      return 1
    fi
    return 0
} 
check_param()
{
    local ifname=$1
    local inst=$2
    if [ "$ifname" = "" ];then
        echo "invalid interface"
        exit
    fi
    if ! instance_running $inst;then
        echo "$inst not found"
        exit
    fi
}
init_netns()
{
    local inst=$1
    mkdir -p /var/run/netns
    cpid=`${container_tool} inspect --format '{{.State.Pid}}' ${inst}`
    if [ "$cpid" = "" ] || [ ! -f /proc/$cpid/ns/net ];then
        echo "error pid" 
        exit 
    fi
    
    [ -f /var/run/netns/$name ] && rm -f /var/run/netns/$name
    ln -sf /proc/$cpid/ns/net /var/run/netns/$inst
}
add()
{
    local ifname=$1
    local inst=$2
    if ! instance_running $inst;then
        echo "$inst not found"
        exit
    fi
    
    init_netns $inst
    ip link set $ifname netns $inst    
}

remove()
{
    local ifname=$1
    local inst=$2

    if ! instance_running $inst;then
        echo "$inst not found"
        exit
    fi
    init_netns $inst
    ip netns exec $inst ip link set $ifname netns 1
}

netname=$2
dkinst=$3
env_init
if [ "$1" = "add" ];then
    check_param "$netname" "$dkinst"
    add "$netname" "$dkinst"
elif [ "$1" = "rm" ];then
    check_param "$netname" "$dkinst"
    remove "$netname" "$dkinst"
else
    help
fi