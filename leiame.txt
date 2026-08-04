===============================================================
 Compiladores I - FACOM
 Trabalho Pratico 1 - Analise Lexica para a linguagem Micro C
===============================================================

aluno: <preencha aqui seu numero de matricula>
aluno: <preencha aqui o numero de matricula do(a) colega, se houver dupla>


---8<------8<------8<------8<---cut here---8<------8<------8<------8<---

INSTRUCOES (remova esta secao, do inicio do arquivo ate esta linha
INCLUSIVE, antes de entregar o trabalho)

Conteudo deste pacote
----------------------
  microc.flex  - esqueleto do analisador lexico (arquivo principal a
                 ser editado por voce). Contem a definicao dos tokens
                 de Micro C, algumas regras ja implementadas como
                 exemplo, e varios trechos marcados com "TODO(aluno)"
                 que voce deve completar.

  test.mc      - programa de exemplo em Micro C, usado como entrada de
                 teste para o scanner. Voce deve ampliar este arquivo
                 (ou criar outros) com casos de teste proprios que
                 exercitem bem o seu scanner, incluindo casos de erro
                 lexico.

  README       - este arquivo.


Compilando o scanner
----------------------
No diretorio do projeto, execute:

    flex microc.flex
    gcc lex.yy.c -o lexer

O primeiro comando gera o arquivo lex.yy.c a partir das regras
definidas em microc.flex. O segundo compila esse codigo gerado,
produzindo o executavel "lexer".

(Caso o professor disponibilize um Makefile junto com uma versao
posterior deste pacote, os mesmos passos poderao ser executados com
"make lexer".)


Executando o scanner
----------------------
    ./lexer test.mc

O programa ira imprimir, para cada token reconhecido, seu tipo, o
lexema correspondente e a linha em que foi encontrado, por exemplo:

    Token: tipo = INT           lexema = 'int'  linha = 1
    Token: tipo = ID            lexema = 'x'    linha = 1
    Token: tipo = ASSIGN        lexema = '='    linha = 1
    Token: tipo = INTEGERCONST  lexema = '10'   linha = 1
    Token: tipo = SEMICOLON     lexema = ';'    linha = 1

Erros lexicos (token UNDEF) sao impressos na saida de erro padrao
(stderr), no formato:

    ERRO LEXICO (linha N): <mensagem de erro>


O que voce precisa fazer
----------------------
1. Complete, em microc.flex, o reconhecimento das palavras reservadas
   (main, if, else, for, return, int, char, print), atualmente todas
   tratadas como ID.
2. Implemente o reconhecimento de constantes de caractere (CHARCONST)
   e de string (STRINGCONST), incluindo a conversao de sequencias de
   escape (\n, \t, \\, \", \0) e o tratamento dos erros descritos na
   Secao 4.1 do enunciado do trabalho.
3. Complete os operadores relacionais e logicos que compartilham
   prefixo com outros operadores (!=, !, <=, <, >=, >, &&, ||),
   seguindo o exemplo ja implementado para "==" e "=".
4. Trate o caso de constantes inteiras negativas (numeros precedidos
   de sinal de menos), diferenciando-os do operador de subtracao.
5. Amplie o arquivo test.mc (ou crie arquivos de teste adicionais) de
   forma a cobrir o maior numero possivel de tokens e de situacoes de
   erro lexico previstas no enunciado.
6. Garanta que sua especificacao lexica esteja completa, isto e, que
   toda entrada possivel corresponda a alguma regra (mesmo que seja a
   regra de erro no final do arquivo).
7. Remova quaisquer instrucoes de depuracao (printf de teste, etc.)
   antes de entregar.

---8<------8<------8<------8<---cut here---8<------8<------8<------8<---


Estrutura da entrega
----------------------
Apos remover a secao de instrucoes acima, este README deve conter
apenas a(s) linha(s) "aluno: <matricula>" no topo do arquivo.

A submissao deve ser feita conforme as instrucoes especificas
informadas pelo professor no AVA (Moodle), dentro do prazo estabelecido
no cronograma da disciplina.
