%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yyerror (const char * msg);

%}

/* For error messages */
%error-verbose

%token '.'
%token ':'
%token ';'
%token '!'
%token '?'
%token ')'
%token '('
%token '&'

%token TK_LEFT_ARROW "<-"
%token TK_TRUE "true"
%token TK_NOT "not"

%token TK_VAR
%token TK_NUM
%token TK_ATOM

%left '+' '-' ','

%%

Agent : Beliefs Plans ;

Beliefs : | Belief Beliefs ;

Belief : Predicate '.' | error '.';

Predicate : TK_ATOM '(' Terms ')' ;

Plans : | Plan Plans ;

Plan : TriggeringEvent ':' Context "<-" Body '.' ;

TriggeringEvent : Op Word ;

Op : '+' | '-' ;

Word : Predicate | Goal ;

Context : "true" | Cliterals ;

Cliterals : Literal ExtraCliterals ;

ExtraCliterals : | '&' Cliterals ;

Literal : Predicate | "not" '(' Predicate ')' ;

Goal : Mark Predicate ;

Mark : '!' | '?' ;

Body : "true" | Actions ;

Actions : Action ExtraActions ;

ExtraActions : | ';' Actions ;

Action : Predicate | BeliefUpdate | Goal ;

BeliefUpdate : Op Predicate ;

Terms : Term ExtraTerms ;

ExtraTerms : | ',' Terms ;

Term : TK_VAR | TK_NUM | TK_ATOM ExtraTerm ;

ExtraTerm : | '(' Terms ')' ;

%%

#include "agentSpeak.lex.c"

int success = 1;
int yyerror (const char * msg)
{
    fprintf(stderr, "Error (line %d): %s.\n", line, msg);
    success = 0;

}

/* This is the lexer file.*/
int main(int argc, char **argv ){

   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
      yyin = stdin;

   int result = yyparse();

   if(success == 1){
       printf("Syntax OK!\n");
       return 0;
   } else {
       printf("There were %d errors in code. Failure!\n",yynerrs);
   }
}
