# Sistema de Cadastro de Clientes

Sistema desenvolvido em **Lazarus/Free Pascal** para cadastro e gerenciamento de clientes com integração ao banco de dados SQLite.

## 🚀 Funcionalidades

- ✅ **Cadastro de clientes** com validação de campos
- ✅ **Busca automática de endereço** via API ViaCEP
- ✅ **Banco de dados SQLite** integrado
- ✅ **Interface gráfica** intuitiva
- ✅ **Validação de CPF** e campos obrigatórios
- ✅ **Tratamento de erros** robusto

## 🛠️ Tecnologias Utilizadas

- **Lazarus IDE** - Ambiente de desenvolvimento
- **Free Pascal** - Linguagem de programação
- **SQLite** - Banco de dados
- **Zeos Components** - Conectividade com banco de dados
- **API ViaCEP** - Consulta de endereços

## 🏗️ Estrutura do Projeto

```
├── project02.lpr           # Arquivo principal do projeto
├── project02.lpi           # Configurações do projeto Lazarus
├── principal.pas/.lfm      # Formulário principal
├── cadastrocliente.pas/.lfm # Formulário de cadastro
├── clientes.db             # Banco de dados SQLite
└── .gitignore             # Arquivos ignorados pelo Git
```

## 📋 Pré-requisitos

- **Lazarus IDE** 2.0+ 
- **Free Pascal Compiler** 3.2+
- **Zeos Database Objects** (componentes de conectividade)
- **OpenSSL** (para requisições HTTPS)

## 🚀 Como executar

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/HayJM/Projeto_02.git
   cd Projeto_02
   ```

2. **Abra no Lazarus:**
   - Abra o arquivo `project02.lpi` no Lazarus IDE

3. **Instale dependências:**
   - Zeos Database Objects
   - OpenSSL sockets

4. **Compile e execute:**
   ```bash
   lazbuild project02.lpi
   ./project02
   ```

## 📊 Banco de Dados

O sistema cria automaticamente a tabela `cliente` com os seguintes campos:

| Campo        | Tipo    | Descrição                    |
|--------------|---------|------------------------------|
| id           | INTEGER | Chave primária (auto incremento) |
| nome         | TEXT    | Nome completo do cliente     |
| cpf          | TEXT    | CPF do cliente              |
| telefone     | TEXT    | Telefone de contato         |
| cep          | TEXT    | CEP do endereço             |
| rua          | TEXT    | Logradouro                  |
| numero       | TEXT    | Número da residência        |
| bairro       | TEXT    | Bairro                      |
| complemento  | TEXT    | Complemento do endereço     |
| cidade       | TEXT    | Cidade                      |
| estado       | TEXT    | Estado/UF                   |
| genero       | TEXT    | Gênero do cliente           |

## 🔧 Principais Funcionalidades

### Cadastro de Cliente
- Validação de campos obrigatórios (Nome, CPF, Gênero)
- Máscaras para CPF, telefone e CEP
- Limpeza automática dos campos após cadastro

### Busca de CEP
- Integração com API ViaCEP
- Preenchimento automático de endereço
- Tratamento de erros para CEPs inválidos

### Banco de Dados
- Criação automática da estrutura
- Transações seguras
- Controle de erros robusto

## 👨‍💻 Autor

**HayJM** - [GitHub](https://github.com/HayJM)

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

---

⭐ **Se este projeto te ajudou, deixe uma estrela!**
