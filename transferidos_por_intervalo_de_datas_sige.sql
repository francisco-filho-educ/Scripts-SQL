with movimento as (
select
tm.cd_aluno,
max(tm.ci_movimento) cd_movimento 
from academico.tb_movimento tm
where 
tm.nr_anoletivo =2021
and (tm.cd_tpmovimento = 4 or tm.cd_situacao = 6)
and tm.fl_tipo_atividade <> 'AC'
--and tm.cd_situacao = 6
and exists(select 1 from rede_fisica.tb_unidade_trabalho tut 
								where tut.ci_unidade_trabalho = tm.cd_unidade_trabalho_origem
								and tut.cd_dependencia_administrativa = 2

								and tut.cd_tipo_unid_trab = 401)
and tm.dt_criacao between '2021-05-25'::date and '2021-06-04'
group by 1
),--25 de maio a 04 de junho
trasferencia as (
select
tm.nr_anoletivo,
tm.cd_aluno,
tm.cd_unidade_trabalho_destino,
tm.cd_unidade_trabalho_origem,
tm.cd_ofertaitem_destino,
tm.cd_ofertaitem_origem,
to_char(tm.dt_criacao,'dd/mm/yyyy') dt_movimento 
from academico.tb_movimento tm
join movimento m  on tm.ci_movimento = m.cd_movimento
where 
tm.nr_anoletivo =2021
and tm.cd_unidade_trabalho_destino <> tm.cd_unidade_trabalho_origem
								--nd cd_unidade_trabalho_origem<>cd_unidade_trabalho_destino
) --select * from  trasferencia
, 
escola as (
SELECT 
tut.ci_unidade_trabalho cd_unidade_trabalho,
crede.ci_unidade_trabalho id_crede, 
crede.nm_sigla nm_crede, 
upper(tmc.ds_localidade) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_localidades tmc ON tmc.cd_inep = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
)
select
t.nr_anoletivo,
t.cd_aluno,
ta.nm_aluno,
to_char(ta.dt_nascimento,'dd/mm/yy')dt_nascimento,
--escola origem
eo.id_crede id_crede_o,
eo.nm_crede crede_o,
eo.nm_municipio municipio_o,
eo.id_escola_inep id_escola_inep_o, 
eo.nm_escola nm_escola_o,
eo.nm_categoria nm_categoria_o,
eoo.ds_ofertaitem ds_oferta_o,
--escola_destino
ed.id_crede id_crede_d,
ed.nm_crede crede_d,
ed.nm_municipio municipio_d,
ed.id_escola_inep id_escola_inep_d, 
ed.nm_escola nm_escola_d,
ed.nm_categoria nm_categoria_d,
edo.ds_ofertaitem ds_oferta_d,
dt_movimento 
from trasferencia t
join escola ed on t.cd_unidade_trabalho_destino = ed.cd_unidade_trabalho
join academico.tb_ofertaitens edo on edo.ci_ofertaitem = t.cd_ofertaitem_destino
join escola eo on t.cd_unidade_trabalho_origem = eo.cd_unidade_trabalho
join academico.tb_ofertaitens eoo on eoo.ci_ofertaitem = t.cd_ofertaitem_destino
join academico.tb_aluno ta on ta.ci_aluno = t.cd_aluno
where t.nr_anoletivo = 2021