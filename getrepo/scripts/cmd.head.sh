declare -A HELP
debuglevel=${debuglevel:-2}
do_cmd()
{
    if [ "$debuglevel" = "1" ];then
	echo "cmd:$@"
	eval "$@ 1>/dev/null"
	if [ $? != 0 ];then
		echo "Error!!"
		exit 99
	fi
	echo "done..."

    elif [ "$debuglevel" = "2" ];then
	echo "cmd:$@"
	eval $@
	 if [ $? != 0 ];then
            echo "Error!!"
            exit 99
         fi
	echo "done..."
    else
        eval $@
	 if [ $? != 0 ];then
             echo "Error!!"
             exit 99
         fi
    fi
}
rename_fn()
{
  local a
  a="$(declare -f "$1")" &&
  eval "function $2 ${a#*"()"}" &&
  unset -f "$1";
}
help_add()
{
    HELP["$1"]="$2"
}
help_show()
{
    echo "Help:"
    for key in ${!HELP[@]}
    do
        if [ "${HELP[$key]}" != "" ];then
	    echo " ${HELP[$key]}"
	fi
    done    
}
cmd_help()
{
	help_show
}
error_out()
{
    echo $@
    exit 99
}
print_gl()
{
    echo -e "\e[0;42m $@ \e[0m"
}
print_rl()
{
	echo -e "\e[0;41m $@ \e[0m"
}
print_yl()
{
	echo -e "\e[0;43m $@ \e[0m"
}
print_g()
{
    echo -e "\e[0;32m $@ \e[0m"
}
print_r()
{
	echo -e "\e[0;31m $@ \e[0m"
}
print_y()
{
	echo -e "\e[0;33m $@ \e[0m"
}
