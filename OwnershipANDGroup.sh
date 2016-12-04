#!/bin/bash
# На вход имя файла или директории. Скрипт должен быть запущен от рута, файл или директория должны существовать.
echo "Изменение владельца или группы файла"
PS3="Выберите следующее действие:"
options=("Изменение владельца" "Изменение группы" "Выход")
choose=("Выполнить рекурсивно для директории" "Выполнить только для папки" "Выход")
select opt in "${options[@]}"
do
	case $REPLY in
		1)
			while [ 1 ];
			do				
				echo "Введите имя нового владельца:"				
				read USERNAMEN
				grep -i "^$USERNAMEN:" /etc/passwd >/dev/null
				if [ $? -ne 0 ]; 
				then
					echo "Пользователь не существует" >&2
					echo "Повторить? (y/n)"
					while [ 1 ];
					do
						read ANSWER
						if [ "$ANSWER" == "n" ];
						then 
							break
						elif [ "$ANSWER" != "y" ];
						then
							echo "Не верный ввод, повторите"
							echo "Ввести пользователя? (y/n)"
						else 
							break
						fi
					done
					if [ "$ANSWER" == "n" ];
					then
						break
					fi
				else
					if [ -f $1 ]; then
						 chown $USERNAMEN: $1
						echo "Влвделец файла изменен успешно!"
						break
					elif [ -d $1 ]; then
						 echo "Директория! Вберите следующее действие:"
						select ch in "${choose[@]}"
						do
							case $REPLY in
								1)  
									chown -R $USERNAMEN: $1
									echo "Владелец изменен у каждого файла директории!"
									break
									;;
								2)
									chown $USERNAMEN: $1
									echo "Владелец папки изменен успешно!"
									break
									;;
								3)
									break
									;;
								"help") echo "Выберите следующее действие:
1) Выполнить рекурсивно для всей директории
2) Выполнить только для папки
3) Вернуться"
									;;
								*) echo "Некорректный ввод!" >&2
									 ;;
							esac
						done
						break
					else
						 echo "Некорректный ввод!" >&2
					fi
				fi
			done
			;;
			2)
				while [ 1 ];
				do
					echo "Введите название группы:"
				read NAMEGROUP
				grep -i "^$NAMEGROUP:" /etc/group >/dev/null
				if [ $? -ne 0 ];				
				then
					echo "Группа не существует!" >&2
					echo "Повторить? (y/n)"
					while [ 1 ];
					do
						read ANSWER
						if [ "$ANSWER" == "n" ];
						then
							break
						elif [ "$ANSWER" != "y" ];
						then
							echo "Неверный ввод, повторите"
							echo "Ввести пользователя? (y/n)"
						else
							break
						fi
					done
					if [ "$ANSWER" == "n" ]
					then
						break
					fi
				else
					if [ -f $1 ]; then
						chown :$NAMEGROUP $1
						echo "Группа файла изменена успешно!"
						break
					elif [ -d $1 ]; then
						echo "Директория! Выполните следующее действие:"
						select ch in "${choose[@]}";
						do
							case $REPLY in
								1)
									chown -R :$NAMEGROUP $1
									echo "Группа директории изменена для каждого файла директории!!"
									break
									;;
								2)
									chown :$NAMEGROUP $1
									echo "Группа папки изменена успешно!"
									break
									;;
								3)
									break
									;;
								"help") echo "Выберите следующее действие:
1) Выполнить рекурсивно для директории
2) Выполнить только для папки
3) Вернуться"
									;;
								*) echo "Некорректный ввод!" >&2
									;;
							esac
						done
						break
					else
						echo "Некорректный ввод!" >&2
					fi
				fi
			done
			;;
		3)
			break
			;;
		"help") echo "Выберите следующее действие
1) Изменение владельца
2) Изменение группы
3) Вернуться"
			;;
		*) echo "Некорректный ввод!" >&2
			;;
	esac
done







