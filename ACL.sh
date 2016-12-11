#!/bin/bash
#
# Изменение ACL прав файла
#на вход нужно подать имя файла
filename="$1" #может быть неправильно

defineRights(){
					echo "Установить права на чтение?(y/n)"
					read ans
					case "$ans" in 
						y|Y) r_right='r'
							;;
						n|N) r_right='-'
							;;
						*) 
						echo "Неверный ввод"
						continue
						;;
						esac

			echo "Установить права на запись?(y/n)"
					read ans
					case "$ans" in 
						y|Y) w_right='w'
							;;
						n|N) w_right='-'
							;;
					*) 
					echo "Неверный ввод"
					continue
					;;
			esac

			echo "Установить права на запуск?(y/n)"
					read ans
					case "$ans" in 
						y|Y) x_right='x'
							;;
						n|N) x_right='-'
							;;
						*)
							echo "Неверный ввод"
							continue
							;;
					esac
					rights="$r_right$w_right$x_right"
}
options=("Добавить запись" "Удалить запись" "Изменить запись" "Назад")
select opt in "${options[@]}"
do
	#case "$opt" in
	case $REPLY in
		1)
		while [ 1 ];
		 do
			echo " Добавление записи"
			echo "Пользователь или группа? (u/g)) "
			read ans
			case "$ans" in
				u|U) echo "Введите имя пользователя"
					read username
					grep -i "^$username:" /etc/passwd >/dev/null
					if [ $? -ne 0 ]; 
					then
						echo "Пользователь не существует" 
						echo "Повторить? (y/n)"
						read ANSWER
						if [ "$ANSWER" == "n" ];
						then 
							break
						fi
					else
						if [ -f $1 ];
						 then
							defineRights
							setfacl -m u:$username:$rights $filename	
							echo "Права изменены успешно!"
							break
						fi
					fi			                   
					;;
				g|G) echo "Введите имя группы"
					read groupname
					grep -i "^$groupname:" /etc/group >/dev/null
					if [ $? -ne 0 ]; 
					then
						echo "Группа не существует" 
						echo "Повторить? (y/n)"
						read ANSWER
						if [ "$ANSWER" == "n" ];
						then 
							break
						fi
					else
						if [ -f $1 ];
						 then
							defineRights
							setfacl -m g:$groupname:$right $filename	
							echo "Права изменены успешно!"
							break
						fi
					fi	
					;;
				
				*) 
					echo "Неверный ввод"
					continue
					;;
			
			esac
			done			
		;;
		2)
			echo "Удаление записи"
			while [ 1 ];
			do
				echo "Пользователь или группа? (u/g)) "
				read ans
				case "$ans" in
					u|U) echo "Введите имя пользователя"
						read username
						grep -i "^$username:" /etc/passwd >/dev/null
						if [ $? -ne 0 ]; 
						then
							echo "Пользователь не существует" 
							echo "Повторить? (y/n)"
							read ANSWER
							if [ "$ANSWER" == "n" ];
							then 
								break
							fi
						else
							if [ -f $1 ];
							 then
							
								setfacl -x u:$username $filename	
								echo "Удалено!"
								break
							fi
						fi					
						;;
					g|G) echo "Введите имя группы"
						read groupname
						grep -i "^$groupname:" /etc/group >/dev/null
						if [ $? -ne 0 ]; 
						then
							echo "Группа не существует" 
							echo "Повторить? (y/n)"
							read ANSWER
							if [ "$ANSWER" == "n" ];
							then 
								break
							fi
						else
							if [ -f $1 ];
							 then
								setfacl -x g:$groupname $filename
								echo "Удалено!"
								break
							fi
						fi	
						;;
					*)	 echo "Неверный ввод"
						continue
						;;
				esac
				done
			;;
		3)
			echo "Изменение записи"
			while [ 1 ];
			do
				echo "Пользователь или группа? (u/g)) "
				read ans
				case "$ans" in
					u|U) echo "Введите имя пользователя"
						read username
						grep -i "^$username:" /etc/passwd >/dev/null
					        if [ $? -ne 0 ]; 
					        then
							echo "Пользователь не существует" 
							echo "Повторить? (y/n)"
							read ANSWER
							if [ "$ANSWER" == "n" ];
							then 
								break
							fi
					        else
							if [ -f $1 ];
						 	then
								getfacl $filename
								defineRights
								setfacl -m u:$username:$rights $filename	
								echo "Права изменены успешно!"
								break
							fi
					fi	
						;;
					g|G) echo "Введите имя группы"
					     read groupname
						grep -i "^$groupname:" /etc/group >/dev/null
						if [ $? -ne 0 ]; 
						then
							echo "Группа не существует" 
							echo "Повторить? (y/n)"
							read ANSWER
							if [ "$ANSWER" == "n" ];
							then 
								break
							fi
						else
							if [ -f $1 ];
							 then
								getfacl $filename
								defineRights
								setfacl -m g:$groupname:$right $filename	
								echo "Права изменены успешно!"
								break
							fi
						fi	
						;;
					*) echo "Неверный ввод"
						continue
						;;
				esac
				done
			;;
		4) 
			break
			;;
		"help") 
			echo "Выберите следующее действие: 
			1) Добавить запись
			2) Удалить запись
			3) Изменить запись
			4) Назад"
			;;

		*) echo "Неверный ввод"
			continue
			;;
	esac
echo "Done!"
done