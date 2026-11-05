set names utf8mb4;

use team_pulse;

# Q01 Próximas atividades dos Sub-17 nos próximos 7 dias, sem as canceladas
select t.nome tipo,
       date_format(a.data_hora_inicio, '%d/%m/%Y %H:%i') inicio,
       timestampdiff(MINUTE, a.data_hora_inicio, a.data_hora_fim) duracao_min,
       l.nome local,
       coalesce(a.adversario, '-') adversario,
       ea.nome estado
from atividade a
inner join tipo_atividade t on t.id_tipo_atividade = a.id_tipo_atividade
inner join estado_atividade ea on ea.id_estado_atividade = a.id_estado_atividade
inner join local l on l.id_local = a.id_local
where a.id_equipa = 1
  and ea.nome <> 'cancelada'
  and a.data_hora_inicio between str_to_date('2026.11.06 12:00','%Y.%m.%d %H:%i')
                             and str_to_date('2026.11.06 12:00','%Y.%m.%d %H:%i') + interval 7 day
order by a.data_hora_inicio;

# Q02 Plantel atual dos Seniores Femininos, com idade e dados físicos
select i.numero_camisola num,
       u.nome,
       at.posicao_preferida posicao,
       timestampdiff(YEAR, at.data_nascimento, str_to_date('2026.11.06','%Y.%m.%d')) idade,
       ifnull(concat(at.altura_cm, ' cm'), 'por preencher') altura
from inscricao i
inner join atleta at on at.id_utilizador = i.id_atleta
inner join utilizador u on u.id_utilizador = i.id_atleta
where i.id_equipa = 3
  and i.data_saida is null
order by i.numero_camisola;

# Q03 Atividades canceladas ou alteradas, com o motivo
select e.nome equipa,
       date_format(a.data_hora_inicio, '%d/%m %H:%i') quando,
       upper(ea.nome) estado,
       a.observacoes motivo
from atividade a
inner join equipa e on e.id_equipa = a.id_equipa
inner join estado_atividade ea on ea.id_estado_atividade = a.id_estado_atividade
where ea.nome in ('cancelada', 'alterada')
order by a.data_hora_inicio;

# Q04 Validação do QR Code: atividade do código lido e se a atleta está inscrita na equipa
select a.id_atividade, e.nome equipa, t.nome tipo,
       date_format(a.data_hora_inicio, '%d/%m/%Y %H:%i') inicio,
       case when 26 in (select i.id_atleta from inscricao i
                        where i.id_equipa = a.id_equipa and i.data_saida is null)
            then 'Código válido'
            else 'Atleta não pertence a esta equipa' end validacao
from atividade a
inner join equipa e on e.id_equipa = a.id_equipa
inner join tipo_atividade t on t.id_tipo_atividade = a.id_tipo_atividade
where a.codigo_qr = 'TETYQM2EFTYO';

# Q05 Lista de presenças do último treino realizado dos Sub-17
select u.nome,
       coalesce((select ep.nome
                 from presenca p
                 inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
                 where p.id_atividade = a.id_atividade and p.id_atleta = i.id_atleta),
                'por registar') estado,
       coalesce((select date_format(p.data_hora_registo, '%H:%i') from presenca p
                 where p.id_atividade = a.id_atividade and p.id_atleta = i.id_atleta), '-') hora,
       coalesce((select p.metodo from presenca p
                 where p.id_atividade = a.id_atividade and p.id_atleta = i.id_atleta), '-') metodo,
       coalesce((select p.justificacao from presenca p
                 where p.id_atividade = a.id_atividade and p.id_atleta = i.id_atleta), '') justificacao
