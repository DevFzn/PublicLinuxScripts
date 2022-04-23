#!/usr/bin/env bash

#########################################
#       Entornos Virtuales
#########################################
PyVirtEnvsDir=$HOME/Python/.virtualenvs/

creaPyVirtEnv(){ 
    [[ -n ${1} ]] && 
    python3 -m venv ${PyVirtEnvsDir}${1} &&
    printf '\nEntorno virtual python: [%s] Creado 🐍️\n' "${1}" ||
    printf '\nDebes ingresar un nombre 🙄️\n'
}

activaVenv(){
    printf 'source %s%s/bin/activate' "${PyVirtEnvsDir}" "${1}" | xclip
    printf '\n    Orden copiada en portapapeles:\n'
    printf '%s\n' "--------------------------------------------------------------------"
    printf 'source %s%s/bin/activate' "${PyVirtEnvsDir}" "${1}"
    printf '\n%s\n' "--------------------------------------------------------------------"
}

pyVirtEnvSel(){
    declare -a ListVenv
    local ConT
    printf "\n    Entornos Virtuales Python:\n\n"
    for VirtEnv in $(ls $PyVirtEnvsDir)
    do
        ListVenv[$ConT]="$VirtEnv"
        printf "\t%d) %s\n" "$ConT" "$VirtEnv"
        ((ConT++))
    done    
    printf '\n\tc) Crear\n'
    printf '\tq) Salir\n'
    printf '\n    Ingresa una opción.'
    read -p " -> "
    case $REPLY in
        c)  
            printf '\n    Crear nuevo entorno'
            printf '\n    Nombre del entorno'
            read -p " -> " NOMBRE_ENTORNO
            creaPyVirtEnv "${NOMBRE_ENTORNO}"
            ;;
        q)
            printf '    Salir\n'
            exit 0
            ;;
        [[:digit:]])
            if [ $REPLY -ge 0 ] && [ $REPLY -lt ${#ListVenv[@]} ]
            then
                activaVenv "${ListVenv[$REPLY]}"
            else
                printf '    Inexistente\n'
                exit 1
            fi
            ;;
        *)
            printf '    Entrada invalida\n'
            exit 1
            ;;
    esac
}


#########################################
#       OTRAS FUNCIONES
#########################################

_pip(){
    [[ $1 = "search" ]] && pip_search "$2" || pip "$@"
}

pyDebug(){
    if [ -s ${1} ]; then
        python -m pdb -c continue ${1}
    else
        printf 'Archivo [%s] invalido' "${1}"
    fi
}

pyMarkdown(){
    python -m rich.markdown -y -c -p ${1} | bat --style header,grid
}

pyMicroCalc(){
    python -c "print(${@})"
}

"$@"
