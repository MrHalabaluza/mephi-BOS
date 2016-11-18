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
            echo "Не получилось изменить права для файла" $filename ". Попробуйте запустить скрипт от имени суперпользователя.">&2
        fi
    elif [[ -d $filename ]]; then
        askrecursively
        if [[ $? -eq 0 ]]; then
            chmod -R $mode $filename
            if [[ $? -ne 0 ]]; then
                echo "Не получилось изменить права для файла" $filename ". Попробуйте запустить скрипт от имени суперпользователя.">&2
            fi
        else
            chmod $mode $filename
            if [[ $? -ne 0 ]]; then
                echo "Не получилось изменить права для файла" $filename ". Попробуйте запустить скрипт от имени суперпользователя.">&2
            fi
        fi
    else
        echo "Файл не найден:" $filename>&2
    fi
}

echo "Изменение прав доступа"
options1=("Изменить права доступа для владельца" "Изменить права доступа для группы" "Изменить права доступа для остальных" "Изменить права доступа для всех")
options2=("Добавить право записи" "Убрать право записи" "Добавить право чтения" "Удалить право чтения" "Добавить право исполнения" "Удалить право исполнения" "Добавить бит SUID" "Удалить бит SUID")
options3=("Добавить право записи" "Убрать право записи" "Добавить право чтения" "Удалить право чтения" "Добавить право исполнения" "Удалить право исполнения" "Добавить бит SGID" "Удалить бит SGID")
options4=("Добавить право записи" "Убрать право записи" "Добавить право чтения" "Удалить право чтения" "Добавить право исполнения" "Удалить право исполнения")


select opt1 in "${options1[@]}"
do
    case $opt1 in
        ${options1[0]}) #для владельца
            select opt2 in "${options2[@]}"
            do
                case $opt2 in
                    ${options2[0]}) #+w
                        change_mode "u+w" $1
                    ;;
                    ${options2[1]}) #-w
                        change_mode "u-w" $1
                    ;;
                    ${options2[2]}) #+r
                        change_mode "u+r" $1
                    ;;
                    ${options2[3]}) #-r
                        change_mode "u-r" $1
                    ;;
                    ${options2[4]}) #+x
                        change_mode "u+x" $1
                    ;;
                    ${options2[5]}) #-x
                        change_mode "u-x" $1
                    ;;
                    ${options2[6]}) #u+s
                        change_mode "u+s" $1
                    ;;
                    ${options2[7]}) #u-s
                        change_mode "u-s" $1
                    ;;
                    "Выход")
                        break
                    ;;
                    *)
                        echo "Неверный ввод!">&2
                    ;;
                esac
            done
            ;;
        ${options1[1]}) #для группы
        select opt2 in "${options2[@]}"
        do
            case $opt2 in
                ${options3[0]}) #+w
                    change_mode "g+w" $1
                ;;
                ${options3[1]}) #-w
                    change_mode "g-w" $1
                ;;
                ${options3[2]}) #+r
                    change_mode "g+r" $1
                ;;
                ${options3[3]}) #-r
                    change_mode "g-r" $1
                ;;
                ${options3[4]}) #+x
                    change_mode "g+x" $1
                ;;
                ${options3[5]}) #-x
                    change_mode "g-x" $1
                ;;
                ${options3[6]}) #u+s
                    change_mode "g+s" $1
                ;;
                ${options3[7]}) #u-s
                    change_mode "g-s" $1
                ;;
                "Выход")
                    break
                ;;
                *)
                    echo "Неверный ввод!">&2
                ;;
            esac
        done
        ;;
        ${options1[2]}) #для остальных
        select opt2 in "${options2[@]}"
        do
            case $opt2 in
                ${options4[0]}) #+w
                    change_mode "o+w" $1
                ;;
                ${options4[1]}) #-w
                    change_mode "o-w" $1
                ;;
                ${options4[2]}) #+r
                    change_mode "o+r" $1
                ;;
                ${options4[3]}) #-r
                    change_mode "o-r" $1
                ;;
                ${options4[4]}) #+x
                    change_mode "o+x" $1
                ;;
                ${options4[5]}) #-x
                    change_mode "o-x" $1
                ;;
                "Выход")
                        break
                    ;;
                    *)
                        echo "Неверный ввод!">&2
                    ;;
            esac
        done
        ;;
        ${options1[3]}) #для всех
        
            select opt2 in "${options2[@]}"
            do
                case $opt2 in
                    ${options4[0]}) #+w
                        change_mode "a+w" $1
                    ;;
                    ${options4[1]}) #-w
                        change_mode "a-w" $1
                    ;;
                    ${options4[2]}) #+r
                        change_mode "a+r" $1
                    ;;
                    ${options4[3]}) #-r
                        change_mode "a-r" $1
                    ;;
                    ${options4[4]}) #+x
                        change_mode "a+x" $1
                    ;;
                    ${options4[5]}) #-x
                        change_mode "a-x" $1
                    ;;
                    "Выход")
                        break
                    ;;
                    *)
                        echo "Неверный ввод!">&2
                    ;;
                esac
            done
            ;;
        "Выход")
            break
        ;;
        *)
            echo "Неверный ввод!">&2
        ;;
    esac
done
