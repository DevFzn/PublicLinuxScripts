#!/usr/bin/env bash

REd="\e[0;31m";  GRn="\e[0;32m";  ORn="\e[33m";
FND="\e[40m";    RED="\e[1;31m";  GRN="\e[1;32m";
MGNT="\e[1;35m"; BLU="\e[1;34m";  RST="\e[0m";
CYA="\e[1;36m";  CYa="\e[0;36m";

Caldera(){
    xfce4-terminal --geometry 27x22+850+350 --hide-toolbar --hide-borders --hide-menubar \
                   --working-directory $HOME/Arduino/Proyectos/termoRat/scripts/ \
                   --execute $HOME/Arduino/Proyectos/termoRat/scripts/caldera.py
}

Termo(){
    xfce4-terminal --geometry 30x24+850+350 --hide-toolbar --hide-borders --hide-menubar \
                   --working-directory $HOME/Arduino/Proyectos/termoRat/scripts/ \
                   --execute $HOME/Arduino/Proyectos/termoRat/scripts/caldera.sh
}

Neo(){
    Imprime_Logos(){
        printf "LOGOS: "
        awk '/ascii_distro/{flag=1;next} /ascii_bold/{flag=0} flag {print}' \
        <<< "$(neofetch --help)" | sed 's/^ */\t/'
    }
    case "${1}" in
        "-h")
            Imprime_Logos
            ;;
        *)
            clear && neofetch --ascii_distro "$1"
            ;;
    esac
}

yutu(){
    local BUSQUEDA="$*"
    local BUSQUEDA="${BUSQUEDA// /+}"
    mpv "https://youtube.com/$(curl -s "https://vid.puffyan.us/search?q=${BUSQUEDA}" | \
    grep -Eo "watch\?v=.{11}" | head -n 1)" &
}

kaltest() { 
    [[ -n $1  ]] && local pmes=$1 || local pmes=0
    [[ -n $2 ]] && local mesp=$2 || local mesp=$(date '+%Y')
    cal -m -n $pmes -S $mesp 
}

covStats(){
    # Cache https
    [ "$(stat -c %y ~/.cache/corona 2>/dev/null | cut -d' ' -f1)" != "$(date '+%Y-%m-%d')" ] &&
    curl -s https://corona-stats.online?source=2 | \
    sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" > ~/.cache/corona

    # Estadisticas covid Chile
    declare Vars
    Vars="$(grep "Chile" ~/.cache/corona | 
    sed "s/\s*//g ; s/║//g ; s/│/;/g " |
    sed "s/(CL)//g" | awk -F';' '{print $3" "$7" "$5" "$8}')"
    Contag=$(cut -d' ' -f1 <<<${Vars})
    Recupe=$(cut -d' ' -f2 <<<${Vars})
    Muerte=$(cut -d' ' -f3 <<<${Vars})
    Activo=$(cut -d' ' -f4 <<<${Vars})
    Murtio="${Muerte//,/}"
    Conteg="${Contag//,/}"

    # Población Chile
    PoblT=19678310
    # Muertes
    Mtota="$(python3 -c "print('{:.2f}'.format(100*$Murtio/$PoblT))")"
    Mcont="$(python3 -c "print('{:.2f}'.format(100*$Murtio/$Conteg))")" 
    # Vista
    printf '\n %bEstadisticas COVID %bChile  🇨🇱️  %b\n' "${GRN}" "${BLU}" "${RST}"
    printf '%b%s%b\n' "${MGNT}" " ============================" "${RST}"
    printf '  %bMuertes totales :%b %s %b\n' "${RED}" "${CYA}" "$Mtota" "${RST}"
    printf '  %bMuertes contagio:%b %s %b\n' "${REd}" "${CYa}"  "$Mcont" "${RST}"
    printf '%b%s%b\n' "${MGNT}" " ----------------------------" "${RST}"
    printf '  %bContagios   : %b%s%b\n' "${GRn}" "${CYa}" "${Contag}" "${RST}"
    printf '  %bActivos     : %b%s%b\n' "${GRn}" "${CYa}" "${Activo}" "${RST}"
    printf '  %bRecuperados : %b%s%b\n' "${GRn}" "${CYa}" "${Recupe}" "${RST}"
    printf '  %bMuertes     : %b%s%b\n' "${RED}" "${CYA}" "${Muerte}" "${RST}"
    printf '%b%s%b\n' "${MGNT}" " ----------------------------" "${RST}"
}

