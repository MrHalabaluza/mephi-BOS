#!/bin/bash
# На вход имя файла или директории. Скрипт должен быть запущен от рута, файл или директория должны существовать.
echo "Changing the ownership and group of file."
PS3="Enter our choice:"
options=("Changing the ownership" "Changing the group" "Exit")
choose=("To do it recursively" "To do it only for the directory")
select opt in "${options[@]}"
do
	case $opt in
		"Changing the ownership")
			echo "Enter the name of new ownership:"			
			read USERNAMEN
			grep "$USERNAMEN:" /etc/passwd >/dev/null
			if [ $? -ne 0 ]; then
				echo "User is not exist!"
			else
				 if [ -f $1 ]; then
					 chown $USERNAMEN: $1
					 echo "Ownership of the file  changed successfully!"
				 elif [ -d $1 ]; then
					 echo "Argument is a name of directory, choose your next step please"
					 select ch in "${choose[@]}"
					 do
						 case $ch in
							 "To do it recursively")
								 chown -R $USERNAMEN: $1
								 echo "Ownership changed recursively!Successful!"
								 break
								 ;;
							 "To do it only for the directory")
								 chown $USERNAMEN: $1
								  echo "Ownership of the directory changed successfully!"
								  break
								  ;;
							 *) echo "Wrong answer!" 
						 esac 
					 done
				 else
					 echo "Wrong argument!"
				 fi
			 fi
			 ;;
		"Changing the group")
			echo "Enter the group:"
			read NAMEGROUP
			grep -q -E "^$NAMEGROUP:" /etc/group >/dev/null
			if [ $? -ne 0 ];
			then
				echo "Group is not exist!"
			else
				if [ -f $1 ]; then
					chown :$NAMEGROUP $1
					echo "Group of the file changed successfully!"
				elif [ -d $1 ]; then
					echo "Argument is a name of directory, choose your next step please"
					select ch in "${choose[@]}";
					do
						case $ch in
							"To do it recursively")
								chown -R :$NAMEGROUP $1
								echo "Group changed recursively! Successful!"
								break
								;;
							"To do it only for the directory")
								chown :$NAMEGROUP $1
								echo "Group of the directory changed successfully!"
								break
								;;
							*) echo "Wrong answer!"
						esac
					done
				else
					echo "Wrong argument!"
				fi
			fi
			;;
		"Exit")
			break
			;;
		*) echo "Wrong answer. Try again!"
	esac
done







