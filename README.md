# chamada_inteligente

Trabalho da disciplina de Engenharia de Software II que tem como objetivo implementar um software mobile de chamada inteligente para professores e alunos da universdade.

## 1. Requisitos

- Flutter SDK
- MySQL
- Android Studio
- Python
- Flask (módulo Python)

## 2. Links de instalação

- Flutter SDK: https://docs.flutter.dev/get-started/install?gclid=CjwKCAiAmZGrBhAnEiwAo9qHiXgeqB_2g1HjorW0Nd-60GX0Puju9xxE_HMP6EhNv0Gbbmvu7-f1jhoCG74QAvD_BwE&gclsrc=aw.ds
- MySQL: https://dev.mysql.com/downloads/installer/
- Android Studio: https://developer.android.com/studio/install?hl=pt-br
- Python: https://www.python.org/downloads/
- Flask: Através do pip

## 3. Setup

- Flutter SDK: https://docs.flutter.dev/get-started/editor
  - Além disso, é recomendável instalar a extensão do Flutter e do Dart no VSCode
  - É necessário rodar o comando "flutter pub get" para pegar automaticamente todas as dependências do projeto
- Python: Após instalar o python, deve-se instalar os módulos utilizados nos arquivos .py via pip.
- Flask: O backend feito em Flask necessita da instalação via pip de seus módulos (utilizados nos .py).
- MySQL:
  - Executar no seu MySQL workbench o arquivo .sql que gera o nosso banco de dados.
  - Na pasta root do projeto, crie um arquivo .env com as seguintes variáveis:   
    - PASSWORD: Sua senha de acesso ao localhost do MySQL
    - URL: A URL gerada pelo Flask no terminal ao rodar o arquivo app.py (nosso backend). Não utilizar 127.0.0.1 para emuladores.
    - database: Nome do seu schema no MySQL ( TO-DOOOOOOOOOO)!!!!!!!!!!!!!!!!!!!!!
   
## 4. Utilização

- Executar o arquivo app.py para iniciar o backend
- Executar o arquivo main.dart para iniciar o aplicativo
- Alguns alunos e professores pré-cadastrados no banco de dados mockado podem ser utilizados para teste.
  - Login de aluno: (1001 - senha1), (1002 - senha2), ..., (1020 - senha20).
  - Login de professor: (2001 - senha1), (2002 - senha2), ..., (2005 - senha5).

## 5. Testes

- Testes unitários: ( TO-DOOOOOOOOOO)!!!!!!!!!!!!!!!!!!!!!
- Testes de fumaça: ( TO-DOOOOOOOOOO)!!!!!!!!!!!!!!!!!!!!!

## 5. Documentação

- Link do Google Drive de monitoramento e controle do projeto: ( TO-DOOOOOOOOOO)!!!!!!!!!!!!!!!!!!!!!
