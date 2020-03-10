#!/bin/bash
exec_build_you_function()
{
    echo "exec ${FUNCNAME[0]} $@"
}
exec_aa_rr_dd()
{
    echo "exec ${FUNCNAME[0]} $@"
}

# Callback
# ----------------------------------------------------------------------------
# Detect callback function and fallback to git if it doesn't exist.
#max is 3 argument
argc=$#
all_argv="$@"

__callback="exec_${all_argv// /_}"
for ((i=0;i<$argc-1;i++));do
    shfinum=$((argc-i))
    if [[ `declare -Ff $__callback` ]];then
        shift $shfinum
        echo "call $__callback '$@'"
        $__callback "$@"
        break
    else
        __callback=${__callback%_*}
#        echo "not foun try ===>$__callback"
    fi
done

