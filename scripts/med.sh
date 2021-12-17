#!/bin/bash

paste -d'\t' $1 $2 | awk '
BEGIN {
sum=0;
}
{
a1 = $1;
a2 = $2;
IGNORECASE = 1;
if( a2 ~ /x/ ){
        next;
}
if( a1 ~ /x/ ){
        next;
}
diff=(a1-a2)
if (diff<0){diff=-1*diff}
#if (diff != 0) print
sum=sum+diff
}
END {
med=sum/NR; 
printf "%.3e\n",med
}'
