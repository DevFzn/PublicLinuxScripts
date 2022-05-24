#!/usr/bin/env bash

WAVCACHE=$HOME/.cache
Progrm=metronomo
VersionStr='21-05-2022'

REd="\e[0;31m";  GRn="\e[0;32m";  BLu="\e[0;34m"; ORn="\e[33m";
RED="\e[1;31m";  GRN="\e[1;32m";  BLU="\e[1;34m"; CYA="\e[1;36m";
MGt="\e[0;35m";  MGT="\e[1;35m";  RST="\e[0m";

# frecs para tonos
# 790 - 720 - 640 - 320 - 260
# ej. SUBDIV=(0 1 1 0 0 0 1 0 1 1 0 0 0 1 0 1)
declare SUBDIV=(1 0 0 0)
WAV0=790
WAV1=640
BPM=80
SUB=0

Err(){
    printf '%bERROR: %b%s%b\n' "${RED}" "${MGT}" "$2" "${RST}" 1>&2
    [ $1 -gt 0 ] && exit $1
}

Uso(){
    while read; do
        printf '%s\n' "$REPLY"
    done <<-EOF
        Uso: $Progrm [OPCS]
        
        metro -b 80 -c '1 0 0 0'
        metro --frecs '$WAV1 $WAV0'

          -b, --bpm <BPM>               - Golpes por minuto.
          -c, --compas <COMPAS>         - Entre comillas, '1 0 0 1 0', separados por espacios.
          -s, --sub                     - Activa sonido de las subdivisiones.
          -f, --frecs <FREQs>           - Cambia la frecuencia de sonidos del metronomo (0 y 1).
          -v, --version                 - Muestra la fecha de la versión.
          -h, --help                    - Muestra información de ayuda.

        Sonidos metronomo:

          - '${WAVCACHE}/metro0.wav'.
          - '${WAVCACHE}/metro1.wav'.
EOF
}

crea_wavs(){
    if [ ! -f ${WAVCACHE}/metro1.wav ]; then
        ffmpeg -f lavfi -i "sine=frequency=${WAV1}:duration=0.05" -ac 2 ${WAVCACHE}/metro1.wav &>/dev/null
        ffmpeg -f lavfi -i "sine=frequency=${WAV0}:duration=0.05" -ac 2 ${WAVCACHE}/metro0.wav &>/dev/null
    fi
}

set_bmp(){
    if [ ! -z "${1}" ]; then
        if [[ ! -n ${1//[0-9]/}  ]] && [[ "${1}" -lt 501  ]] && [[ "${1}" -gt 0 ]]; then
            BPM="${1}"
        else
            Err 1 "Debes ingresar un numero entre 1 y 500."
        fi
    else
        Err 1 "Debes ingresar un numero entre 1 y 500."
    fi
}

set_frec(){
    if [ ! -z "${1}" ]; then
        if [[ ! -n ${1//[0-9]/}  ]] && [[ "${1}" -lt 1001  ]] && [[ "${1}" -gt 199 ]]; then
            WAV0="${1}"
            rm -f ${WAVCACHE}/metro0.wav &>/dev/null
        else
            Err 1 "Debes ingresar un numero entre 200 y 1000."
        fi
    else
        Err 1 "Debes ingresar un numero entre 200 y 1000."
    fi
    if [ ! -z "${2}" ]; then
        if [[ ! -n ${2//[0-9]/}  ]] && [[ "${2}" -lt 1001  ]] && [[ "${2}" -gt 199 ]]; then
            WAV1="${2}"
            rm -f ${WAVCACHE}/metro1.wav &>/dev/null
        else
            Err 1 "Debes ingresar un número entre 200 y 1000."
        fi
    else
        Err 1 "Debes ingresar un número entre 200 y 1000."
    fi
    crea_wavs
}

metro(){
    crea_wavs
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--version)
                printf '%s\n' "$VersionStr"; exit 0 ;;
            -h|--help)
                Uso; exit 0 ;;
            -b|--bpm)
                set_bmp ${2} 
                shift
                shift
                ;;
            -c|--compas)
                SUBDIV=(${2})
                shift 
                shift 
                ;;
            -s|--sub)
                SUB=1
                shift; ;;
            -f|--frecs)
                declare FRECS
                FRECS=(${2})
                set_frec ${FRECS[0]} ${FRECS[1]}
                shift
                shift
                ;;
            -*|--*)
                Err 1 "Opción no válida."  ;;
            *)
                Err 1 'Argumento(s) inválido(s).'  ;;
        esac
    done
    div=${#SUBDIV[@]}
    bpm=$(echo "(60000/${BPM}/1000)" | bc -l)
    rit=$(echo "(${bpm}/${div})" | bc -l)
    printf '%bMetronomo a: %b%s bpm%b\n%b[Salir] %b<Ctrl>+<C>%b\n\n' \
           "${CYA}" "${GRN}" "${BPM}" "${RST}" "${REd}" "${BLU}" "${RST}"
    while :; do
        echo -en "${MGT} ${SUBDIV[@]}${RST}"
        printf "\r"
        for r in ${SUBDIV[@]} ;do 
            if [ $r -gt 0 ]; then
                aplay -q ${WAVCACHE}/metro1.wav & printf ' %b%s' "${GRN}" "${r}" & sleep ${rit}
            elif [[ $SUB -gt 0 ]]; then
                aplay -q ${WAVCACHE}/metro0.wav & printf ' %b%s' "${GRn}" "${r}" & sleep ${rit}
            else 
                printf ' %b%s' "${GRn}" "${r}" & sleep ${rit}
            fi
        done
        printf '\r'
    done
}

"$@"
