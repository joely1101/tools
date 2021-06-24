#!/bin/bash
#$1 repo_name define in repo.config

[ -z "$BUILD_TOP" ] && BUILD_TOP=.
#CONFIG=${BUILD_TOP}/repo.config
. $BUILD_TOP/scripts/cmd.head.sh
cache_dir=~/.mygitcache
mkdir -p $cache_dir

cmd_clone()
{
   CONFIG=$2
   [ -z "$1" ] && error_out "Invalid parameter"
   [ -z "$2" ] && error_out "Invalid parameter"
   [ -z "$3" ] && error_out "Invalid parameter"
   
   repourl=$1
   branch=$2
   target=$3
   
   print_gl "repo url : $repourl"
   print_gl "branch   : $branch"
   print_gl "directory      : $target"
   
   [ -d "$target" ] && print_g "already exist, ignore checkout" && return
      
   mkdir -p `basename $target`
   #branch is tag/commitid/branch
   URLMD5=`echo $repourl | md5sum | cut -f1 -d" "`
   cache_dir=${cache_dir}/${URLMD5}
   if [ ! -d ${cache_dir} ];then
       do_cmd "git clone ${repourl} ${cache_dir}"
   fi
   do_cmd "git clone --recurse-submodule ${repourl} --reference=${cache_dir} $target"
   [ "$branch" != "" ] && git -C $target checkout $branch
}



help_add "clone" "clone repo_url [ branch ] [dest dir]  - clone with auto cache"

get_by_var()
{
   #repo_url#branch_tag_cid#dest_dir
   varstr=$1
   target=${varstr##*#}
   repourl_br=${varstr%#*}
   branch=${repourl_br##*#}
   repourl=${repourl_br%#*}
   if [ "$branch" = "$target" ];then
    #no assigned target
    target=`dirname repourl`
    target=${target%.git}
   fi
   #no assigned branch
   [ "$branch" = "$repourl" ] && branch=""
   cmd_clone "$repourl" "$branch" "$target"
}
cmd_get()
{
   CONFIG=$2
   [ -z "$1" ] && error_out "Invalid parameter"
   if [ ! -f "$CONFIG" ];then
       print_rl "config file not found"
       exit 99   
   fi
   
   #format : repo_url#branch_tag_cid#dest_dir
   repourla=`grep -E "^${1}_repo_url" ${CONFIG} | cut -d= -f2`
   
   [ -z "$repourla" ] && error_out "${1}_repo_url variable not found"
   get_by_var "$repourla"
}
help_add "get" "get [xxx] configfile - clone xxx_repo_url in config"

cmd_get_all()
{
   CONFIG=$1
   if [ ! -f "$CONFIG" ];then
       print_rl "config file not found"
       exit 99   
   fi
   while IFS= read -r line
   do
     name=`echo "$line" | grep "^[a-z,A-Z,0-9,_]*_repo_url="`
     [ "$name" = "" ] && continue
     str=${line#*_repo_url=}
     #print_yl "clone $str"
     get_by_var "$str"
   done < "$CONFIG"
}
help_add "getall" "get all configfile - get all repo in config file" 

. $BUILD_TOP/scripts/cmd.tail.sh
