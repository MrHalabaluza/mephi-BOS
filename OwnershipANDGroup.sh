#!/bin/bash
echo "Changing the ownership and group of file."

options=("Changing the ownership"
"Changing the group" 
"Exit")
select opt in "${options[@]}";
do
	case $opt in
		"Changing the ownership")
			echo "Enter the name of new ownership:"
			read USERNAMEN
			grep "$USERNAMEN:" /etc/passwd >/dev/null
			if [ $? -ne 0 ];
			then
				echo "User is not exist!"
			else
				chown $USERNAMEN $1
				echo "Ownership changed successfully!"
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
				chown :$NAMEGROUP $1
				echo "Group changed successfully!"
			fi
			;;
		"Exit")
			break
			;;
		*) echo "Wrong answer. Try again!"
	esac
done




