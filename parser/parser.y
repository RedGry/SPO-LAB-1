%{
#include "parser.tab.h"
#include "error/error.h"

#define YYDEBUG 1
%}

%error-verbose
%union {
    ASTNode* node;
}

%token <node> PLUS MINUS TIMES DIVIDE PERCENT EQUAL NOT_EQ
%token <node> LT GT LTE GTE
%token <node> AND OR NOT
%token <node> IDENTIFIER
%token <node> STR
%token <node> COMMA
%token <node> CHAR
%token <node> BIN HEX INT
%token <node> TRUE FALSE
%token <node> IF ELSE WHILE DO BREAK
%token <node> SEMICOLON
%token <node> LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET
%token <node> TYPEDEF
%token <node> ARRAY_COMMAS

%type <node> expr
%type <node> typeRef

%type <node> funcSignature
%type <node> argDef
%type <node> sourceItem
%type <node> statement
%type <node> var
%type <node> if
%type <node> block
%type <node> while
%type <node> do
%type <node> break
%type <node> expression
%type <node> builtin
%type <node> custom
%type <node> array
%type <node> source
%type <node> listArgDef
%type <node> optionalTypeRef
%type <node> literal
%type <node> place
%type <node> indexer
%type <node> listExpr
%type <node> optionalListExpr
%type <node> call
%type <node> braces
%type <node> unary
%type <node> binary
%type <node> assignment
%type <node> listVarDeclared
%type <node> optionalElseStatement
%type <node> listStatement
%type <node> listVarDeclaredItem

%%
source: {{$$ = NULL;}}
    | source sourceItem {{$$ = createNode("source", $1, $2, "");}};

sourceItem:
      funcSignature block {{$$ = createNode("sourceItem", $1, $2, "");}}
    | funcSignature SEMICOLON {{$$ = createNode("sourceItem", $1, NULL, "");}};

funcSignature:
    argDef LPAREN listArgDef RPAREN {{$$ = createNode("funcSignature", $1, $3, "");}};

listArgDef: {{$$ = NULL;}}
    | argDef {{$$ = $1;}}
    | argDef COMMA listArgDef {{$$ = createNode("listArgDef", $1, $3, "");}};

argDef:
    optionalTypeRef IDENTIFIER {{$$ = createNode("argDef", $1, $2, "");}};

optionalTypeRef: {{ $$ = NULL; }}
    | typeRef {{$$ = $1;}};


typeRef:
      builtin   {{$$ = $1;}}
    | custom    {{$$ = $1;}}
    | array     {{$$ = $1;}};

builtin:
    TYPEDEF {{$$ = $1;}};

statement:
      var           {{$$ =  $1;}}
    | if            {{$$ =  $1;}}
    | block         {{$$ =  $1;}}
    | while         {{$$ =  $1;}}
    | do            {{$$ =  $1;}}
    | break         {{$$ =  $1;}}
    | expression    {{$$ =  $1;}};

custom:
    IDENTIFIER {{$$ = $1;}};

array:
    typeRef ARRAY_COMMAS {{$$ = createNode("array", $1, NULL, $2->value);}};

listVarDeclared:
      listVarDeclaredItem COMMA listVarDeclared {{$$ = createNode("listVarDeclared", $1, $3, "");}}
    | listVarDeclaredItem {{$$ = createNode("listVarDeclared", $1, NULL, "");}};

listVarDeclaredItem:
      IDENTIFIER {{$$ = $1;}}
    | assignment {{$$ = $1;}};

var:
    typeRef listVarDeclared SEMICOLON {{$$ = createNode("var", $1, $2, "");}};

if:
    IF LPAREN expr RPAREN statement optionalElseStatement {{$$ = createNode("if", $3, createNode("ifStatement", $5, $6, ""), "");}};

optionalElseStatement:
      ELSE statement optionalElseStatement {{$$ = createNode("else", $2, $3, "");}}
    | ELSE statement {{$$ = createNode("else", $2, NULL, "");}}
    | {{$$ = NULL;}};

