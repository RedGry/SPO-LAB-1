#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include "ast.h"

ASTNode **allNodes;
u_int64_t allNodesCount;

ASTNode *createNode(char *type, ASTNode *left, ASTNode *right, char *value) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->type = type;
    node->left = left;
    node->right = right;
    char *buf = malloc(1024 * sizeof(char));
    strcpy(buf, value);
    node->value = buf;
    allNodes[allNodesCount] = node;
    allNodesCount++;

    return node;
}

char *convertToString(char *type) {
    char *result = malloc(strlen(type) + 5);
    if (strcmp(type, "GREATER") == 0) {
        sprintf(result, "%s [ > ]", type);
    } else if (strcmp(type, "LESS") == 0) {
        sprintf(result, "%s [ < ]", type);
    } else if (strcmp(type, "GREATER_EQ") == 0) {
        sprintf(result, "%s [ >= ]", type);
    } else if (strcmp(type, "LESS_EQ") == 0) {
        sprintf(result, "%s [ <= ]", type);
    } else if (strcmp(type, "EQUAL") == 0) {
        sprintf(result, "%s [ == ]", type);
    } else if (strcmp(type, "NOT_EQUAL") == 0) {
        sprintf(result, "%s [ != ]", type);
    } else if (strcmp(type, "PLUS") == 0) {
        sprintf(result, "%s [ + ]", type);
    } else if (strcmp(type, "MINUS") == 0) {
        sprintf(result, "%s [ - ]", type);
    } else if (strcmp(type, "TIMES") == 0) {
        sprintf(result, "%s [ * ]", type);
    } else if (strcmp(type, "DIVIDE") == 0) {
        sprintf(result, "%s [ / ]", type);
    } else result = type;

    return result;
}

void printNodeId(ASTNode *node) {
    printf("\"ID: %d | Type: %s", node->id, convertToString(node->type));

    if (strlen(node->value) > 0) {
        printf(", Value: %s", node->value);
    }

    printf("\"");
}

void printNode(ASTNode *node) {
    if (node->left) {
        printNodeId(node);
        printf(" -> ");
        printNodeId(node->left);
        printf(";\n");
        printNode(node->left);
    }

    if (node->right) {
        printNodeId(node);
        printf(" -> ");
        printNodeId(node->right);
        printf(";\n");
        printNode(node->right);
    }
}

void printAST() {
    for (int i = 0; i < allNodesCount; ++i) {
        allNodes[i]->id = i;
    }

    printf("digraph G {\n");
    printNode(allNodes[allNodesCount - 1]);
    printNodeId(allNodes[allNodesCount - 1]);
    printf(" [shape=Mdiamond];\n");
    printf("}\n");
}