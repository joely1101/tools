#!/bin/bash
MAXHISTORY=20 
declare DL_INDEX=0
declare -a DL_LIST
dc_add()
{
    local dirp
    if [ "$1" = "" ];then
       dirp=$PWD
    elif [ ! -d $1 ];then
        dirp=$1
    else
        dirp=`realpath $1`
    fi
    idx=${2:-$DL_INDEX}
    if [ "${DL_LIST[idx]}" = "$dirp" ];then
        return
    fi
    #do not log home
    if [ "${HOME}" = "${dirp}" ];then
        return
    fi
    
    DL_LIST[$idx]=$dirp
    DL_INDEX=$(((DL_INDEX + 1) % MAXHISTORY))

}
dc_list()
{
    local printed=0
    for((i=0;i<MAXHISTORY;i++))
    do
        idx=$(((DL_INDEX + MAXHISTORY - i - 1) % MAXHISTORY))
        local dirp=${DL_LIST[idx]}
        if [ "${dirp}" = "" ];then
            break
        fi
        dirp=${dirp/$HOME/'~'}
        echo "$i:$dirp"
        printed=1
    done
    if [ $printed -eq 0 ];then
        echo "dir history empty"
    fi
}
dc_clean()
{
    for((i=0;i<MAXHISTORY;i++))
    do
        DL_LIST[$i]=""
    done
}
dc_jump()
{
    
    local num=$1
    num=$((0-num))
    if [ $num -gt $MAXHISTORY ];then
        echo "Invalid number, max is $MAXHISTORY"
        return
    fi
    local idx=$(((DL_INDEX + MAXHISTORY - num - 1) % MAXHISTORY))
    local dirp=${DL_LIST[idx]}
    if [ "$dirp" = "" ] || [ ! -d $dirp ];then
        echo "Invalid directory!!"
        return 
    fi

    echo ${dirp/$HOME/'~'}
    builtin cd $dirp
    
}
mycd()
{
    if [ "$1" == "-s" ]; then
        dc_list
    elif [ "$1" == "-c" ]; then
        dc_clean
    elif [[ "$1" =~ ^-[0-9]+$ ]]; then
        dc_jump $1
    else
        local cpwd=$PWD
        builtin cd $1
        if [ "$cpwd" != "$PWD" ];then
            dc_add $PWD
        fi
    fi
}


# replace standard `cd` with enhanced version, ensure tab-completion works
alias cd=mycd
alias cds=dc_list
complete -d cd
