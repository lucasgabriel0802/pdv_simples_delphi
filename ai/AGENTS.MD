# Regras do Projeto

## Arquitetura

DDD + SOLID

## Banco

Firebird 5 com FireDAC

## Regras obrigatórias

- Usar conexão Singleton
- Toda operação de venda deve usar transação
- Nunca permitir estoque negativo
- Sempre registrar movimentação de estoque
- Forms não possuem regra de negócio
- Repositories são únicos responsáveis por SQL

## Relatórios

- Devem usar queries separadas
- Devem aceitar parâmetros
- Nunca lógica de negócio dentro do relatório

## Código

- Seguir Clean Code
- Métodos pequenos
- Evitar duplicação
