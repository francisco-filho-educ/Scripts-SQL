with trasferencia as (
select
tm.cd_aluno,
tm.cd_unidade_trabalho_destino,
tm.cd_unidade_trabalho_origem,
tm.cd_ofertaitem_destino,
tm.cd_ofertaitem_origem
select count(1) --6359
from academico.tb_ultimomovimento tm
where 
tm.nr_anoletivo =2021
and tm.cd_tpmovimento = 4
and tm.fl_tipo_atividade <> 'AC'
and tm.cd_situacao = 6
and exists(select 1 from rede_fisica.tb_unidade_trabalho tut 
								where tut.ci_unidade_trabalho = tm.cd_unidade_trabalho_destino
								and tut.cd_dependencia_administrativa = 2
								and tut.cd_tipo_unid_trab = 401)
								--nd cd_unidade_trabalho_origem<>cd_unidade_trabalho_destino
), 
escola_destino as (
SELECT 
tut.ci_unidade_trabalho cd_unidade_trabalho,
crede.ci_unidade_trabalho id_crede, 
crede.nm_sigla nm_crede, 
upper(tmc.nm_municipio) AS nm_municipio_destino,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho nm_escola_destino
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
)
select
nr_anoletivo,
id_crede,
nm_crede,
nm_municipio_destino,
id_escola_inep, 
nm_escola_destino,
nm_categoria,
to2.ds_ofertaitem,
t.cd_aluno,
ta.nm_aluno,
to_char(ta.dt_nascimento,'dd/mm/yy')dt_nascimento,
tutd.nr_codigo_unid_trab id_escola_inep_origem,
tutd.nm_unidade_trabalho nm_escola_origem,
tmc.nm_municipio nm_munmicipio_origem
from trasferencia t
join escola_destino ed on t.cd_unidade_trabalho_destino = cd_unidade_trabalho
join academico.tb_ofertaitens to2 on to2.ci_ofertaitem = cd_ofertaitem_destino
join rede_fisica.tb_unidade_trabalho tutd on tutd.ci_unidade_trabalho = cd_unidade_trabalho_origem
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tutd.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join academico.tb_aluno ta on ta.ci_aluno = t.cd_aluno
where to2.nr_anoletivo = 2021

--select * from academico.tb_aee ta limit 1




