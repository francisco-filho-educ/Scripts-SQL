with qualif as (
select
ci_turma,
1 fl_qualifica
from  academico.tb_turma tt 
join academico.tb_turmadisciplina ttd on ttd.cd_turma = tt.ci_turma 
join academico.tb_disciplinas td on td.ci_disciplina = ttd.cd_disciplina 
where 
tt.nr_anoletivo::int = 2021
and tt.cd_prefeitura::int = 0
and tt.fl_tipo_seriacao = 'RG'
and cd_nivel = 27
and tt.cd_turno = 2
and cd_etapa in (163,162,164)
and td.fl_tipo = 'P' 
group by 1,2
),
mat as(
select 
cd_unidade_trabalho,
count(1) total,
sum(case when fl_qualifica is null then 1 else 0 end) mat_sq,
sum(case when cd_etapa = 162 and fl_qualifica is null then 1 else 0 end) mat_1s_sq,
sum(case when cd_etapa = 163 and fl_qualifica is null then 1 else 0 end) mat_2s_sq,
sum(case when cd_etapa = 164 and fl_qualifica is null then 1 else 0 end) mat_3s_sq,
sum(case when fl_qualifica =1 then 1 else 0 end) mat_qualif,
sum(case when cd_etapa = 162 and fl_qualifica =1 then 1 else 0 end) mat_1s_qualif,
sum(case when cd_etapa = 163 and fl_qualifica =1  then 1 else 0 end) mat_2s_qualif,
sum(case when cd_etapa = 164 and fl_qualifica =1  then 1 else 0 end) mat_3s_qualif
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = cd_turma
join academico.tb_etapa te on te.ci_etapa = cd_etapa
left join qualif using(ci_turma)
where cd_prefeitura =0
and tu.fl_tipo_atividade <>'AC'
and cd_nivel = 27
and cd_etapa in (163,162,164)
and tt.cd_turno = 2
group by 1
) 
SELECT 
crede.ci_unidade_trabalho, 
crede.nm_sigla, 
upper(tmc.ds_localidade) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab, 
tut.nm_unidade_trabalho,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
mat.*
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_localidades tmc ON tmc.cd_inep = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and tut.cd_categoria =9
ORDER BY 1,3,4,6;