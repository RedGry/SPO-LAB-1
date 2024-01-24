# СПО - Лабораторная работа №1
## Задание
> Использовать средство синтаксического анализа по выбору, реализовать модуль для разбора текста в соответствии с языком по варианту. Реализовать построение по исходному файлу с текстом синтаксического дерева с узлами, соответствующими элементам синтаксической модели языка. Вывести полученное дерево в файл в формате, поддерживающем просмотр графического представления.

## Вариант
Грамматика находится в файле [model](./model)  
Отчет находится в [reports](./reports/Лабораторная%20работа%201%20-%20СПО.pdf)

## Необходимые пакеты
+ bison 3.8.2
+ flex 2.6.4
+ perl 5
+ graph-easy + module graph-easy as SVG
+ gcc, g++, gdb

## Запуск проекта на Clion (windows / linux):
1. Настроить себе Clion, чтобы можно было выполнять **Makefile**. Советую использовать Cygwin для винды. Как это сделать: [ссылка](https://www.jetbrains.com/help/clion/quick-tutorial-on-configuring-clion-on-windows.html#Cygwin)
2. Установить себе все необходимые пакеты.
3. Запустить команду `make all`.
4. Посмотреть результат в созданной директории **out**.