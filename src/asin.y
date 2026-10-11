/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          jbenedi@dsic.upv.es>     V. 24  **/
/*****************************************************************************/
%{
#include "header.h"
%}

%token PARA_ PARC_ MAS_ MENOS_ POR_ DIV_
%token CTE_ 

%token ASIG_ NOT_ IGUAL_ DESIGUAL_ AND_ OR_
%token MAYOR_ MENOR_ MAYOR_IGUAL_ MENOR_IGUAL_
%token AP_ CP_ AC_ CC_ AL_ CL_ PCOMA_ COMA_
%token TRUE_ FALSE_ INT_ BOOL_ RETURN_ PRINT_
%token IF_ ELSE_ FOR_ SWITCH_
%token LESS_ EQUAL_ GREATER_ READ_ ID_

%%

expMat : exp
       ;
exp    : exp MAS_   term
       | exp MENOS_ term
       | term         
       ;
term   : term POR_ fac
       | term DIV_ fac   
       | fac             
       ;
fac    : PARA_ exp PARC_ 
       | CTE_            
       ;
%%
