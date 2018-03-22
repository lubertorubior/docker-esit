
build:
	docker build -t nginxphp .

up:
	docker run --rm --name nginxphp -d --name nginxphp  -p 2324:80 nginxphp  
down:
	docker stop nginxphp
status:
	docker ps -a | grep nginxphp
up-devel:
	docker run  --name nginxphp --rm -ti -v $(PWD)/src:/var/www/html --name nginxphp  -p 2324:80 nginxphp  /msdnaa/start.sh
