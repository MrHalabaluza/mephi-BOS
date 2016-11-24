#! /bin/bash
echo 'Поиск файлов, доступных всем пользователям на запись.'
find / -type f -perm -a+w 2>/dev/null | less

