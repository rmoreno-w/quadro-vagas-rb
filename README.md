# Ruby nos Trilhos

Este projeto utiliza **Ruby on Rails 8.0.1**, **Tailwind CSS**, **PostgreSQL**, **Stimulus**, e inclui **RSpec**, **Capybara**, **Cuprite** para testes. O ambiente é configurado usando **Docker**.

## Tecnologias

- Ruby on Rails 8.0.1
- Tailwind CSS
- PostgreSQL
- Stimulus.js
- RSpec, Capybara, Cuprite
- Docker (para banco de dados e PGAdmin)

## Configuração

### 1. Clonar o repositório

```bash
git clone https://github.com/usuario/projeto.git
cd projeto
```

### 2. Instalar Dependências

```bash
bundle install
yarn install
```

### 3. Variáveis de Ambiente

O projeto utiliza variáveis de ambiente para configurar aspectos sensíveis, como credenciais do banco de dados e outras configurações.

#### 1. Criar o Arquivo `.env`

Copie o arquivo `.env.example` para `.env` e preencha as variáveis de ambiente com os valores apropriados para o seu ambiente local.

```bash
cp .env.example .env
```

#### 2. Configurar o Arquivo `.env`

Abra o arquivo `.env` e adicione os valores necessários, como as credenciais do banco de dados PostgreSQL, por exemplo:

```
DATABASE_USERNAME=usuario
DATABASE_PASSWORD=senha
```

### 4. Configurar o Banco de Dados

```bash
bin/rails db:create
bin/rails db:migrate
```

### 5. Rodar o Projeto com Docker

```bash
sudo docker-compose up
```

Isso irá subir o PostgreSQL e PGAdmin.

### 5. Rodar o Servidor Rails

```bash
bin/rails server
```

O projeto ficará disponível em [http://localhost:3000](http://localhost:3000).

## Testes

Execute os testes com:

```bash
sudo docker-compose exec rails_server rspec
```
