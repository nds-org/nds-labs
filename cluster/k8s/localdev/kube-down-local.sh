#!bin/bash

array=( `docker ps | grep gcr | awk '{print $1}'` )

for i in "${array[@]}"
do
	echo Removing: $i
	docker rm -f $i
done