from atividade a
inner join inscricao i on i.id_equipa = a.id_equipa
inner join utilizador u on u.id_utilizador = i.id_atleta
where a.id_atividade = (select a2.id_atividade
                        from atividade a2
                        inner join tipo_atividade t2 on t2.id_tipo_atividade = a2.id_tipo_atividade
                        inner join estado_atividade e2 on e2.id_estado_atividade = a2.id_estado_atividade
                        where a2.id_equipa = 1 and t2.nome = 'treino' and e2.nome = 'realizada'
                          and a2.data_hora_inicio = (select max(a3.data_hora_inicio)
                                                     from atividade a3
                                                     inner join tipo_atividade t3 on t3.id_tipo_atividade = a3.id_tipo_atividade
                                                     inner join estado_atividade e3 on e3.id_estado_atividade = a3.id_estado_atividade
                                                     where a3.id_equipa = 1 and t3.nome = 'treino' and e3.nome = 'realizada'))
  and i.data_entrada <= a.data_hora_inicio
  and (i.data_saida is null or a.data_hora_inicio < i.data_saida + interval 1 day)
order by estado, u.nome;

# Q06 Equipa técnica atual de cada equipa
select e.nome equipa,
       u.nome treinador,
       et.funcao,
       t.qualificacao
from equipa_treinador et
inner join equipa e on e.id_equipa = et.id_equipa
inner join treinador t on t.id_utilizador = et.id_treinador
inner join utilizador u on u.id_utilizador = et.id_treinador
where et.data_fim is null
order by e.nome, et.funcao desc;

# Q07 Respostas ao formulário pós-treino mais recente dos Seniores
select u.nome atleta,
       pg.ordem,
       pg.texto pergunta,
       case when pg.tipo_resposta = 'sim_nao' and r.valor_numero = 1 then 'Sim'
            when pg.tipo_resposta = 'sim_nao' then 'Não'
            when pg.tipo_resposta = 'escala' then concat(r.valor_numero, ' / 5')
            else r.valor_texto end resposta
from resposta r
inner join pergunta pg on pg.id_pergunta = r.id_pergunta
inner join formulario f on f.id_formulario = pg.id_formulario
inner join atividade a on a.id_atividade = f.id_atividade
inner join utilizador u on u.id_utilizador = r.id_atleta
where a.id_equipa = 3
  and f.data_criacao = (select max(f2.data_criacao)
                        from formulario f2
                        inner join atividade a2 on a2.id_atividade = f2.id_atividade
                        where a2.id_equipa = 3)
order by u.nome, pg.ordem;

# Q08 Avisos visíveis para a atleta Lara Natividade, fixados primeiro
select e.nome equipa, u.nome autor, av.titulo, av.mensagem,
       case when av.fixado = 'S' then 'Fixado' else '' end destaque,
       date_format(av.data_publicacao, '%d/%m %H:%i') publicado
from aviso av
inner join equipa e on e.id_equipa = av.id_equipa
inner join utilizador u on u.id_utilizador = av.id_treinador
inner join inscricao i on i.id_equipa = av.id_equipa
where i.id_atleta = 21 and i.data_saida is null
order by av.fixado desc, av.data_publicacao desc;

# Q09 Assiduidade de cada equipa por tipo de atividade realizada
select e.nome equipa, t.nome tipo,
       count(*) registos,
       sum(case when ep.nome = 'presente' then 1 else 0 end) presentes,
       100 * sum(case when ep.nome = 'presente' then 1 else 0 end) / count(*) taxa_presenca
from presenca p
inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
inner join atividade a on a.id_atividade = p.id_atividade
inner join tipo_atividade t on t.id_tipo_atividade = a.id_tipo_atividade
inner join equipa e on e.id_equipa = a.id_equipa
group by e.nome, t.nome
order by e.nome, t.nome;

# Q10 Atletas com assiduidade inferior a 75%
select u.nome atleta, e.nome equipa,
       count(*) atividades_elegiveis,
       sum(case when i.id_atleta in (select p.id_atleta
                                     from presenca p
                                     inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
                                     where p.id_atividade = a.id_atividade and ep.nome = 'presente')
                then 1 else 0 end) presencas,
       100 * sum(case when i.id_atleta in (select p.id_atleta
                                           from presenca p
                                           inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
                                           where p.id_atividade = a.id_atividade and ep.nome = 'presente')
                      then 1 else 0 end) / count(*) taxa_presenca
