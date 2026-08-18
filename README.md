# Trabalho de Compiladores I - Parte 1

# Trabalho Prático 1: Análise Léxica para Micro C

Repositório do Trabalho Prático 1 da disciplina **Compiladores I (FACOM)**: implementação de um **analisador léxico (scanner)** para a linguagem **Micro C**, utilizando a ferramenta **Flex**.

## 📋 Sobre o trabalho

O objetivo é completar a especificação léxica de Micro C a partir de um esqueleto fornecido (`microc.flex`), reconhecendo corretamente todos os tokens da linguagem — palavras reservadas, identificadores, constantes, operadores e delimitadores — além de identificar e reportar erros léxicos.

Para cada token reconhecido na entrada, o scanner deve imprimir seu tipo, o lexema correspondente e a linha em que foi encontrado:

```
Token: tipo = INT lexema = 'int' linha = 1
Token: tipo = ID lexema = 'x' linha = 1
Token: tipo = ASSIGN lexema = '=' linha = 1
Token: tipo = INTEGERCONST lexema = '10' linha = 1
Token: tipo = SEMICOLON lexema = ';' linha = 1
```

Erros léxicos (token `UNDEF`) são impressos na saída de erro padrão (`stderr`) no formato:

```
ERRO LEXICO (linha N): <mensagem de erro>
```

O enunciado completo do trabalho está disponível em [`TP1_Analise_Lexica_MicroC.pdf`](./TP1_Analise_Lexica_MicroC.pdf).

## 📁 Estrutura do repositório

```
comp1-2026/
├── microc.flex                    # Especificação léxica (arquivo principal a editar)
├── tests/                         # Programas de exemplo em Micro C usados como entrada de teste
├── TP1_Analise_Lexica_MicroC.pdf  # Enunciado do trabalho
├── leiame.txt                     # Instruções originais do professor
└── README.md                      # Este arquivo
```

## ✅ Itens a implementar

- [ ] Reconhecimento das palavras reservadas: `main`, `if`, `else`, `for`, `return`, `int`, `char`, `print` (atualmente tratadas como `ID`)
- [ ] Constantes de caractere (`CHARCONST`) e de string (`STRINGCONST`), com conversão de sequências de escape (`\n`, `\t`, `\\`, `\"`, `\0`) e tratamento dos erros correspondentes
- [ ] Operadores relacionais e lógicos com prefixo compartilhado: `!=`, `!`, `<=`, `<`, `>=`, `>`, `&&`, `||` (seguindo o exemplo já implementado para `==` e `=`)
- [ ] Tratamento de constantes inteiras negativas, diferenciando-as do operador de subtração
- [ ] Ampliação dos arquivos de teste, cobrindo o maior número possível de tokens e de erros léxicos
- [ ] Especificação léxica completa (toda entrada deve corresponder a alguma regra, inclusive a regra de erro no final do arquivo)
- [ ] Remoção de instruções de depuração (`printf` de teste etc.) antes da entrega

## 🔧 Como compilar

No diretório do projeto, execute:

```bash
flex microc.flex
gcc lex.yy.c -o lexer
```

O primeiro comando gera o arquivo `lex.yy.c` a partir das regras definidas em `microc.flex`. O segundo compila esse código gerado, produzindo o executável `lexer`.

> Caso o professor disponibilize um `Makefile`, os mesmos passos poderão ser executados com `make lexer`.

## ▶️ Como executar

```bash
./lexer tests/test.mc
```

O programa lê o arquivo Micro C informado, imprime os tokens reconhecidos e reporta eventuais erros léxicos.

## 👤 Autor(es)

| Nome | Matrícula |
|------|-----------|
| _preencher_ | _preencher_ |
| _preencher (se houver dupla)_ | _preencher_ |

## 🎓 Disciplina

- **Curso:** Compiladores I
- **Instituição:** FACOM
- **Trabalho:** TP1 — Análise Léxica para a linguagem Micro C

A submissão deve seguir as instruções específicas informadas pelo professor no AVA (Moodle), dentro do prazo estabelecido no cronograma da disciplina.
