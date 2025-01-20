#!/bin/bash
source ./lab1.sh

# Проверка наличия файла results.txt
if [ ! -f results.txt ]; then
  echo "Ошибка: файл results.txt не найден!"
  exit 1
fi

# Проверка, что файл results.txt содержит хотя бы 1 строку
if [ ! -s results.txt ]; then
  echo "Ошибка: файл results.txt пуст!"
  exit 1
fi

# Проверка, что в файле results.txt есть хотя бы 15 строк
lines=$(wc -l < results.txt)
if [ "$lines" -lt 15 ]; then
  echo "Ошибка: в файле results.txt меньше 15 строк!"
  exit 1
fi

# Проверка корректности данных в переменной VAR_1
if [ -z "$VAR_1" ]; then
  echo "Ошибка: переменная VAR_1 не установлена!"
  exit 1
fi

# Проверка корректности данных в переменной VAR_2
if [ -z "$VAR_2" ]; then
  echo "Ошибка: переменная VAR_2 не установлена!"
  exit 1
fi

# Проверка корректности значений VAR_2 (например, оно должно быть числом)
if ! [[ "$VAR_2" =~ ^[0-9]+$ ]]; then
  echo "Ошибка: VAR_2 не является числом!"
  exit 1
fi

# Проверка, что VAR_2 соответствует одному из рейтинговых номеров
if ! grep -q "^$VAR_2," top-1m.csv; then
  echo "Ошибка: VAR_2 не найден в рейтинговом списке!"
  exit 1
fi

# Если все проверки пройдены успешно
echo "Тесты пройдены успешно!"
