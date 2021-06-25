```
# tools
git-cclone: put it in /usr/lib/git-core/  , and you can use git cclone ssh://xxx.xxx.xxx/yorrepo.git
time git cclone https://github.com/torvalds/linux.git linux
real    8m20.159s
user    8m36.355s
sys     1m21.557s

time git cclone https://github.com/torvalds/linux.git linux2
real    0m7.436s
user    0m4.271s
sys     0m2.339s



ipns.sh: exec ip netns by select netns
dkns.sh: select docker name and re-create ip ns, then can list net

cd_history.sh :
  Install:
    #cp cd_history.sh ~/.local/cd_history.sh
    wget -O ~/.local/cd_history.sh https://raw.githubusercontent.com/joely1101/tools/master/cd_history.sh 
    add below in ~/.profile
    #####source cd_history.sh when login #####
    if [ -f $HOME/.local/cd_history.sh ] ;then
        . $HOME/.local/cd_history.sh
    fi
    ###########################################
  USAGE:
	cd /work/1
	cd /work/2
	cd /work/3
	cds
	0:/work/3
	1:/work/2
	2:/work/1
	cd -2  ===> cd /work/1
	cd -1 ===> cd /work/2
	cd -c ===> clear hostory
	
```
