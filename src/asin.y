/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          jbenedi@dsic.upv.es>     V. 24  **/
/*****************************************************************************/
%{
#include "header.h"
%}

%token MAS_ MENOS_ POR_ DIV_
%token CTE_ 

%token ASIG_ NOT_ IGUAL_ DESIGUAL_ AND_ OR_
%token MAYOR_ MENOR_ MAYOR_IGUAL_ MENOR_IGUAL_
%token AP_ CP_ AC_ CC_ AL_ CL_ PCOMA_ COMA_
%token TRUE_ FALSE_ INT_ BOOL_ RETURN_ PRINT_
%token IF_ ELSE_ FOR_ SWITCH_
%token LESS_ EQUAL_ GREATER_ READ_ ID_

%%

programa : listDecla
         ;

listDecla : decla
          | listDecla decla
          ;

decla : declaVar
      | declaFunc
      ;

declaVar : tipoSimp ID_ PCOMA_
         | tipoSimp ID_ ASIG_ const PCOMA_
         | tipoSimp ID_ AC_ CTE_ CC_ PCOMA_
         ;

const : CTE_
      | TRUE_
      | FALSE_
      ;

tipoSimp : INT_
         | BOOL_
         ;

declaFunc : tipoSimp ID_ AP_ paramForm CP_ bloque
          ;

paramForm : /* vacío */
          | listParamForm
          ;

listParamForm : tipoSimp ID_
              | tipoSimp ID_ COMA_ listParamForm
              ;

bloque : AL_ declaVarLocal listInst RETURN_ expre PCOMA_ CL_
       ;

declaVarLocal : /* vacío */
              | declaVarLocal declaVar
              ;

listInst : /* vacío */
         | listInst inst
         ;

inst : AL_ listInst CL_
     | instExpre
     | instEntSal
     | instSelec
     | instIter
     | instSwitch
     ;

instSwitch : SWITCH_ ID_ AL_ Less Equal Greater CL_
           ;

Less : LESS_ inst
     ;

Equal : EQUAL_ inst
      ;

Greater : GREATER_ inst
        ;

instExpre : expre PCOMA_
          | PCOMA_
          ;

instEntSal : READ_ AP_ ID_ CP_ PCOMA_
           | PRINT_ AP_ expre CP_ PCOMA_
           ;

instSelec : IF_ AP_ expre CP_ inst ELSE_ inst
          ;

instIter : FOR_ AP_ expreOP PCOMA_ expre PCOMA_ expreOP CP_ inst
         ;

expreOP : /* vacío */
        | expre
        ;

expre : expreLogic
      | ID_ ASIG_ expre
      | ID_ AC_ expre CC_ ASIG_ expre
      ;

expreLogic : expreIgual
           | expreLogic opLogic expreIgual
           ;

expreIgual : expreRel
           | expreIgual opIgual expreRel
           ;

expreRel : expreAd
         | expreRel opRel expreAd
         ;

expreAd : expreMul
        | expreAd opAd expreMul
        ;

expreMul : expreUna
         | expreMul opMul expreUna
         ;

expreUna : expreSufi
         | opUna expreUna
         ;

expreSufi : const
          | AP_ expre CP_
          | ID_
          | ID_ AC_ expre CC_
          | ID_ AP_ paramAct CP_
          ;

paramAct : /* vacío */
         | listParamAct
         ;

listParamAct : expre
             | expre COMA_ listParamAct
             ;

opLogic : AND_
        | OR_
        ;

opIgual : IGUAL_
        | DESIGUAL_
        ;

opRel : MAYOR_
      | MENOR_
      | MAYOR_IGUAL_
      | MENOR_IGUAL_
      ;

opAd : MAS_
     | MENOS_
     ;

opMul : POR_
      | DIV_
      ;

opUna : MAS_
      | MENOS_
      | NOT_
      ;

%%
