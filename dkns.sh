NS_RC=$1
docker ps -q | xargs docker inspect --format '{{.State.Pid}}{{.Name}}' > ./nlist
LINE=`cat ./nlist | wc -l`
i=1;
for d in `cat ./nlist`;do
    if [ "$NS_RC" = "getns" ];then
        echo -n $i.$d
        cpid=`echo "cat ./nlist | awk 'NR==$i' | cut -d '/' -f 1" | sh -`
        name=`echo "cat ./nlist | awk 'NR==$i' | cut -d '/' -f 2" | sh -`
        [ "$cpid" = "" -o "$name" = "" ] && echo "error pid" && exit
        rm -f /var/run/netns/$name
        ln -sf /proc/$cpid/ns/net /var/run/netns/$name
        echo "======>ok"
    else
        echo $i.$d
    fi
    i=$((i+1))
done
if [ "$NS_RC" = "getns" ];then
    echo "ip netns list:"
    ip netns list
    exit 0
fi

read -p "select one : " NUM

cpid=`echo "cat ./nlist | awk 'NR==$NUM' | cut -d '/' -f 1" | sh -`
name=`echo "cat ./nlist | awk 'NR==$NUM' | cut -d '/' -f 2" | sh -`
echo $cpid,$name

[ "$cpid" = "" -o "$name" = "" ] && echo "error pid" && exit
rm -f /var/run/netns/$name
ln -sf /proc/$cpid/ns/net /var/run/netns/$name

ip netns exec $name bash

#rm -f /var/run/netns/$name


