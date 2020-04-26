%{
#include <stdio.h>
#include <string.h>

/* Defines of tokens */
#define TK_NAME 300
#define TK_TO 301
#define TK_TO_REPORT 302
#define TK_REPORT 303
#define TK_LEFT_BRACKET 304
#define TK_RIGHT_BRACKET 305
#define TK_IF 306
#define TK_VAR 307
#define TK_NUM 308
#define TK_END 309
#define TK_EQUAL 310

/* Needed for syntax analyser */
#define LEXEND 0

int line = 1;
%}

name [a-z]+
var \?[a-zA-Z]+
num [1-9][0-9]*

/* New line for *nix and Windows*/
newline \n|\x0A|\x0D\x0A

%%

"to-report" {return TK_TO_REPORT;} /* Have to go first */
"to" {return TK_TO;}
"report" {return TK_REPORT;}
"[" {return TK_LEFT_BRACKET;}
"]" {return TK_RIGHT_BRACKET;}
"if" {return TK_IF;}
"=" {return TK_EQUAL;}
"end" {return TK_END;}

{name} {return TK_NAME;}
{var} {return TK_VAR;}
{num} {return TK_NUM;}

. {/* Do Nothing */} /* Ή κάποιο μήνυμα σφάλματος*/
{newline} {/* Do nothing */} /* Ή αύξηση του αριθμού γραμμής*/

%%

int token = 0;
void error_syntax(const char* message);
void match(int tk);

/* This will be the top level function of your parser (start symbol)*/
void PDefinitions();

/* Rest of functions */
void PDef();
void Extra1();
void ProcFunN();
void Extra2();
void Vars();
void Varss();
void Body();
void Extra3();
void Call();
void Extra4();
void Args();
void Argss();

void Argss(){
    if(token == TK_VAR){
        match(TK_VAR);
        Argss();
    } else if (token == TK_NUM){
        match(TK_NUM);
        Argss();
    } else if(
        token != TK_LEFT_BRACKET &&
        token != TK_END &&
        token != TK_RIGHT_BRACKET) {
        error_syntax("Extra4 failed");
    }
}

void Args(){
    if(token == TK_VAR){
        match(TK_VAR);
        Argss();
    } else if (token == TK_NUM){
        match(TK_NUM);
        Argss();
    } else {
        error_syntax("Extra3 failed");
    }
}

void Extra4(){
    if(token == TK_VAR || token == TK_NUM){
        Args();
    } else if(
        token != TK_LEFT_BRACKET &&
        token != TK_END &&
        token != TK_RIGHT_BRACKET) {
        error_syntax("Extra4 failed");
    }
}

void Call(){
    if(token == TK_NAME){
        match(TK_NAME);
        Extra4();
    } else {
        error_syntax("Extra3 failed");
    }
}

void Extra3(){
    if(token == TK_VAR){
        match(TK_VAR);
    } else if (token == TK_NUM){
        match(TK_NUM);
    } else {
        error_syntax("Extra3 failed");
    }
}

void Body(){
    if(token == TK_IF){
        match(TK_IF);
        Call();
        match(TK_LEFT_BRACKET);
        Body();
        match(TK_RIGHT_BRACKET);
    } else if (token == TK_REPORT){
        match(TK_REPORT);
        Extra3();
    } else if(token == TK_NAME){
        Call();
    } else if(token == TK_VAR){
        match(TK_VAR);
        match(TK_EQUAL);
        match(TK_NUM);
    } else {
        error_syntax("Body failed");
    }

}

void Varss(){
    if(token == TK_VAR){
        match(TK_VAR);
        Varss();
    } else if (token != TK_RIGHT_BRACKET){
        error_syntax("Vars failed");
    }
}

void Vars(){
    if(token == TK_VAR){
        match(TK_VAR);
        Varss();
    } else {
        error_syntax("Vars failed");
    }
}

void Extra2(){
    if(token == TK_LEFT_BRACKET){
         match(TK_LEFT_BRACKET);
         Vars();
         match(TK_RIGHT_BRACKET);
    } else if (
        token != TK_IF &&
        token != TK_REPORT &&
        token != TK_VAR &&
        token != TK_NAME){
        error_syntax("ProcFunN failed");
    }
}

void ProcFunN(){
    if(token == TK_NAME){
         match(TK_NAME);
         Extra2();
    } else {
         error_syntax("ProcFunN failed");
    }
}

void Extra1(){
    if(token == TK_TO){
         match(TK_TO);
    } else if(token == TK_TO_REPORT){
        match(TK_TO_REPORT);
    } else {
         error_syntax("Extra1 failed");
    }
}

void PDef(){
	 if(token == TK_TO || token == TK_TO_REPORT){
		  Extra1();
		  ProcFunN();
          Body();
          match(TK_END);
	 } else {
		  error_syntax("PDef failed");
	 }
}

void PDefinitions(){
	 if(token == TK_TO || token == TK_TO_REPORT){
		  PDef();
		  PDefinitions();
	 } else if(token != LEXEND){
		  error_syntax("PDefinitions failed");
	 }
}

void error_syntax(const char * message){
	printf("Parsing Rule %s. Syntax Error reading %s at line %d of input. \n", message, yytext, line);
	exit(-1);
}

/* Match next token */
void match(int tk){
	if (token == tk) token = yylex();
	else  error_syntax("Match Failed");
}

int main(int argc, char **argv ){
	 ++argv, --argc;  /* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

	token = yylex();
	PDefinitions();
	if (token == LEXEND) printf("\n Success! \n \n");
	else error_syntax("Parse not Complete.");
	return 0;
}
