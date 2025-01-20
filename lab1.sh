#!/bin/bash

# Задание: объявляем переменную TASKID
TASKID=1

# Подсчитываем количество строк в dns-tunneling.log
VAR_1=$(wc -l < dns-tunneling.log)
export VAR_1

# Извлекаем и сортируем домены из dns-tunneling.log, берем только 15-й столбец (предположим, что домены там)
cut -f15 dns-tunneling.log | sort | uniq -c | sort -nr > domain_counts.txt

# Извлекаем доменные имена из top-1m.csv (вторую колонку с доменами), приводим их к нижнему регистру для корректного сравнения
cut -d',' -f2 top-1m.csv | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' > top_domains.txt

# Находим домены из dns-tunneling.log, которые есть в top-1m.csv, сортируем по частоте и лексикографически
grep -Ff top_domains.txt domain_counts.txt | sort -nr -k1,1 -k2,2 | head -15 > results.txt

# Отладка: выводим содержимое results.txt для проверки
echo "Содержимое results.txt:"
cat results.txt

# Извлекаем 4-й домен из results.txt, учитывая возможные пробелы и табуляции, и не удаляем точку в конце домена
FOURTH_DOMAIN=$(sed -n '4p' results.txt | awk '{print $2}' | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

# Отладка: выводим 4-й домен
echo "Четвертый домен из results.txt: '$FOURTH_DOMAIN'"

# Отладка: выводим содержимое top-1m.csv и проверяем, как выглядит первый и 4-й домен
echo "Первые строки из top-1m.csv для отладки:"
head -n 10 top-1m.csv

echo "Ищем домен в top-1m.csv: '$FOURTH_DOMAIN'"

# Ищем рейтинг для 4-го домена в top-1m.csv
VAR_2=$(grep -m 1 ",$FOURTH_DOMAIN" top-1m.csv | cut -d ',' -f 1)

# Отладка: выводим, что мы нашли в top-1m.csv
echo "Найдено в top-1m.csv: '$VAR_2'"

# Проверка, если VAR_2 пустое, значит домен не найден в top-1m.csv
if [ -z "$VAR_2" ]; then
    echo "Ошибка: не удалось найти домен '$FOURTH_DOMAIN' в top-1m.csv"
    exit 1
fi

# Экспортируем переменную VAR_2
export VAR_2

# Выводим количество строк в dns-tunneling.log и рейтинг 4-го домена
echo "Количество строк в dns-tunneling.log (VAR_1): $VAR_1"
echo "Рейтинговый номер 4-го домена (VAR_2): $VAR_2"
