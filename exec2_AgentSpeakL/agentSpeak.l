%{
#include <string.h>
#include <stdlib.h>

int line = 1;
%}

body [A-Za-z0-9_]
var [A-Z]{body}*
atom [a-z]{body}*
num ([1-9][0-9]*)|0(\.[0-9]+)?

/* New line for *nix and Windows*/
newline \n|\x0A|\x0D\x0A

%%
"." {return '.';}
"," {return ',';}
":" {return ':';}
";" {return ';';}
"!" {return '!';}
"?" {return '?';}
")" {return ')';}
"(" {return '(';}
"+" {return '+';}
"-" {return '-';}
"&" {return '&';}

"<-" {return TK_LEFT_ARROW;}
"true" {return TK_TRUE;}
"not" {return TK_NOT;}

{var} {return TK_VAR;}
{atom} {return TK_ATOM;}
{num} {return TK_NUM;}

. {/* Do Nothing */} /* Ή κάποιο μήνυμα σφάλματος*/
{newline} {line++;} /* Ή αύξηση του αριθμού γραμμής*/

 %%
