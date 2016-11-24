#! /bin/bash
echo 'Поиск файлов, доступных всем пользователям на запись.'
find / -type f -perm -a+w | less

