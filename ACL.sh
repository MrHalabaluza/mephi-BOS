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
	case "$opt" in
		${options[0]})
			echo " Добавление записи"
			echo "Пользователь или группа? (u/g)) "
			read ans
			case "$ans" in
				u|U) echo "Введите имя пользователя"
					read username
					defineRights
					setfacl -m u:$username:$rights $filename
					;;
				g|G) echo "Введите имя группы"
					read groupname
					defineRights
					setfacl -m g:$groupname:$right $filename
					;;
				*) 
					echo "Неверный ввод"
					continue
					;;
			esac
			;;
		${options[1]})
			echo "Удаление записи"
			echo "Пользователь или группа? (u/g)) "
			read ans
			case "$ans" in
				u|U) echo "Введите имя пользователя"
					read username
					setfacl -x u:$username $filename
					;;
				g|G) echo "Введите имя группы"
					read groupname
					setfacl -x g:$groupname $filename
					;;
				*)	 echo "Неверный ввод"
					continue
					;;
			esac
			;;
		${options[2]})
			echo "Изменение записи"
				echo "Пользователь или группа? (u/g)) "
			read ans
			case "$ans" in
				u|U) echo "Введите имя пользователя"
					read username
					getfacl $filename
					defineRights
					setfacl -m u:$username:$rights $filename
					;;
				g|G) echo "Введите имя группы"
					read groupname
					getfacl $filename
					defineRights
					setfacl -m g:$groupname:$rights $filename
					;;
				*) echo "Неверный ввод"
					continue
					;;
			esac
			;;
		${options[3]}) 
			break
			;;

		*) echo "Неверный ввод"
			continue
			;;
	esac
	echo "Done!"
done

