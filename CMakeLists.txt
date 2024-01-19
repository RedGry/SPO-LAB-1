cmake_minimum_required(VERSION 3.27)
project(LAB_1 C)

set(CMAKE_C_STANDARD 11)

add_executable(LAB_1 main.c
        error/error.c
        error/error.h
        ast/ast.c
        ast/ast.h
)
