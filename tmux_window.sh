#!/bin/bash
#

use_my_tmux_config()
{
    MYCONFIG=/tmp/mytmux.conf
    if [ ! -f ${MYCONFIG} ];then
        wget -O ${MYCONFIG} https://raw.githubusercontent.com/joely1101/tools/master/.tmux.conf
    fi 
}
window_1_1()
{
    name=w1_1_$$
    w1=$1
    w2=$2
    tmux kill-sess -t ${name}
    tmux -f ${MYCONFIG} new-session -s ${name} \; \
    split-window -h -p 50\; \
    select-pane -t 0 \; \
    send-keys "sh -c \"${w1}\"" C-m \; \
    select-pane -t 1 \; \
    send-keys "sh -c \"${w2}\"" C-m \; \
    select-pane -t 0 \; 
}

window_1_2()
{
    name=w1x2_$$
    w1=$1
    w2=$2
    w3=$3
    tmux kill-sess -t ${name}
    tmux -f ${MYCONFIG} new-session -s ${name} \; \
    split-window -h -p 50\; \
    split-window -v \; \
    select-pane -t 0 \; \
    send-keys "sh -c \"${w1}\"" C-m \; \
    select-pane -t 1 \; \
    send-keys "sh -c \"${w2}\"" C-m \; \
    select-pane -t 2 \; \
    send-keys "sh -c \"${w3}\"" C-m \; \
    select-pane -t 0 \; 
}

window_2x2()
{
    name=w2x2_$$
    w1=$1
    w2=$2
    w3=$3
    w4=$4
    tmux kill-sess -t ${name}
    tmux -f ${MYCONFIG} new-session -s ${name} \; \
    split-window -h -p 50\; \
    split-window -v \; \
    select-pane -t 0 \; \
    split-window -v \; \
    select-pane -t 0 \; \
    send-keys "sh -c \"${w1}\"" C-m \; \
    select-pane -t 1 \; \
    send-keys "sh -c \"${w2}\"" C-m \; \
    select-pane -t 2 \; \
    send-keys "sh -c \"${w3}\"" C-m \; \
    select-pane -t 3 \; \
    send-keys "sh -c \"${w4}\"" C-m \; \
    select-pane -t 0 \; 
}
use_my_tmux_config
if [ "$#" = "4" ];then
    window_2x2 "$@"
elif [ "$#" = "3" ];then
    window_1_2 "$@"
elif [ "$#" = "2" ];then
    window_1_1 "$@"
else
    tmux -f ${MYCONFIG} new-session -s w1_$$
fi