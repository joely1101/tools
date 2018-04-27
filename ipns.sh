NUM=$1
ls /var/run/netns/ > ./dlist
LINE=`cat ./dlist | wc -l`
i=1;
while read LINE
do
echo $i.$LINE
i=$((i+1))
done  < ./dlist

read -p "select one : " NUM
name=`echo "cat ./dlist | awk 'NR==$NUM'" | sh -`
ip netns exec "$name" bash