from inscricao i
inner join atividade a on a.id_equipa = i.id_equipa
inner join estado_atividade ea on ea.id_estado_atividade = a.id_estado_atividade
inner join equipa e on e.id_equipa = i.id_equipa
inner join utilizador u on u.id_utilizador = i.id_atleta
where ea.nome = 'realizada'
  and a.data_hora_inicio >= i.data_entrada
  and (i.data_saida is null or a.data_hora_inicio < i.data_saida + interval 1 day)
group by u.nome, e.nome
having 100 * sum(case when i.id_atleta in (select p.id_atleta
                                           from presenca p
                                           inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
                                           where p.id_atividade = a.id_atividade and ep.nome = 'presente')
                      then 1 else 0 end) / count(*) < 75
order by taxa_presenca;

# Q11 Melhores marcadores da época, com golos por 90 minutos
select u.nome, e.nome equipa,
       count(*) jogos,
       sum(s.golos) golos,
       sum(s.assistencias) assistencias,
       sum(s.golos) * 90 / sum(s.minutos_jogados) golos_por_90
from estatistica_jogo s
inner join utilizador u on u.id_utilizador = s.id_atleta
inner join atividade a on a.id_atividade = s.id_atividade
inner join estado_atividade ea on ea.id_estado_atividade = a.id_estado_atividade
inner join equipa e on e.id_equipa = a.id_equipa
where ea.nome = 'realizada'
  and s.minutos_jogados > 0
group by u.nome, e.nome
having sum(s.golos) > 0
order by golos desc, golos_por_90 desc;

# Q12 Dados GPS: distância média e velocidade máxima por atleta (mínimo 3 jogos)
select e.nome equipa, u.nome,
       count(s.distancia_km) jogos_gps,
       avg(s.distancia_km) km_medio,
       max(s.velocidade_max_kmh) velocidade_maxima
from estatistica_jogo s
inner join atividade a on a.id_atividade = s.id_atividade
inner join estado_atividade ea on ea.id_estado_atividade = a.id_estado_atividade
inner join equipa e on e.id_equipa = a.id_equipa
inner join utilizador u on u.id_utilizador = s.id_atleta
where ea.nome = 'realizada'
  and s.minutos_jogados > 0
  and s.distancia_km is not null
group by e.nome, u.nome
having count(s.distancia_km) >= 3
order by e.nome, km_medio desc;

# Q13 Esforço médio por treino e número de atletas que responderam
select date_format(a.data_hora_inicio, '%d/%m') treino,
       e.nome equipa,
       count(r.id_resposta) respostas,
       avg(r.valor_numero) esforco_medio,
       min(r.valor_numero) minimo,
       max(r.valor_numero) maximo
from formulario f
inner join atividade a on a.id_atividade = f.id_atividade
inner join equipa e on e.id_equipa = a.id_equipa
inner join pergunta pg on pg.id_formulario = f.id_formulario and pg.ordem = 1
inner join resposta r on r.id_pergunta = pg.id_pergunta
group by f.id_formulario, a.data_hora_inicio, e.nome
order by a.data_hora_inicio, e.nome;

# Q14 Presenças registadas por QR e manualmente, por mês
select date_format(a.data_hora_inicio, '%Y-%m') mes,
       sum(case when p.metodo = 'qr' then 1 else 0 end) por_qr,
       sum(case when p.metodo = 'manual' then 1 else 0 end) manual,
       100 * sum(case when p.metodo = 'qr' then 1 else 0 end) / count(*) pct_qr
from presenca p
inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
inner join atividade a on a.id_atividade = p.id_atividade
where ep.nome = 'presente'
group by date_format(a.data_hora_inicio, '%Y-%m')
order by mes;

