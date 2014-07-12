#!/bin/bash
if [ -z "$1" ]; then
    echo "ERROR: Tiene que introducir un parámetro: \"a\" para aumentar o \"d\" para disminuir"
    exit
else
    if [ "$1" != "a" ] && [ "$1" != "d" ]; then
        echo "ERROR: el parámetro de entrada sólo puede ser o \"a\" para aumentar el brillo o \"d\" para disminuirlo"
        exit
    fi
fi
MAX_BRILLO=`cat /sys/class/backlight/radeon_bl0/max_brightness`
MIN_BRILLO_ABSOLUTO="0"
MIN_BRILLO="10" #el brillo mínimo puede ser 0 pero eso deja la pantalla completamente a oscuras
INTERVALO=`expr $MAX_BRILLO - $MIN_BRILLO_ABSOLUTO`
INTERVALO=`expr $INTERVALO / 20`
brillo=`cat /sys/class/backlight/radeon_bl0/actual_brightness`
if [ "$1" = "a" ]; then
    let "brillo = brillo + INTERVALO"
    if [ "$brillo" -gt "$MAX_BRILLO" ]; then
    let "brillo = MAX_BRILLO"
    fi
else
    let "brillo = brillo - INTERVALO"
        if [ "$brillo" -lt "$MIN_BRILLO" ]; then
            let "brillo = MIN_BRILLO"
        fi
fi
echo "$brillo" | tee /sys/class/backlight/radeon_bl0/brightness
