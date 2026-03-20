# Sistema de Vendas com Controle de Estoque

## Objetivo

Sistema desktop em Delphi para:

- Cadastro de clientes
- Cadastro de produtos
- Controle de estoque
- Registro de vendas

## Arquitetura

Camadas:

- UI (Forms)
- Services (Regras de negócio)
- DataModule (FireDAC)
- Banco de Dados

## Entidades

### Cliente

- id
- nome
- telefone

### Produto

- id
- nome
- preco
- estoque

### Venda

- id
- data
- id_cliente
- total

### VendaItem

- id
- id_venda
- id_produto
- qtd
- valor_unitario
- total

### EstoqueMov

- id
- id_produto
- data
- tipo (E, S, A)
- quantidade

## Regras

### Estoque

- Entrada soma estoque
- Venda subtrai estoque
- Ajuste pode somar ou subtrair
- Toda movimentação deve ser registrada

### Venda

- valor_unitario deve ser salvo no item
- total_item = qtd \* valor_unitario
- total_venda = soma dos itens

### Restrições

- Não permitir estoque negativo
- Produto obrigatório para movimentação

## Fluxo principal

1. Cadastrar produto
2. Entrada estoque
3. Criar venda
4. Adicionar itens
5. Baixar estoque
6. Totalizar venda
