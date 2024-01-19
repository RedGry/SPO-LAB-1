#include "error.h"
#include <stdio.h>

void yyerror(const char* s){
    fprintf(stderr, "Error: %s\n", s);
}