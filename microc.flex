/*
 * microc.flex
 *
 * Esqueleto do analisador lexico (scanner) para a linguagem Micro C.
 * Disciplina: Compiladores I - FACOM
 *
 * Este arquivo NAO esta completo. Partes do reconhecimento de tokens
 * foram implementadas apenas como EXEMPLO, para orienta-lo(a) sobre o
 * padrao a seguir. As demais estao marcadas com "TODO(aluno)" e devem
 * ser completadas por voce.
 *
 * Compilacao:
 *      flex microc.flex
 *      gcc lex.yy.c -o lexer
 *
 * Uso:
 *      ./lexer test.mc
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ---------------------------------------------------------------------
 * 1. VOCABULARIO DE TOKENS (equivalente a tokens.h)
 * ------------------------------------------------------------------- */

typedef enum {
    /* Tokens fundamentais */
    UNDEF,          /* token indefinido (usado para reportar erros) */
    ID,             /* identificador                                */
    END_OF_FILE,    /* fim de arquivo                                */

    /* Constantes literais */
    INTEGERCONST,
    CHARCONST,
    STRINGCONST,

    /* Operadores aritmeticos */
    PLUS, MINUS, MUL, DIV, MOD,

    /* Operadores relacionais e logicos */
    EQ, NEQ, LT, GT, LEQ, GEQ, AND, OR, NOT,

    /* Simbolos de atribuicao e pontuacao */
    ASSIGN, SEMICOLON, COMMA, LPAREN, RPAREN,
    LBRACE, RBRACE, LBRACKET, RBRACKET,

    /* Palavras reservadas */
    MAIN, IF, ELSE, FOR, RETURN, INT, CHAR, PRINT
} TokenType;

/* Nomes dos tokens, usados apenas pelo main() de teste abaixo para
 * imprimir o tipo de cada token de forma legivel. Mantenha esta lista
 * na MESMA ORDEM do enum TokenType. */
static const char *nome_token[] = {
    "UNDEF", "ID", "END_OF_FILE",
    "INTEGERCONST", "CHARCONST", "STRINGCONST",
    "PLUS", "MINUS", "MUL", "DIV", "MOD",
    "EQ", "NEQ", "LT", "GT", "LEQ", "GEQ", "AND", "OR", "NOT",
    "ASSIGN", "SEMICOLON", "COMMA", "LPAREN", "RPAREN",
    "LBRACE", "RBRACE", "LBRACKET", "RBRACKET",
    "MAIN", "IF", "ELSE", "FOR", "RETURN", "INT", "CHAR", "PRINT"
};

/* Valor semantico do token corrente. */
typedef struct {
    char *symbol;      /* lexema para ID, INTEGERCONST, CHARCONST, STRINGCONST */
    char *error_msg;   /* mensagem de erro, usada apenas quando tipo == UNDEF   */
} YYSTYPE;

YYSTYPE microc_yylval;

/* Linha atual do arquivo-fonte sendo processado. Deve ser incrementada
 * toda vez que uma quebra de linha for consumida pelo scanner (seja em
 * codigo "normal", dentro de comentarios ou dentro de strings). */
int linha_atual = 1;

/* Funcao auxiliar para preencher microc_yylval.symbol com uma copia do
 * texto reconhecido (yytext). Sinta-se livre para usar/adaptar. */
static void guarda_lexema(void) {
    microc_yylval.symbol = strdup(yytext);
}

%}

/* -----------------------------------------------------------------------
 * 2. SECAO DE DEFINICOES
 * ------------------------------------------------------------------- */

DIGIT       [0-9]
LETRA       [a-zA-Z_]
ALFANUM     [a-zA-Z0-9_]

%x COMMENT

%%

 /* -----------------------------------------------------------------------
  * 3. SECAO DE REGRAS
  * --------------------------------------------------------------------- */

 /* --- Fim de arquivo -----------------------------------------------------
  * Tratada explicitamente (em vez de depender do retorno automatico 0
  * do flex), pois o token UNDEF tambem vale 0 no enum TokenType -- se
  * dependessemos do comportamento padrao, um erro lexico seria
  * confundido com o fim do arquivo pelo main() de teste abaixo. */
<<EOF>>             { return END_OF_FILE; }

 /* --- Espacos em branco e quebras de linha ---------------------------- */
\n                  { linha_atual++; }
[ \t\r]+            { /* ignora espacos em branco */ }

 /* --- Comentarios ------------------------------------------------------
  * Estes ja estao implementados como exemplo de uso de estados (%x) e
  * de tratamento de erro via EOF dentro de um estado especial. */
"//".*              { /* comentario de linha: ignora ate o fim da linha */ }

"/*"                { BEGIN(COMMENT); }
<COMMENT>"*/"       { BEGIN(INITIAL); }
<COMMENT>\n         { linha_atual++; }
<COMMENT><<EOF>>    {
                        microc_yylval.error_msg = "EOF em comentario";
                        return UNDEF;
                    }
<COMMENT>.          { /* consome qualquer outro caractere dentro do comentario */ }

 /* Fechamento de comentario sem abertura correspondente. */