# Q15 Disponibilidade para a próxima atividade de cada equipa
select e.nome equipa,
       t.nome tipo,
       date_format(a.data_hora_inicio, '%d/%m %H:%i') atividade,
       (select count(*) from disponibilidade d
        where d.id_atividade = a.id_atividade and d.resposta = 'vou') vou,
       (select count(*) from disponibilidade d
        where d.id_atividade = a.id_atividade and d.resposta = 'nao_vou') nao_vou,
       (select count(*) from disponibilidade d
        where d.id_atividade = a.id_atividade and d.resposta = 'talvez') talvez,
       (select count(*) from inscricao i
        where i.id_equipa = a.id_equipa
          and i.data_entrada <= a.data_hora_inicio
          and (i.data_saida is null or a.data_hora_inicio < i.data_saida + interval 1 day)
          and i.id_atleta not in (select d.id_atleta from disponibilidade d
                                  where d.id_atividade = a.id_atividade)) sem_resposta
from atividade a
inner join equipa e on e.id_equipa = a.id_equipa
inner join tipo_atividade t on t.id_tipo_atividade = a.id_tipo_atividade
where a.data_hora_inicio = (select min(a2.data_hora_inicio)
                            from atividade a2
                            inner join estado_atividade e2 on e2.id_estado_atividade = a2.id_estado_atividade
                            where a2.id_equipa = a.id_equipa
                              and a2.data_hora_inicio > str_to_date('2026.11.06 12:00','%Y.%m.%d %H:%i')
                              and e2.nome <> 'cancelada')
order by a.data_hora_inicio;

# Q16 Atletas presentes no treino do formulário mais recente que ainda não responderam
select u.nome, e.nome equipa, f.titulo,
       date_format(a.data_hora_inicio, '%d/%m') treino,
       date_format(f.data_limite, '%d/%m %H:%i') prazo
from formulario f
inner join atividade a on a.id_atividade = f.id_atividade
inner join equipa e on e.id_equipa = a.id_equipa
inner join presenca p on p.id_atividade = a.id_atividade
inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
inner join utilizador u on u.id_utilizador = p.id_atleta
where ep.nome = 'presente'
  and f.data_criacao = (select max(f2.data_criacao)
                        from formulario f2
                        inner join atividade a2 on a2.id_atividade = f2.id_atividade
                        where a2.id_equipa = a.id_equipa)
  and p.id_atleta not in (select r.id_atleta
                          from resposta r
                          inner join pergunta pg on pg.id_pergunta = r.id_pergunta
                          where pg.id_formulario = f.id_formulario)
order by e.nome, u.nome;

# Q17 Atletas com assiduidade acima da média da sua equipa
select u.nome atleta, e.nome equipa, x.taxa taxa_presenca
from (select i1.id_equipa, i1.id_atleta,
             100 * sum(case when i1.id_atleta in (select p.id_atleta
                                                  from presenca p
                                                  inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
                                                  where p.id_atividade = a1.id_atividade and ep.nome = 'presente')
                            then 1 else 0 end) / count(*) taxa
      from inscricao i1
      inner join atividade a1 on a1.id_equipa = i1.id_equipa
      inner join estado_atividade ea1 on ea1.id_estado_atividade = a1.id_estado_atividade
      where ea1.nome = 'realizada'
        and a1.data_hora_inicio >= i1.data_entrada
        and (i1.data_saida is null or a1.data_hora_inicio < i1.data_saida + interval 1 day)
      group by i1.id_equipa, i1.id_atleta) x