mpvPlaylist(){
    ayuda(){
        while read; do
            printf '%s\n' "${REPLY}"
        done <<-EOF
    Uso:
      ./script mpvPlaylist                  Ejecuta el script.
      ./script mpvPlaylist <link>           Agrega el link a playlist.
      ./script mpvPlaylist -r, --play       Reproduce playlist.
      ./script mpvPlaylist -s, --off        Reproduce playlist y apaga el equipo.
      ./script mpvPlaylist -h, --help       Muestra el contenido de ayuda.
EOF
    exit 0
    }
    playlist=$HOME/.cache/.playlist
    touch $playlist
    valid='(https)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    case ${1} in
        -h|--help)
            ayuda ;;
        -r|--play)
            printf '\n%bReproduciendo Playlist%b\n' "${GRN}" "${RST}"
            mpv --playlist=$playlist --no-terminal & exit 0 ;;
        -s|--off)
            printf '\n%bEl equipo se apagará al finalizar la reproducción...%b\n' \
            "${ORn}" "${RST}"
            mpv --playlist=$playlist --no-terminal && shutdown 0 ;;
        *)
            if [[ -n ${1} ]]; then
                [[ ${1} =~ $valid ]] && printf '%s\n' "${1}" >> $playlist ||
                printf '%b   Link inválido!%b\n' "${REd}" "${RST}"
                exit 0
            fi ;;
    esac
    clear
    while :; do
        printf '\n  %bPlaylist Manager\n' "${GRN}"
        printf '  %s%b\n\n' "----------------" "${RST}"
        printf '  %b1) %bVer Lista%b\n' "${BLU}" "${GRn}" "${RST}"
        printf '  %b2) %bAñadir link(s)%b\n' "${BLU}" "${GRn}" "${RST}"
        printf '  %b3) %bReproducir lista%b\n' "${BLU}" "${GRn}" "${RST}"
        printf '  %b4) %bReproducir y Apagar PC%b\n' "${BLU}" "${GRn}" "${RST}"
        printf '  %b5) %bBorrar lista%b\n' "${BLU}" "${GRn}" "${RST}"
        printf '  %b6) %bEditar%b\n' "${BLU}" "${GRn}" "${RST}"
        printf '  %bs) %bSalir%b\n\n' "${BLU}" "${GRn}" "${RST}"
        printf ' %bElige una opción :%b' "${GRN}" "${RST}"
        read -p ' ' 
        case ${REPLY} in
            1)  
                clear
                bat --style grid,numbers ~/.cache/.playlist 2>/dev/null ;;
            2)  
                clear
                printf '%bAñadir link %b(v para volver)%b\n' \
                "${GRN}" "${GRn}" "${RST}"
                while :; do
                    printf '%bLink ->%b' "${BLU}" "${RST}"
                    read -p ' ' LinK
                     case ${LinK} in
                        s) 
                            exit 0 ;;
                        v) 
                            mpvPlaylist ;;
                        *) 
                            [[ ${LinK} =~ ${valid} ]] && printf '%s\n' "${LinK}" >> $playlist ||
                            printf '%b   Link inválido!%b\n' "${REd}" "${RST}" ;;
                    esac
                done ;;
            3)  
                printf '\n%bReproduciendo Playlist%b\n' "${GRN}" "${RST}"
                mpv --playlist=$playlist --no-terminal & exit 0 ;;
            4)  
                printf '\n%bEl equipo se apagará al finalizar la reproducción...%b\n' \
                "${ORn}" "${RST}"
                mpv --playlist=$playlist --no-terminal && shutdown 0 ;;
            5)  
                printf '' > $playlist && clear ;;
            6)  
                clear; nvim $playlist ;;
            s|0)  
                exit 0 ;;
            *)  
                printf '%b   Opción inválida!%b\n' "${REd}" "${RST}"
                sleep 1.5 && clear ;;
        esac
    done
}

"$@"
