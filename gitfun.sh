#!/usr/bin/env bash

# Script para iniciar y configurar repositorios Git

REd="\e[31m";    GRn="\e[32m";    ORn="\e[33m";
FND="\e[40m";    RED="\e[1;31m";  GRN="\e[1;32m";
MGNT="\e[1;35m"; IND="\e[1;34m";  RST="\e[0m";

iniciarepo() {
    printf '\n%b %b(￣▽￣)ノ%b Iniciando ' "${FND}" "${MGNT}" "${GRN}"
    printf 'repositorio de %b%s%b\n\n' "${IND}" "${1}" "${RST}"
    git init && 
    git config --local user.name "$1" &&
    git config --local user.email "$2" &&
    git config --local core.sshCommand "ssh -i ~/.ssh/keys/${3} -F /dev/null"
}


gitUser(){
    if [ -e $HOME/.config/.gitidents ]; then
        GitIdents=$HOME/.config/.gitidents
    else
        printf '%bArchivo no encontrado!: %b%s~/.config/.gitidents ' \
               "${RED}" "${RST}${GRn}" "${HOME}" && exit 0
    fi
    case "$1" in
        m|manual)
            manualGit ;;
        *)
            while read LINE; do 
                [[ $(printf '%s\n' "${LINE}" | cut -d' ' -f1) = ${1}  ]] && 
                    identidad=($LINE) &&
                    iniciarepo "${identidad[0]}" "${identidad[1]}" "${identidad[2]}" &&
                    exit 0;
            done < $GitIdents
            printf  '\n   %bDebes ingresar un usuario válido!\n\n' "${RED}"
            printf  '   %b%bIdentidades en %b~/.config/.gitidents %b:' \
                    "${RST}" "${GRn}" "${RST}" "${GRn}"
            for LINE in $(cut -d' ' -f1 $GitIdents); do
                printf '\n\t%b-> %b%s' "${IND}"  "${GRN}" "${LINE}"
            done
            printf  '\n\t%bm) %bmanual\n' "${IND}"  "${GRN}"
            printf  '\n\t%b╮(︶▽︶)╭ %b\n' "${MGNT}" "${RST}"
        ;;
    esac
}


manualGit(){
    #local salir=0
    while :; do
        printf '%bNombre :%b ' "${GRN}" "${RST}"
        read -p '' nombre
        printf '%bCorreo :%b ' "${GRN}" "${RST}"
        read -p '' email
        printf '%bSSH key:%b ' "${GRN}" "${RST}"
        read -p '' sshkey
        printf '\nUsuario: %b%s  %b' "${GRN}" "${nombre}" "${RST}" 
        printf 'Correo: %b%s%b  ' "${GRN}" "${email}" "${RST}"
        printf 'Llave: %b%s%b\n' "${GRN}" "${sshkey}" "${RST}"
        printf '%bIniciar repo con estos datos? %b(s/n/q)%b:%b' \
               "${GRn}" "${IND}" "${GRn}" "${RST}"
        read -p' ' confirma
        case "${confirma}" in
            s|S) iniciarepo "${nombre}" "${email}" "${sshkey}" && exit 0 ;;
            q|Q) exit 0 ;;
        esac
    done
}


# Invoca 'touch README.md' en los directorios a un sub-nivel del actual
# ej. nombres de directorios:  'mi_dir/' 'mi dir con espacios/'
crea_readmes() {
    for CARP in */
        do
        if [ -d "${CARP}" ]; then
            if [ -f "${CARP}"README.md ]; then 
                printf '%b omitiendo %s %b\n' "${ORn}" "${CARP}" "${RST}"
            else
                touch "${CARP}"README.md &&
                printf '%b%sREADME.md creado%b\n' "${GRn}" "${CARP}" "${RST}"
            fi
        else
            print '%s %bno es un directorio válido%b\n' "${CARP}" "${REd}" "${RST}"
        fi
    done
}

"$@"