inner join utilizador u on u.id_utilizador = x.id_atleta
inner join equipa e on e.id_equipa = x.id_equipa
where x.taxa > (select avg(y.taxa)
                from (select i2.id_equipa, i2.id_atleta,
                       100 * sum(case when i2.id_atleta in (select p.id_atleta
                                                            from presenca p
                                                            inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
                                                            where p.id_atividade = a2.id_atividade and ep.nome = 'presente')
                                      then 1 else 0 end) / count(*) taxa
                from inscricao i2
                inner join atividade a2 on a2.id_equipa = i2.id_equipa
                inner join estado_atividade ea2 on ea2.id_estado_atividade = a2.id_estado_atividade
                where ea2.nome = 'realizada'
                  and a2.data_hora_inicio >= i2.data_entrada
                  and (i2.data_saida is null or a2.data_hora_inicio < i2.data_saida + interval 1 day)
                group by i2.id_equipa, i2.id_atleta) y
                where y.id_equipa = x.id_equipa)
order by e.nome, x.taxa desc, u.nome;

# Q18 Atletas que já passaram por mais do que uma equipa nesta época
select u.nome,
       e.escalao,
       date_format(i.data_entrada, '%d/%m/%Y') entrada,
       ifnull(date_format(i.data_saida, '%d/%m/%Y'), 'atual') saida
from inscricao i
inner join equipa e on e.id_equipa = i.id_equipa
inner join utilizador u on u.id_utilizador = i.id_atleta
where i.id_atleta in (select id_atleta from inscricao
                      group by id_atleta
                      having count(distinct id_equipa) > 1)
order by u.nome, i.data_entrada;

# Q19 Jogo realizado com mais golos de cada equipa
select j.equipa, j.data_jogo, j.adversario, j.golos_marcados
from (select e.id_equipa, e.nome equipa, a.id_atividade,
             date_format(a.data_hora_inicio, '%d/%m/%Y') data_jogo,
             a.adversario, sum(s.golos) golos_marcados
      from estatistica_jogo s
      inner join atividade a on a.id_atividade = s.id_atividade
      inner join tipo_atividade t on t.id_tipo_atividade = a.id_tipo_atividade
      inner join estado_atividade ea on ea.id_estado_atividade = a.id_estado_atividade
      inner join equipa e on e.id_equipa = a.id_equipa
      where t.nome = 'jogo' and ea.nome = 'realizada'
      group by e.id_equipa, e.nome, a.id_atividade, a.data_hora_inicio, a.adversario) j
where j.golos_marcados = (select max(g.golos)
                          from (select a2.id_equipa, a2.id_atividade, sum(s2.golos) golos
                                from estatistica_jogo s2
                                inner join atividade a2 on a2.id_atividade = s2.id_atividade
                                inner join tipo_atividade t2 on t2.id_tipo_atividade = a2.id_tipo_atividade
                                inner join estado_atividade e2 on e2.id_estado_atividade = a2.id_estado_atividade
                                where t2.nome = 'jogo' and e2.nome = 'realizada'
                                group by a2.id_equipa, a2.id_atividade) g
                          where g.id_equipa = j.id_equipa)
order by j.equipa, j.data_jogo;

# Q20 Atletas que disseram «vou» e ficaram registados como «ausente»
select u.nome, e.nome equipa,
       t.nome tipo,
       date_format(a.data_hora_inicio, '%d/%m %H:%i') atividade
from disponibilidade d
inner join presenca p on p.id_atividade = d.id_atividade and p.id_atleta = d.id_atleta
inner join estado_presenca ep on ep.id_estado_presenca = p.id_estado_presenca
inner join atividade a on a.id_atividade = d.id_atividade
inner join tipo_atividade t on t.id_tipo_atividade = a.id_tipo_atividade
inner join equipa e on e.id_equipa = a.id_equipa
inner join utilizador u on u.id_utilizador = d.id_atleta
where d.resposta = 'vou'
  and ep.nome = 'ausente'
order by a.data_hora_inicio;

# Q21 Número de atividades e de jogos em cada local
select l.nome local,
       (select count(*) from atividade a
        where a.id_local = l.id_local) atividades,
       (select count(*) from atividade a
        inner join tipo_atividade t on t.id_tipo_atividade = a.id_tipo_atividade
        where a.id_local = l.id_local and t.nome = 'jogo') jogos
from local l
order by atividades desc;
