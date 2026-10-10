/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          <jbenedi@dsic.upv.es>   V.24    **/
/*****************************************************************************/
%{
#include "header.h"
#include "asin.h"

#define  retornar(x) {if (verbosidad) ECHO ; return (x) ; }
%}
/*----------------------------------------------------------------------
  Dado que las funciones "input()" y "unput(c)" son costosas y no las
  utilizaremos, evitaremos que se generen automaticamente sus rutinas
  correspondientes desactivandolas mediante las siguientes opciones:
----------------------------------------------------------------------*/
%option noinput
%option nounput
/*----------------------------------------------------------------------
  Para mantener el numero de linea actual en la variable global yylineno
----------------------------------------------------------------------*/
%option yylineno

delimitador     [ \t\n]+
digito          [0-9]
entero          {digito}+
letra           [a-zA-Z]
comentario      "//"[^\n]*
identificador   {letra}({letra}|{digito}|-)*
real            ({digito}+"."{digito}*|{digito}*","{digito}+)
numero          ({entero}|{real})     

%%

{delimitador}   {if (verbosidad) ECHO ; }
"+"             { retornar (MAS_) ;}
"-"             { retornar (MENOS_) ; }
"*"             { retornar (POR_) ; }
"/"             { retornar (DIV_) ; }
"="             { retornar (ASIG_) ; }
"!"             { retornar (NOT_) ; }
"=="            { retornar (IGUAL_) ; }
"!="            { retornar (DESIGUAL_) ; }
"&&"            { retornar (AND_) ; }
"||"            { retornar (OR_) ; }
">"             { retornar (MAYOR_) ; }
"<"             { retornar (MENOR_) ; }
">="            { retornar (MAYOR_IGUAL_) ; }
"<="            { retornar (MENOR_IGUAL_) ; }
"("             { retornar (AP_) ; }
")"             { retornar (CP_) ; }
"["             { retornar (AC_) ; }
"]"             { retornar (CC_) ; }
"{"             { retornar (AL_) ; }
"}"             { retornar (CL_) ; }
";"             { retornar (PCOMA_) ; }
","             { retornar (COMA_) ; }
"true"          { retornar (TRUE_) ;}
"false"         { retornar (FALSE_) ;}
"int"           { retornar (INT_) ; }
"bool"          { retornar (BOOL_) ;}
"return"        { retornar (RETURN_) ; }
"print"         { retornar (PRINT_) ; } 
"if"            { retornar (IF_) ; }
"else"          { retornar (ELSE_) ; }
"for"           { retornar (FOR_) ; }
"switch"        { retornar (SWITCH_) ; }
"less"          { retornar (LESS_) ; }
"equal"         { retornar (EQUAL_) ; }
"greater"       { retornar (GREATER_) ; }
"read"          { retornar (READ_) ; }
{numero}        { retornar (CTE_) ; }
{comentario}    { if (verbosidad) ECHO ; }
{identificador}   {retornar (ID_) ;}
.				{ yyerror("Caracter desconocido") ;}
%%
