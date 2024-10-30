#!/bin/bash

TASKID=1
VAR_1=$(wc -l < dns-tunneling.log)

if [[ ! -f "$HOME/lab1/task1/top-1m.csv" ]]; then
  echo "Файл top-1m.csv не найден. Загрузите и распакуйте его перед запуском скрипта."
  exit 1
fi

# Извлекаем доменные имена из логов, подсчитываем их частоту
awk -F'\t' '{print $15}' dns-tunneling.log | sort | uniq -c | sort -nr > domain_counts.txt

# Сортируем файл top-1m.csv по доменам
sort -t, -k2,2 "$HOME/lab1/task1/top-1m.csv" > sorted_top_1m.csv

# Используем awk для объединения данных вместо join
awk -F'\t' '
    BEGIN {
        while (getline < "sorted_top_1m.csv") {
            domains[$2] = $1  # Сохраняем рейтинг домена
        }
    }
    FNR==NR { count[$2] = $1; next }  # Читаем из domain_counts.txt
    {
        if ($2 in domains) {
            print count[$2], $2, domains[$2]  # Выводим частоту, домен и рейтинг
        }
    }
' domain_counts.txt sorted_top_1m.csv | sort -k1,1nr -k2,2 | head -15 > results.txt

# Извлекаем рейтинговый номер четвертого домена
VAR_2=$(awk 'NR==4 {print $3}' results.txt)

echo "TASKID = $TASKID"
echo "VAR_1 = $VAR_1"
echo "VAR_2 = $VAR_2"