"*/"                {
                        microc_yylval.error_msg = "Comentario nao iniciado";
                        return UNDEF;
                    }

 /* --- Palavras reservadas e identificadores ----------------------------
  * TODO(aluno): atualmente TODA sequencia de letras/underscore e
  * devolvida como ID. Voce deve comparar o lexema reconhecido com cada
  * palavra reservada da linguagem (main, if, else, for, return, int,
  * char, print) e devolver o token especifico quando houver
  * correspondencia. Use strcmp(), conforme discutido em aula, ou uma
  * tabela hash caso queira ir alem do exigido. Nao esqueca de chamar
  * guarda_lexema() (ou equivalente) quando o token for de fato ID. */
{LETRA}{ALFANUM}*   {
                        /* TODO(aluno): reconhecer palavras reservadas aqui */
                        guarda_lexema();
                        return ID;
                    }

 /* --- Constantes inteiras -----------------------------------------------
  * TODO(aluno): o padrao formal para um inteiro em Micro C e um ou mais
  * digitos, opcionalmente precedidos de um sinal de menos (numeros
  * negativos). A regra abaixo trata apenas inteiros sem sinal; use a
  * tecnica de lookahead discutida em aula (veja o operador MINUS mais
  * abaixo) para decidir quando um '-' faz parte do numero e quando ele
  * e, na verdade, o operador de subtracao. */
{DIGIT}+            {
                        guarda_lexema();
                        return INTEGERCONST;
                    }

 /* --- Constantes de caractere --------------------------------------------
  * TODO(aluno): reconhecer o padrao 'x' (aspas simples, um caractere,
  * aspas simples) e devolver CHARCONST. Trate tambem o caso de erro em
  * que as aspas simples nao sao fechadas corretamente (token UNDEF). */


 /* --- Constantes de string -------------------------------------------
  * TODO(aluno): reconhecer o padrao "[^"\n]*" (uma ou mais aspas
  * duplas delimitando o conteudo da string) e devolver STRINGCONST.
  * Voce deve tratar os seguintes erros (veja o enunciado, Secao 4.1):
  *   - EOF antes do fechamento da string ("EOF em string")
  *   - quebra de linha nao escapada dentro da string
  *     ("String nao terminada")
  *   - caractere nulo dentro da string
  *     ("String contem caractere nulo")
  * Alem disso, converta as sequencias de escape (\n, \t, \\, \", \0)
  * para os caracteres correspondentes antes de armazenar o lexema. */


 /* --- Operadores relacionais e logicos ---------------------------------
  * O caso de '=' esta implementado como EXEMPLO do uso de lookahead
  * (yytext mostra o que foi casado; voce pode usar input()/unput() ou,
  * de forma mais simples em flex, escrever as duas alternativas como
  * regras separadas, deixando o proprio flex escolher o casamento mais
  * longo -- veja a explicacao na Secao 2 do enunciado). */
"=="                { return EQ; }
"="                 { return ASSIGN; }

 /* TODO(aluno): complete os demais operadores que compartilham prefixo,
  * seguindo o mesmo padrao do exemplo acima:
  *   !=  e  !      ->  NEQ, NOT
  *   <=  e  <      ->  LEQ, LT
  *   >=  e  >      ->  GEQ, GT
  *   &&             ->  AND
  *   ||             ->  OR
  */

 /* --- Operadores aritmeticos e simbolos de pontuacao (ja prontos) ------ */
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MUL; }
"/"                 { return DIV; }
"%"                 { return MOD; }
";"                 { return SEMICOLON; }
","                 { return COMMA; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }

 /* --- Caractere invalido -------------------------------------------------
  * Casa com qualquer caractere que nao tenha correspondido a nenhuma
  * regra anterior. Deve ser SEMPRE a ultima regra do arquivo. */
.                   {
                        microc_yylval.error_msg = strdup(yytext);
                        return UNDEF;
                    }

%%

/* -----------------------------------------------------------------------
 * 4. SUB-ROTINAS DO USUARIO
 * ------------------------------------------------------------------- */

/* yywrap: informa ao flex que, ao atingir o EOF, a leitura deve
 * simplesmente parar (nao ha um proximo arquivo a processar). */
int yywrap(void) {
    return 1;
}

/* main() de teste: le o arquivo passado como argumento e imprime, para
 * cada token reconhecido, seu tipo, lexema e linha -- no mesmo espirito
 * do utilitario "lexer" mencionado no enunciado (Secao 6). Este main()
 * e apenas uma ferramenta de depuracao para voce testar seu scanner de
 * forma isolada; ele NAO faz parte da interface formal entre o scanner
 * e o parser (isso sera tratado nos trabalhos seguintes). */
int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo.mc>\n", argv[0]);
        return 1;
    }

    FILE *arquivo_fonte = fopen(argv[1], "r");
    if (!arquivo_fonte) {
        fprintf(stderr, "Erro: nao foi possivel abrir o arquivo '%s'\n", argv[1]);
        return 1;
    }
    yyin = arquivo_fonte;

    int tipo;
    while ((tipo = yylex()) != END_OF_FILE) {
        if (tipo == UNDEF) {
            fprintf(stderr, "ERRO LEXICO (linha %d): %s\n",
                    linha_atual, microc_yylval.error_msg);
            continue;
        }
        printf("Token: tipo = %-13s lexema = '%s'  linha = %d\n",
               nome_token[tipo], yytext, linha_atual);
    }

    fclose(arquivo_fonte);
    return 0;
}
