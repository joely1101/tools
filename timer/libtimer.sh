timertable=()
timerlist=()
timerMax=0

timer_init()
{
    timertable=()
    timerlist=()
    timerMax=0
}
run_command()
{
    cm=(${timertable[$1]//#/ })
    len=${#cm[@]}
    for (( i=0; i<${len}; i++ ));
    do
	  cm1="${cm[$i]//_/ }"
	  #echo "execut $cm1 "
	  #date +%S
	  eval "$cm1"
    done
}
Expired2Run () {
  sec=$1
  for i in $timerlist
  do
    if [[ $(( sec % i )) == 0 ]] ; then
        run_command $i
    fi
  done
}

timer_add()
{
    cb=$2
    seconds=$1
    shift 2
    params="$@"
    cmd="$cb $params"
    cmd=${cmd// /_}
    timertable["$seconds"]+="#${cmd}"
    [[ "${timerlist} " =~ "${seconds} " ]] || timerlist+="$seconds "
    #[ $timerMax -lt $seconds ] && timerMax=$seconds
}


timer_run()
{
    index=1
    timerMax=1
    #every run once
    for i in $timerlist
    do
        timerMax=$((timerMax * i))
        run_command $i
    done
    while true;do        
        sleep 1
        Expired2Run "$index"
        index=$((index+1))
        [ $index -gt $timerMax ] && index=1
        
    done
}

