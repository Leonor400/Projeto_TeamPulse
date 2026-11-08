# TeamPulse - Gestão de Equipas Desportivas

## 1. Elementos do Grupo 

- José Almeida - 20250810
- Leonor Almeida José - 20251351
- Isabella Almeida - 20251497 

## 2. Tema do projeto

A TeamPulse é uma aplicação móvel desenvolvida em Flutter e Dart, destinada à gestão e ao acompanhamento de equipas desportivas. O projeto tem como objetivo centralizar a informação relativa às equipas, aos atletas, aos jogos, aos calendários e às estatísticas, facilitando a organização e o acompanhamento da atividade desportiva por parte dos treinadores e atletas.

O projeto tem como caso de estudo o Clube Futebol Benfica.

## 3. Ecrãs disponíveis

A aplicação disponibiliza os seguintes ecrãs:

- Boas-vindas;
- Início de sessão;
- Criação de conta;
- Página principal do treinador;
- Página principal do atleta;
- Gestão de equipas;
- Consulta e adição de atletas;
- Calendário;
- Criação e seleção de jogos;
- Consulta e registo de acontecimentos dos jogos;
- Estatísticas da equipa;
- Estatísticas dos atletas;
- Perfil do treinador;
- Perfil do atleta.

## 4. Instruções de execução

Para executar a aplicação, é necessário ter o Flutter instalado e configurado.

1. Abrir o projeto no Visual Studio Code ou noutro ambiente compatível.
2. Abrir o terminal na pasta principal do projeto.
3. Executar o comando flutter pub get para instalar as dependências.
4. Executar o comando flutter doctor para verificar se o ambiente de desenvolvimento está corretamente configurado.
5. Executar o comando flutter run para iniciar a aplicação num dispositivo ou emulador compatível.


## 5. Funcionalidades simuladas

Algumas funcionalidades da aplicação são demonstrativas e não estão ligadas a serviços externos.

- Início de sessão: permite introduzir dados de acesso, mas não dispõe de um sistema de autenticação real.
- Criação de conta: permite preencher e validar o formulário, mas não guarda as novas contas de forma persistente.
- Gestão de dados: o ecrã Equipas do treinador obtém as atletas do servidor (GET /api/atletas). Os restantes ecrãs ainda usam dados de exemplo guardados na aplicação.
