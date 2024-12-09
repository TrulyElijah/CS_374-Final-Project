all: main

bool.tab.c bool.tab.h:        bool.y
		bison -t -v -d bool.y

lex.yy.c: bool.l 
	flex bool.l

main: lex.yy.c bool.tab.c bool.tab.h
		gcc -g -o main bool.tab.c lex.yy.c

clean:
		rm main bool bool.exe bool.exe.stackdump bool.tab.c lex.yy.c bool.tab.h bool.output