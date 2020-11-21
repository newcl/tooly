for i in `seq 300000` 
do
	curl -XPOST http://0.0.0.0:3000/api/shorty?url=twitter.com
done
