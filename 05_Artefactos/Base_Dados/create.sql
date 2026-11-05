set names utf8mb4;

drop database if exists team_pulse;
create database team_pulse
  character set utf8mb4
  collate utf8mb4_unicode_ci;
use team_pulse;

create table utilizador (
          id_utilizador   int not null auto_increment,
          nome            varchar(100) not null,
          email           varchar(150) not null,       #único
          password_hash   varchar(255) not null,       #nunca a password em texto (RGPD)
          telefone        varchar(20),
          data_registo    datetime not null,           #data e hora do registo
          primary key (id_utilizador)
);

create table treinador (
          id_utilizador    int not null,               #FK para utilizador
          numero_licenca   varchar(30),
          qualificacao     varchar(100),
          primary key (id_utilizador)
);

create table atleta (
          id_utilizador      int not null,             #FK para utilizador
          data_nascimento    date not null,
          genero             char(1),                  #M, F ou O (outro)
          altura_cm          smallint,
          peso_kg            decimal(5,2),             #5 algarismos, com 2 casas decimais
          posicao_preferida  varchar(30),
          primary key (id_utilizador)
);

create table modalidade (
          id_modalidade  int not null auto_increment,
          nome           varchar(50) not null,
          primary key (id_modalidade)
);

create table equipa (
          id_equipa      int not null auto_increment,
          nome           varchar(100) not null,
          escalao        varchar(30)  not null,        #ex.: 'Sub-17'
          epoca          char(9)      not null,        #ex.: '2026/2027'
          id_modalidade  int not null,                 #FK para modalidade
          primary key (id_equipa)
);

create table equipa_treinador (
          id_equipa_treinador  int not null auto_increment,
          id_equipa            int not null,           #FK para equipa
          id_treinador         int not null,           #FK para treinador
          funcao               varchar(20) not null,   #principal, adjunto, guarda-redes ou preparador_fisico
          data_inicio          date not null,
          data_fim             date,                   #NULL = ainda está na equipa
          primary key (id_equipa_treinador)
);

create table inscricao (
          id_inscricao     int not null auto_increment,
          id_equipa        int not null,               #FK para equipa
          id_atleta        int not null,               #FK para atleta
          data_entrada     date not null,
          data_saida       date,                       #NULL = ainda está na equipa
          numero_camisola  tinyint,                    #1 a 99
          primary key (id_inscricao)
);

create table local (
          id_local   int not null auto_increment,
          nome       varchar(100) not null,            #ex.: 'Campo 2'
          morada     varchar(200),
          latitude   decimal(9,6),
          longitude  decimal(9,6),
          primary key (id_local)
);

create table tipo_atividade (
          id_tipo_atividade  int not null auto_increment,
          nome               varchar(20) not null,     #treino, jogo, torneio
          primary key (id_tipo_atividade)
);

create table estado_atividade (
          id_estado_atividade  int not null auto_increment,
          nome                 varchar(20) not null,   #agendada, alterada, cancelada, realizada
          primary key (id_estado_atividade)
);

create table estado_presenca (
          id_estado_presenca  int not null auto_increment,
          nome                varchar(20) not null,    #presente, ausente, justificada
          primary key (id_estado_presenca)
);

create table atividade (
          id_atividade         int not null auto_increment,
          id_equipa            int not null,           #FK para equipa
          id_tipo_atividade    int not null,           #FK para tipo_atividade
          data_hora_inicio     datetime not null,
          data_hora_fim        datetime,               #se existir, tem de ser depois do início
          id_local             int not null,           #FK para local
          adversario           varchar(100),           #só para jogos
          observacoes          varchar(500),
          codigo_qr            char(12) not null,      #um código único por atividade
          id_estado_atividade  int not null,           #FK para estado_atividade
          primary key (id_atividade)
);

create table presenca (
          id_presenca         int not null auto_increment,
          id_atividade        int not null,            #FK para atividade
          id_atleta           int not null,            #FK para atleta
          id_estado_presenca  int not null,            #FK para estado_presenca
          metodo              varchar(10) not null,    #qr ou manual
          data_hora_registo   datetime,
          justificacao        varchar(255),            #ex.: 'Lesão - informou'
          primary key (id_presenca)
);

create table disponibilidade (
          id_disponibilidade  int not null auto_increment,
          id_atividade        int not null,            #FK para atividade
          id_atleta           int not null,            #FK para atleta
          resposta            varchar(10) not null,    #vou, nao_vou ou talvez
          motivo              varchar(255),
          data_resposta       datetime not null,       #data e hora da última resposta
          primary key (id_disponibilidade)
);

create table formulario (
          id_formulario  int not null auto_increment,
          id_atividade   int not null,                 #FK para atividade
          id_treinador   int not null,                 #FK para treinador
          titulo         varchar(100) not null,
          descricao      varchar(500),
          data_criacao   datetime not null,
          data_limite    datetime,
          primary key (id_formulario)
);

create table pergunta (
          id_pergunta    int not null auto_increment,
          id_formulario  int not null,                 #FK para formulario
          ordem          tinyint not null,             #1, 2, 3... dentro do formulário
          texto          varchar(255) not null,
          tipo_resposta  varchar(10) not null,         #escala (1 a 5), texto ou sim_nao
          primary key (id_pergunta)
);

