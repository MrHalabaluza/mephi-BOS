#!/bin/bash
# На вход имя файла или директории. Скрипт должен быть запущен от рута, файл или директория должны существовать.
echo "Изменение владельца или группы файла"
PS3="Выберите следующее действие:"
options=("Изменение владельца" "Изменение группы" "Выход")
choose=("Выполнить рекурсивно для директории" "Выполнить только для папки")
select opt in "${options[@]}"
do
	case $opt in
		"Изменение владельца")
			echo "Введите имя нового владельца:"			
			read USERNAMEN
			grep "$USERNAMEN:" /etc/passwd >/dev/null
			if [ $? -ne 0 ]; then
				echo "Пользователь не существует!" >&2
			else
				 if [ -f $1 ]; then
					 chown $USERNAMEN: $1
					 echo "Влвделец файла изменен успешно!"
				 elif [ -d $1 ]; then
					 echo "Директория! Вберите следующее действие:"
					 select ch in "${choose[@]}"
					 do
						 case $ch in
							 "Выполнить рекурсивно для директории")
								 chown -R $USERNAMEN: $1
								 echo "Владелец изменен у каждого файла директории!"
								 break
								 ;;
							 "Выполнить только для папки")
								 chown $USERNAMEN: $1
								  echo "Владелец папки изменен успешно!"
								  break
								  ;;
							 *) echo "Некорректный ввод!" >&2
								 ;;
						 esac 
					 done
				 else
					 echo "Некорректный ввод!" >&2
				 fi
			 fi
			 ;;
		"Изменение группы")
			echo "Введите название группы:"
			read NAMEGROUP
			grep -q -E "^$NAMEGROUP:" /etc/group >/dev/null
			if [ $? -ne 0 ];
			then
				echo "Группа не существует!" >&2
			else
				if [ -f $1 ]; then
					chown :$NAMEGROUP $1
					echo "Группа файла изменена успешно!"
				elif [ -d $1 ]; then
					echo "Директория! Выполните следующее действие:"
					select ch in "${choose[@]}";
					do
						case $ch in
							"Выполнить рекурсивно для директории")
								chown -R :$NAMEGROUP $1
								echo "Группа директории изменена для каждого файла директории!!"
								break
								;;
							"Выполнить только для папки")
								chown :$NAMEGROUP $1
								echo "Группа папки изменена успешно!"
								break
								;;
							*) echo "Некорректный ввод!" >&2
								;;
						esac
					done
				else
					echo "Некорректный ввод!" >&2
				fi
			fi
			;;
		"Выход")
			break
			;;
		*) echo "Некорректный ввод!" >&2
			;;
	esac
done







