//
// Created by trott on 19.01.2024.
//

#ifndef LAB_1_AST_H
#define LAB_1_AST_H

typedef struct ASTNode ASTNode;

struct ASTNode {
    char *type;
    ASTNode *left;
    ASTNode *right;
    char *value;
    int id;
};

void printAST();

ASTNode *createNode(char *type, ASTNode *left, ASTNode *right, char *value);

#endif //LAB_1_AST_H
