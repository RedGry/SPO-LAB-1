#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include "parser.tab.h"
#include "ast/ast.h"
#include <locale.h>

extern int yyparse();

extern FILE *yyin;

extern ASTNode **allNodes;
extern u_int64_t allNodesCount;

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "ru_RU.UTF-8");

    allNodes = malloc(1024 * 8 * sizeof(ASTNode *));
    allNodesCount = 0;

    if (!allNodes) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    if (argc > 1) {
        FILE *input_file = fopen(argv[1], "r");
        if (input_file) {
            yyin = input_file;
            yyparse();
            fclose(input_file);
            printAST();
        } else {
            printf("The file couldn't be opened: %s\n", argv[1]);
        }
    } else {
        printf("Execute: %s <input_file>\n", argv[0]);
    }

    free(allNodes);
    return 0;
}