listStatement:
    statement listStatement {{$$ = createNode("listStatement", $1, $2, "");}}
    | {{$$ = NULL;}};

block:
      LBRACE listStatement RBRACE   {{$$ = createNode("block", $2, NULL, "");}}
    | LBRACE RBRACE                 {{$$ = createNode("block", NULL, NULL, "");}};

while:
    WHILE LPAREN expr RPAREN statement {{$$ = createNode("while", $3, $5, "");}};

do:
    DO block WHILE LPAREN expr RPAREN SEMICOLON {{$$ = createNode("dowhile", $2, $5, "");}};

break:
    BREAK SEMICOLON {{$$ = createNode("break", NULL, NULL, "");}};

expression:
    expr SEMICOLON {{$$ = $1;}};

assignment:
    expr EQUAL expr {{$$ = createNode("assigment", $1, $3, "");}};

expr:
      unary    {{$$ = $1;}}
    | binary   {{$$ = $1;}}
    | braces   {{$$ = $1;}}
    | call     {{$$ = $1;}}
    | indexer  {{$$ = $1;}}
    | place    {{$$ = $1;}}
    | literal  {{$$ = $1;}};

binary: assignment
    | expr PLUS         expr {{$$ = createNode("PLUS",          $1, $3, "");}}
    | expr MINUS        expr {{$$ = createNode("MINUS",         $1, $3, "");}}
    | expr TIMES        expr {{$$ = createNode("TIMES",         $1, $3, "");}}
    | expr DIVIDE       expr {{$$ = createNode("DIVIDE",        $1, $3, "");}}
    | expr PERCENT      expr {{$$ = createNode("PERCENT",       $1, $3, "");}}
    | expr EQUAL EQUAL  expr {{$$ = createNode("EQUAL",         $1, $4, "");}}
    | expr NOT_EQ       expr {{$$ = createNode("NOT_EQUAL",     $1, $3, "");}}
    | expr LT           expr {{$$ = createNode("LESS",          $1, $3, "");}}
    | expr GT           expr {{$$ = createNode("GREATER",       $1, $3, "");}}
    | expr LTE          expr {{$$ = createNode("LESS_EQ",       $1, $3, "");}}
    | expr GTE          expr {{$$ = createNode("GREATER_EQ",    $1, $3, "");}}
    | expr AND          expr {{$$ = createNode("AND",           $1, $3, "");}}
    | expr OR           expr {{$$ = createNode("OR",            $1, $3, "");}};

unary:
      PLUS  expr {{$$ = createNode("PLUS",  $2, NULL, "");}}
    | MINUS expr {{$$ = createNode("MINUS", $2, NULL, "");}}
    | NOT   expr {{$$ = createNode("NOT",   $2, NULL, "");}};

braces:
    LPAREN expr RPAREN  {{$$ = createNode("braces", $2, NULL, "");}};

call:
    IDENTIFIER LPAREN optionalListExpr RPAREN  {{$$ = createNode("CALL", $1, $3, "");}};

optionalListExpr:
    listExpr    {{$$ = createNode("optionalListExpr", $1, NULL, "");}}
    |           {{$$ = createNode("optionalListExpr", NULL, NULL, "");}};

listExpr:
      expr COMMA listExpr {{$$ = createNode("listExpr", $1, $3, "");}}
    | expr {{$$ = createNode("listExpr", $1, NULL, "");}};

indexer:
    expr LBRACKET listExpr RBRACKET {{$$ = createNode("indexer", $1, $3, "");}};

place:
    IDENTIFIER {{$$ = $1;}};

literal:
      TRUE  {{$$ = $1;}}
    | FALSE {{$$ = $1;}}
    | STR   {{$$ = $1;}}
    | CHAR  {{$$ = $1;}}
    | HEX   {{$$ = $1;}}
    | BIN   {{$$ = $1;}}
    | INT   {{$$ = $1;}};
%%