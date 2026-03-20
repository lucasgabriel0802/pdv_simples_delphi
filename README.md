# PDV Simples Delphi

Sistema desktop em Delphi (VCL) para cadastro de produtos e registro de vendas, com controle de estoque e persistência em Firebird.

## Arquitetura

Projeto organizado em camadas:

- **Domain**: entidades e regras de negócio (`src/domain`)
- **Application**: serviços/use cases e interfaces de repositório (`src/application`)
- **Infrastructure**: conexão FireDAC, transações e repositórios SQL (`src/infrastructure`)
- **Presentation**: formulários VCL (`src/presentation`)

Fluxo de alto nível:

1. Forms chamam Services
2. Services aplicam regras de negócio e transação
3. Repositórios FireDAC executam SQL no Firebird

## Funcionalidades principais

- Cadastro de produtos (CRUD)
- Registro de venda com múltiplos itens
- Atualização automática de estoque na venda
- Relatório de vendas por período e cliente
- Bloqueio de estoque negativo

## Banco de dados

- Script de criação: `docs/scripts/create_database.sql`
- Configuração de conexão: `database.ini` (ao lado do executável)

Exemplo de `database.ini`:

```ini
[SERVIDOR]
Host=interno1
Port=3055
Debug=true
Database=NEWMEDT
User=SYSDBA
Password=masterkey
```

## Compilação local

Validar build Debug e Release:

```bat
validate_build.bat
```

## Empacotamento de release

Gerar artefatos:

```bat
package_release.bat 0.1.0
```

Saída:

- `dist/ProjetoVendas-v0.1.0-win32.zip`
- `dist/ProjetoVendas-v0.1.0-win32.sha256.txt`

## Publicação no GitHub

### 1) Automatizar setup do repositório

Este comando inicializa git, configura `origin`, cria commit e tenta push para `main`:

```bat
setup_github_repo.bat https://github.com/lucasgabriel0802/pdv_simples_delphi.git
```

### 2) Criar release local via GitHub CLI

Pré-requisitos:

- GitHub CLI instalado (`gh`)
- Autenticação feita (`gh auth login`)

Publicar release:

```bat
release_github.bat 0.1.0
```

## GitHub Actions

Workflow em `.github/workflows/release.yml`.

> Como usa `dcc32`, é necessário runner **self-hosted Windows** com Delphi/RAD Studio instalado e ambiente configurado (`rsvars.bat`).

### CI de build (PR e push)

Workflow separado em `.github/workflows/ci.yml` para validar compilação sem publicar release.

- Dispara em `push` para `main`
- Dispara em `pull_request` para `main`
- Executa `validate_build.bat`
- Publica logs (`build_debug.log` e `build_release.log`) como artifact
