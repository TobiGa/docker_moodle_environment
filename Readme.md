# setup:
Clone git repository
with  --recurse-submodules to load moodle.git

	git clone --recurse-submodules https://github.com/TobiGa/docker_moodle_environment.git foldernameAsDesired

build docker image
	
	sudo docker-compose build

run docker image

	sudo docker-compose up \ Ctrl+C to stop



## Urls:
moodle:<br>
http://localhost/moodle

phpmyadmin:<br>
http://localhost/phpmyadmin

behat:<br>
http://127.0.0.1/moodle

selenium:<br>
http://localhost:4444/wd/hub/


## User:
Mysql:<br>
root
pw_root


## Docker-Commands:
show running container
	`sudo docker ps`

stop running container
	`sudo docker stop (sudo docker ps -a -q)`	

shell access 
	`sudo docker exec -it containername bash`

delete images
	`sudo docker down`<br>
with database/volume
	`sudo docker down -v`	


## test:

Results: /moodle/behat_testoutput<br>
`vendor/bin/behat --config /var/www/behat_moodledata/behatrun/behat/behat.yml --tags @mod_book --format moodle_screenshot --format-settings '{"formats": "html", "image"}' --out '/var/www/html/mbsmoodle/behat_testoutput' --format moodle_progress --out "/var/www/html/mbsmoodle/behat_testoutput/progress_$(date +"%y_%m_%d").txt"`



## Docker Tutorials:
https://severalnines.com/blog/mysql-docker-containers-understanding-basics<br>
https://www.codeschool.com/courses/try-docker<br>
https://docker-curriculum.com/<br>
