#!/bin/bash
# ===============================================
# Script: demo_sort.sh
# Demostración de ejemplos básicos del comando sort en Linux
# ===============================================

echo "1) Ordenar alfabéticamente:"
printf "pera\nmanzana\nuva\n" | sort
echo "--------------------------------"

echo "2) Orden inverso:"
printf "pera\nmanzana\nuva\n" | sort -r
echo "--------------------------------"

echo "3) Ignorar mayúsculas/minúsculas:"
printf "Zeta\nalfa\nBeta\n" | sort -f
echo "--------------------------------"

echo "4) Eliminar duplicados:"
printf "a\na\nb\nb\nc\n" | sort -u
echo "--------------------------------"

echo "5) Orden numérico:"
printf "10\n2\n33\n1\n" | sort -n
echo "--------------------------------"

echo "6) Orden 'humano' (K, M, G):"
printf "10K\n2M\n512K\n1G\n" | sort -h
echo "--------------------------------"

echo "7) Ordenar por columna 2 (edad):"
printf "ana;20\nluis;15\nmaria;22\n" | sort -t';' -k2,2n
echo "--------------------------------"

echo "8) Ordenar versiones:"
printf "1.9\n1.10\n1.2\n" | sort -V
echo "--------------------------------"

echo "9) Comprobar si un fichero está ordenado:"
printf "a\nb\nc\n" > datos.txt
sort -c datos.txt && echo "OK: datos.txt está ordenado"
echo "--------------------------------"

echo "10) Orden forzado por bytes (sin locale):"
printf "á\nb\n" | LC_ALL=C sort
echo "--------------------------------"

echo "Demostración completada ✅"