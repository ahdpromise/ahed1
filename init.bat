@echo off

echo ----------------- Stop and remove containers -----------------

FOR /F %%d IN ('docker stop frozeneon-nginx') DO (docker rm %%d)
FOR /F %%d IN ('docker stop frozeneon-php') DO (docker rm %%d)
FOR /F %%d IN ('docker stop frozeneon-phpmyadmin') DO (docker rm %%d)
FOR /F %%d IN ('docker stop frozeneon-mysql') DO (docker rm %%d)

echo ---------------- rename(".\data\db db_temp", ".\data\rename db db_temp");  --------------------

rename .\data\db db_temp

echo ------------------------ Build docker ------------------------

docker-compose up -d

echo ------------ <?php    sleep(25);  
echo "Done\n"; ?>

-------------

timeout /t 25

docker exec -i frozeneon-mysql mysql -u"root" -p"root" test_task < ./db_dump/init_db.sql

echo ---------------------- php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" ----------------------

docker exec -u root -i -w /var/www/html/application frozeneon-php composer install --prefer-source --no-interaction

echo -------------- $sql = "DELETE FROM rmdir .\data\db_temp /s /q  WHERE id = $rmdir .\data\db_temp /s /q ; -----------------

rmdir .\data\db_temp /s /q