create table resposta (
          id_resposta     int not null auto_increment,
          id_pergunta     int not null,                #FK para pergunta
          id_atleta       int not null,                #FK para atleta
          valor_numero    tinyint,                     #escala (1-5) ou sim/não (1/0)
          valor_texto     varchar(1000),               #resposta escrita
          data_submissao  datetime not null,
          primary key (id_resposta)
);

create table estatistica_jogo (
          id_estatistica      int not null auto_increment,
          id_atividade        int not null,            #FK para atividade
          id_atleta           int not null,            #FK para atleta
          minutos_jogados     tinyint not null,        #0 ou mais
          golos               tinyint not null,        #0 ou mais
          assistencias        tinyint not null,        #0 ou mais
          cartoes_amarelos    tinyint not null,        #0 a 2
          cartoes_vermelhos   tinyint not null,        #0 ou 1
          distancia_km        decimal(4,2),            #dados GPS, quando existem
          velocidade_max_kmh  decimal(4,1),            #dados GPS, quando existem
          primary key (id_estatistica)
);

create table aviso (
          id_aviso         int not null auto_increment,
          id_equipa        int not null,               #FK para equipa
          id_treinador     int not null,               #FK para treinador
          titulo           varchar(100) not null,
          mensagem         varchar(1000) not null,
          fixado           char(1) not null,           #S = fixado no Início do atleta, N = não
          data_publicacao  datetime not null,
          primary key (id_aviso)
);

-- Foreign Keys

alter table treinador
add constraint treinador_fk_utilizador
foreign key (id_utilizador) references utilizador(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table atleta
add constraint atleta_fk_utilizador
foreign key (id_utilizador) references utilizador(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table equipa
add constraint equipa_fk_modalidade
foreign key (id_modalidade) references modalidade(id_modalidade)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table equipa_treinador
add constraint equipa_treinador_fk_equipa
foreign key (id_equipa) references equipa(id_equipa)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table equipa_treinador
add constraint equipa_treinador_fk_treinador
foreign key (id_treinador) references treinador(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table inscricao
add constraint inscricao_fk_equipa
foreign key (id_equipa) references equipa(id_equipa)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table inscricao
add constraint inscricao_fk_atleta
foreign key (id_atleta) references atleta(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table atividade
add constraint atividade_fk_equipa
foreign key (id_equipa) references equipa(id_equipa)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table atividade
add constraint atividade_fk_tipo_atividade
foreign key (id_tipo_atividade) references tipo_atividade(id_tipo_atividade)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table atividade
add constraint atividade_fk_local
foreign key (id_local) references local(id_local)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table atividade
add constraint atividade_fk_estado_atividade
foreign key (id_estado_atividade) references estado_atividade(id_estado_atividade)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table presenca
add constraint presenca_fk_atividade
foreign key (id_atividade) references atividade(id_atividade)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table presenca
add constraint presenca_fk_atleta
foreign key (id_atleta) references atleta(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table presenca
add constraint presenca_fk_estado_presenca
foreign key (id_estado_presenca) references estado_presenca(id_estado_presenca)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table disponibilidade
add constraint disponibilidade_fk_atividade
foreign key (id_atividade) references atividade(id_atividade)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table disponibilidade
add constraint disponibilidade_fk_atleta
foreign key (id_atleta) references atleta(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table formulario
add constraint formulario_fk_atividade
foreign key (id_atividade) references atividade(id_atividade)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table formulario
add constraint formulario_fk_treinador
foreign key (id_treinador) references treinador(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table pergunta
add constraint pergunta_fk_formulario
foreign key (id_formulario) references formulario(id_formulario)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table resposta
add constraint resposta_fk_pergunta
foreign key (id_pergunta) references pergunta(id_pergunta)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table resposta
add constraint resposta_fk_atleta
foreign key (id_atleta) references atleta(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table estatistica_jogo
add constraint estatistica_jogo_fk_atividade
foreign key (id_atividade) references atividade(id_atividade)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table estatistica_jogo
add constraint estatistica_jogo_fk_atleta
foreign key (id_atleta) references atleta(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table aviso
add constraint aviso_fk_equipa
foreign key (id_equipa) references equipa(id_equipa)
ON DELETE NO ACTION ON UPDATE NO ACTION;

alter table aviso
add constraint aviso_fk_treinador
foreign key (id_treinador) references treinador(id_utilizador)
ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Unique

alter table utilizador
add constraint utilizador_uq_email
unique (email);

alter table atividade
add constraint atividade_uq_codigo_qr
unique (codigo_qr);

alter table presenca
add constraint presenca_uq_atividade_atleta
unique (id_atividade, id_atleta);

alter table disponibilidade
add constraint disponibilidade_uq_atividade_atleta
unique (id_atividade, id_atleta);

alter table resposta
add constraint resposta_uq_pergunta_atleta
unique (id_pergunta, id_atleta);

alter table estatistica_jogo
add constraint estatistica_jogo_uq_atividade_atleta
unique (id_atividade, id_atleta);
