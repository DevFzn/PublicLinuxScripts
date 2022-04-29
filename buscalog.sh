#!/usr/bin/env bash

LOGBASEDIR='/var/log';
CUSTLOGDIRS="$HOME/.config/custom_log_dirs";

lsLogDirs(){
    OIFS="$IFS"
    IFS=$'\n'
    while read -a LINEA; do
        customLogDirs+=($LINEA)
    done < $CUSTLOGDIRS
    \ls -U ${LOGBASEDIR}/*.log 2>/dev/null
    for dir in ${customLogDirs[@]}; do
        \ls -U ${dir}/*.log 2>/dev/null
    done
    IFS="$OIFS"
}

cargaLogDirs(){
    ConT=0
    OIFS="$IFS"
    IFS=$'\n'
    while read -a LINEA; do 
        [[ -r "${LINEA}" ]] && LOG_DIRS[$ConT]="${LINEA}" && ((++ConT))
    done <<< $(lsLogDirs) 
    IFS="$OIFS"
}

listLog(){
    cargaLogDirs
    clear
    local cont=0
    printf '\n    \e[1;32mSelección de Logs :\n' 
    printf '    %s\e[0m\n' "-------------------"
    for str in "${LOG_DIRS[@]}"; do
        printf '      \e[1;34m%s)\e[0m \e[0;32m%s \e[0m\n' "$cont" "${str}" | \
        sed 's/\/var\/log\///g ; s/\.log//g'
        ((++cont))
    done
    printf '      %bs)%b Salir%b\n\n' "\e[1;34m" "\e[1;32m" "\e[0m"
    local index=${#LOG_DIRS[*]}
    while :; do
        printf '%b  Ver log:%b ' "\e[1;34m" "\e[0m"
        read -p '' REPLY
        case $REPLY in
            s)  exit 0 ;;
            [0-9]|[0-9][0-9])
                [[ $REPLY -lt $index ]] &&
                showLog "${LOG_DIRS[$REPLY]}" ||
                printf '%bOpción inválida%b\n' "\e[0;31m" "\e[0m"
            ;;
            *)  printf '%bOpción inválida%b\n' "\e[0;31m" "\e[0m";;
        esac
    done
}

showLog(){
    clear
    local SEP='\e[1;37m|'
    local TITL='\e[1;32m'
    currentLog="${1}"
    local nroResults="$(grep -Eic '' "${currentLog}")"
    if [[ -e /usr/bin/batcat ]]
        then \batcat --style grid "${currentLog}"
    elif [[ -e /usr/bin/bat ]]
        then \bat --style grid "${currentLog}"
    else
        cat "${currentLog}"
    fi
    printf '\n\e[0;40m%b LOG: %b%s %b  ' "${SEP}" "${TITL}" "${1}" "${SEP}"
    printf 'ENTRADAS: %b%s  %b\e[0m' "${TITL}" "${nroResults}" "${SEP}"
    logMenu "${currentLog}"
}

logResults(){
    clear
    local SEP='\e[1;37m|'
    local TITL='\e[1;32m'
    currentLog="${1}"
    if [ $invbusq -gt 0 ]; then
        local TITBUS='BUSQ. INVERSA'
        local nroResults="$(grep -Eivc "${2}" "${1}")"
        grep -Eiv --color=auto "$2" "${1}"
    else
        local TITBUS='BUSQUEDA'
        local nroResults="$(grep -Eic "${2}" "${1}")"
        grep -Ei --color=auto "$2" "${1}"
    fi
    printf '\n\e[0;40m%b LOG: %b%s %b  ' "${SEP}" "${TITL}" "${1}" "${SEP}"
    printf '%s: %b%s %b  ' "${TITBUS}" "${TITL}" "${2}" "${SEP}"
    printf 'ECONTRADOS: %b%s  %b\e[0m' "${TITL}" "${nroResults}" "${SEP}"
    logMenu "${currentLog}"
}

logMenu(){
    current_log="${1}"
    local SEP='\e[1;30m|'
    local IND='\e[1;34m'
    local TITL='\e[0;32m'
    printf '\n %b%b v)%bolver %b' "${SEP}" "${IND}" "${TITL}" "${SEP}"
    printf ' %br)%becargar %b' "${IND}" "${TITL}" "${SEP}"
    printf ' %bb)%buscar %b' "${IND}" "${TITL}" "${SEP}"
    printf ' %bB)%busqueda inversa %b' "${IND}" "${TITL}" "${SEP}"
    printf ' %bs)%balir %b\n' "${IND}" "${TITL}" "${SEP}"
    while :; do
        printf '%bOpción:%b' "\e[1;34m" "\e[0m"
        read -p " " REPLY1
        case ${REPLY1} in
            v)  listLog ;; 
            b)  printf '%bBuscar:%b' "\e[1;34m" "\e[0m"
                read -p  ' ' QUERY 
                invbusq=0
                logResults "${current_log}" "${QUERY}" 
                ;; 
            B)  printf '%bBusqueda inversa:%b' "\e[1;34m" "\e[0m"
                read -p  ' ' QUERY 
                invbusq=1
                logResults "${current_log}" "${QUERY}" 
                ;; 
            r)  showLog "${currentLog}" ;;
            s)  exit 0 ;;
            *)  printf '%bOpción inválida%b\n' "\e[0;31m" "\e[0m";;
        esac
    done
}

"$@"
