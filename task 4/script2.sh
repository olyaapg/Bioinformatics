#!/bin/bash

# Извлекаем процентное значение.
VAR=$(grep "+ 0 mapped" flagstat | grep -oP '\d+\.\d+')

# Проверка, больше ли значение 90.
if (( $(echo "$VAR > 90" | bc -l) )); then
    echo "OK!"
else
    echo "not OK..."
fi
