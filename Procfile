web:						bundle exec thin start -p $PORT
worker:					QUEUE=* bundle exec rake resque:work
# priceworker:		QUEUE=prices bundle exec rake resque:work
# itemworker:			QUEUE=items bundle exec rake resque:work
# recipeworker:		QUEUE=recipes bundle exec rake resque:work