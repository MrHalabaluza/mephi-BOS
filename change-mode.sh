#! /bin/bash

askrecursively(){ #в случае, если введён путь до директории, спрашивает у пользователя, применить ли права к файлам в ней. 0 -- применить, 1 -- нет.
    echo "Вы ввели путь к директории. Изменить права у всех файлов внутри неё? y/n: " 
    read a
    if [[ $a == "Y" || $a == "y" ]]; then
            return 0
    else
            return 1
    fi
}

change_mode(){ 
#первый аргумент -- права (u+x, o-w и т.д.), второй -- имя файла. Если задан один аргумент, то запросить имя файла
    mode=$1
    if [[ $# -ne 2 ]]; then
        echo "Введите имя файла"
        read filename
    else
        filename=$2
    fi
    if [[ -f $filename ]]; then
        chmod $mode $filename
        if [[ $? -ne 0 ]]; then
            echo "Не получилось изменить права для файла" $filename ".">&2
        fi
    elif [[ -d $filename ]]; then
        askrecursively
        if [[ $? -eq 0 ]]; then
            chmod -R $mode $filename
            if [[ $? -ne 0 ]]; then
                echo "Не получилось изменить права для файла" $filename ".">&2
            fi
        else
            chmod $mode $filename
            if [[ $? -ne 0 ]]; then
                echo "Не получилось изменить права для файла" $filename ".">&2
            fi
        fi
    else
        echo "Файл не найден:" $filename>&2
    fi
}

echo "Изменение прав доступа"
options1=("1. Изменить права доступа для владельца" "2. Изменить права доступа для группы" "3. Изменить права доступа для остальных" "4. Изменить права доступа для всех" "5. Выход")
options2=("1. Добавить право записи" "2. Убрать право записи" "3. Добавить право чтения" "4. Удалить право чтения" "5. Добавить право исполнения" "6. Удалить право исполнения" "7. Добавить бит SUID" "8. Удалить бит SUID" "9. Выход")
options3=("1. Добавить право записи" "2. Убрать право записи" "3. Добавить право чтения" "4. Удалить право чтения" "5. Добавить право исполнения" "6. Удалить право исполнения" "7. Добавить бит GUID" "8. Удалить бит GUID" "9. Выход")
options4=("1. Добавить право записи" "2. Убрать право записи" "3. Добавить право чтения" "4. Удалить право чтения" "5. Добавить право исполнения" "6. Удалить право исполнения" "7. Выход")

while :
do
    for opt1 in "${options1[@]}"
    do
        echo $opt1
    done
    read answer1
    case $answer1 in
        "1") #для владельца
            for opt2 in "${options2[@]}"
            do
                echo $opt2
            done
            read answer2
            case $answer2 in
                "1") #+w
                    change_mode "u+w" $1
                ;;
                "2") #-w
                    change_mode "u-w" $1
                ;;
                "3") #+r
                    change_mode "u+r" $1
                ;;
                "4") #-r
                    change_mode "u-r" $1
                ;;
                "5") #+x
                    change_mode "u+x" $1
                ;;
                "6") #-x
                    change_mode "u-x" $1
                ;;
                "7") #u+s
                    change_mode "u+s" 
                    break$1
                ;;
                "8") #u-s
                    change_mode "u-s" $1
                ;;
                "9")
                ;;
                *)
                    echo "Неверный ввод!">&2
                ;;
            esac
        ;;
        "2") #для группы
            for opt3 in "${options3[@]}"
            do
                echo $opt3
            done
            read answer2
            case $answer2 in
                "1") #+w
                    change_mode "g+w" $1
                ;;
                "2") #-w
                    change_mode "g-w" $1
                ;;
                "3") #+r
                    change_mode "g+r" $1
                ;;
                "4") #-r
                    change_mode "g-r" $1
                ;;
                "5") #+x
                    change_mode "g+x" $1
                ;;
                "6") #-x
                    change_mode "g-x" $1
                ;;
                "7") #u+s
                    change_mode "g+s" $1
                ;;
                "8") #u-s
                    change_mode "g-s" $1
                ;;
                "9")
                    break
                ;;
                *)
                    echo "Неверный ввод!">&2
                ;;
            esac
        ;;
        "3") #для остальных
            for opt4 in "${options4[@]}"
            do
                echo $opt4
            done
            read answer2
            case $answer2 in
                "1") #+w
                    change_mode "o+w" $1
                ;;
                "2") #-w
                    change_mode "o-w" $1
                ;;
                "3") #+r
                    change_mode "o+r" $1
                ;;
                "4") #-r
                    change_mode "o-r" $1
                ;;
                "5") #+x
                    change_mode "o+x" $1
                ;;
                "6") #-x
                    change_mode "o-x" $1
                ;;
                "7")
                        break
                    ;;
                *)
                    echo "Неверный ввод!">&2
                ;;
            esac
        ;;
        "4") #для всех
            for opt4 in "${options4[@]}"
            do
                echo $opt4
            done
            read answer2
            case $answer2 in
                "1") #+w
                    change_mode "a+w" $1
                ;;
                "2") #-w
                    change_mode "a-w" $1
                ;;
                "3") #+r
                    change_mode "a+r" $1
                ;;
                "4") #-r
                    change_mode "a-r" $1
                ;;
                "5") #+x
                    change_mode "a+x" $1
                ;;
                "6") #-x
                    change_mode "a-x" $1
                ;;
                "7")
                    break
                ;;
                *)
                    echo "Неверный ввод!">&2
                ;;
            esac
        ;;
        "5")
            break
        ;;
        *)
            echo "Неверный ввод!">&2
        ;;
    esac
done
