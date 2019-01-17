
name=$1
warmup='--++'
mainloop='++--'
begintime=`date +%s`
database=`cut -d ';' -f 2 machinename`
machinename=`cut -d ';' -f 1 machinename`
while read line
do
    prefix=${line:0:4} 
    if [  "$prefix" == "$warmup" ] ; then 
    warmuptime=`date +%s` ; 
    elif [  "$prefix" == "$mainloop" ] ; then 
    executiontime=`date +%s` ; 
    fi
done < "/dev/stdin"
endtime=`date +%s`

id=`docker inspect --format "{{.Id}}" $name`
if [ -z $warmuptime ] ; then  
    warmuptime=$begintime;
fi

if [ -z $executiontime ] ;then 
    executiontime=$begintime;
fi  

echo "++++begin---"$begintime
echo '--++beginwarmup---'$warmuptime
echo '++--endwarmup---'$executiontime
echo "++++end---"$endtime ;

warmuptime=warmuptime&executiontime=$executiontime&endtime=$endtime

curl -X POST  "172.16.45.8:27019/$database/$machinename?name=$name&begin=$begintime&warmup=$warmuptime&execution=$executiontime&end=$endtime&id=$id"
# `python logger.sh.py $name $begintime $warmuptime $executiontime $endtime $collectionname`