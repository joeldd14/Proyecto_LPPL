/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          jbenedi@dsic.upv.es>     V. 24  **/
/*****************************************************************************/
%{
#include "header.h"
#include "libtds.h"

static int dvarGlobal;
%}

%union {
    char *ident;   /* Nombre del identificador */
    int cent;      /* Valor de la constante numerica entera */
}

%token MAS_ MENOS_ POR_ DIV_
%token <cent> CTE_ 

%token ASIG_ NOT_ IGUAL_ DESIGUAL_ AND_ OR_
%token MAYOR_ MENOR_ MAYOR_IGUAL_ MENOR_IGUAL_
%token AP_ CP_ AC_ CC_ AL_ CL_ PCOMA_ COMA_
%token TRUE_ FALSE_ INT_ BOOL_ RETURN_ PRINT_
%token IF_ ELSE_ FOR_ SWITCH_
%token LESS_ EQUAL_ GREATER_ READ_ 
%token <ident> ID_

%type <cent> tipoSimp
%type <cent> const

%%

programa :
    {
        niv = 0;
        dvar = 0;
        cargaContexto(niv);
    }
    listDecla
    {
        if (verTdS)
            mostrarTdS();
    }
    ;

listDecla : decla
          | listDecla decla
          ;

decla : declaVar
      | declaFunc
      ;

declaVar : tipoSimp ID_ PCOMA_
         {
             if (!insTdS($2, VARIABLE, $1, niv, dvar, -1))
                 yyerror("Identificador repetido");
             else
                 dvar += TALLA_TIPO_SIMPLE;
         }
         | tipoSimp ID_ ASIG_ const PCOMA_
              {
                  if ($1 != $4)
                      yyerror("Error de tipos en la inicializacion");

                  if (!insTdS($2, VARIABLE, $1, niv, dvar, -1))
                      yyerror("Identificador repetido");
                  else
                      dvar += TALLA_TIPO_SIMPLE;
              }
         | tipoSimp ID_ AC_ CTE_ CC_ PCOMA_
              {
                  if ($4 <= 0) {
                      yyerror("El tamaño del vector debe ser positivo");
                  }
                  else {
                      int ref = insTdA($1, $4);

                      if (!insTdS($2, VARIABLE, T_ARRAY, niv, dvar, ref))
                          yyerror("Identificador repetido");
                      else
                          dvar += $4 * TALLA_TIPO_SIMPLE;
                  }
              }
         ;

const : CTE_   { $$ = T_ENTERO; }
      | TRUE_  { $$ = T_LOGICO; }
      | FALSE_ { $$ = T_LOGICO; }
      ;

tipoSimp : INT_   { $$ = T_ENTERO; }
         | BOOL_  { $$ = T_LOGICO; }
         ;

declaFunc : tipoSimp ID_
            {
                dvarGlobal = dvar;
                niv = 1;
                dvar = 0;
                cargaContexto(niv);
            }
            AP_ paramForm CP_
            {
                /* Pendiente: registrar la función */
            }
            AL_ declaVarLocal listInst RETURN_ expre PCOMA_ CL_
            {
                if (verTdS)
                    mostrarTdS();

                descargaContexto(niv);
                niv = 0;
                dvar = dvarGlobal;
            }
          ;

paramForm : /* vacío */
          | listParamForm
          ;

listParamForm : tipoSimp ID_
              {
                  if (!insTdS($2, PARAMETRO, $1, niv,
                              -TALLA_SEGENLACES - 1, -1))
                      yyerror("Identificador repetido");

                  $$ = 1;
              }
              | tipoSimp ID_ COMA_ listParamForm
              {
                  if (!insTdS($2, PARAMETRO, $1, niv,
                              -TALLA_SEGENLACES - 1 - $4, -1))
                      yyerror("Identificador repetido");

                  $$ = $4 + 1;
              }
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
