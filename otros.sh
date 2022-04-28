#!/usr/bin/env bash

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
    lolcat <<< $(
    # Cache https
    [ "$(stat -c %y ~/.cache/corona 2>/dev/null | cut -d' ' -f1)" != "$(date '+%Y-%m-%d')" ] &&
    curl -s https://corona-stats.online?source=2 | \
    sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" > ~/.cache/corona

    # Estadisticas covid Chile
    declare Vars
    Vars="$(grep "Chile" ~/.cache/corona | 
    sed "s/\s*//g ; s/║//g ; s/│/;/g " |
    sed "s/(CL)//g" | awk -F';' '{print $3" "$7" "$5" "$8}')"
    Contag=$(cut -d' ' -f1 <<< ${Vars})
    Recupe=$(cut -d' ' -f2 <<< ${Vars})
    Muerte=$(cut -d' ' -f3 <<< ${Vars})
    Activo=$(cut -d' ' -f4 <<< ${Vars})
    Murtio="${Muerte//,/}"
    Conteg="${Contag//,/}"
    
    # Población Chile
    PoblT=19678310
    
    # Muertes
    Mtota="$(python3 -c "print('{:.2f}'.format(100*$Murtio/$PoblT))")"
    Mcont="$(python3 -c "print('{:.2f}'.format(100*$Murtio/$Conteg))")"
    
    # Vista
    printf '\n Estadisticas COVID Chile  🇨🇱️ \n'
    printf ' ============================\n'
    printf '  Muertes totales :\e[1;36m %s %%\e[0m\n' "$Mtota"
    printf '  Muertes contagio:\e[1;32m %s %%\e[0m\n' "$Mcont"
    printf '%s\n' " ----------------------------"
    printf '  Contagios   : %s \n  Activos     : %s \n  Recuperados : %s \n  Muertes     :\e[1;32m %s \e[0m\n' \
    "${Contag}" "${Activo}" "${Recupe}" "${Muerte}"
    printf '%s\n\n' " ----------------------------"
    )
}

"$@"
