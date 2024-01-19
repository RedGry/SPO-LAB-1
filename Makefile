BUILD_DIR = build
OUTPUT_DIR = out

OBJS = ast.o error.o main.o lex.yy.o parser.tab.o
OBJS_WITH_PATH = $(patsubst %,$(BUILD_DIR)/%,$(OBJS))

all: clean out build_lab result run

clean:
	rm -rf ${BUILD_DIR}
	rm -rf ${OUTPUT_DIR}
	rm -f *.tab.*
	rm -f lex.yy.c
	rm -f result.exe

out:
	mkdir ${BUILD_DIR}
	mkdir ${OUTPUT_DIR}

build_lab: ${BUILD_DIR}
	gcc -c -o ${BUILD_DIR}/error.o error/error.c
	gcc -c -o ${BUILD_DIR}/ast.o ast/ast.c
	flex parser/lexer.l
	bison -d -t parser/parser.y && echo '#include "ast/ast.h"' | cat - parser.tab.h > temp && mv temp parser.tab.h
	gcc -c -o ${BUILD_DIR}/main.o main.c
	gcc -c -o ${BUILD_DIR}/lex.yy.o lex.yy.c
	gcc -c -o ${BUILD_DIR}/parser.tab.o parser.tab.c
	gcc $(OBJS_WITH_PATH) -o result && chmod +x result

error.o: error/error.c
	gcc -c -o ${BUILD_DIR}/error.o error/error.c

lex.yy.c:
	flex parser/lexer.l

parser.tab.c: parser/parser.y
	bison -d -t parser/parser.y && echo '#include "ast/ast.h"' | cat - parser.tab.h > temp && mv temp parser.tab.h

ast.o: ast/ast.c
	gcc -c -o ${BUILD_DIR}/ast.o ast/ast.c

main.o: main.c out
	gcc -c -o ${BUILD_DIR}/main.o main.c

lex.yy.o: lex.yy.c
	gcc -c -o ${BUILD_DIR}/lex.yy.o lex.yy.c

parser.tab.o: parser.tab.c
	gcc -c -o ${BUILD_DIR}/parser.tab.o parser.tab.c

result: $(OBJS_WITH_PATH)
	gcc $(OBJS_WITH_PATH) -o result && chmod +x result

run: result.exe
	for i in 1 2 3 4; do \
            ./result tests/test$$i.txt | ~/perl5/bin/graph-easy -as svg > ${OUTPUT_DIR}/graph_$$i.svg; \
        done
	#./result tests/test2.txt | ~/perl5/bin/graph-easy -html > ${OUTPUT_DIR}/graph.html

