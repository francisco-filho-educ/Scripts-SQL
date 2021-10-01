with mat as (
select 
tt.nr_anoletivo,
tt.cd_unidade_trabalho,
--TOTAL
count(1) total,
--Baixa Visão
sum(case when tad.cd_deficiencia = 2 then 1 else 0 end) baixa_visao,
--Cegueira
sum(case when tad.cd_deficiencia = 1 then 1 else 0 end) cegueira,
--Deficiência Auditiva
sum(case when tad.cd_deficiencia = 4 then 1 else 0 end) def_auditiva,
--Deficiência Física
sum(case when tad.cd_deficiencia = 6 then 1 else 0 end) def_fisica,
--Surdez
sum(case when tad.cd_deficiencia = 3 then 1 else 0 end) surdez,
--Surdocegueira
sum(case when tad.cd_deficiencia = 5 then 1 else 0 end) surdocegueira,
--Deficiência Intelectual
sum(case when tad.cd_deficiencia = 7 then 1 else 0 end) def_intelectual,
--Deficiência Múltipla
sum(case when tad.cd_deficiencia = 8 then 1 else 0 end) def_multipla,
--Autismo
sum(case when tad.cd_deficiencia between 9 and 12 then 1 else 0 end) autismo,
--Altas habilidades/ superdotação
sum(case when tad.cd_deficiencia = 13 then 1 else 0 end) def_fisica
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma and tt.nr_anoletivo = tu.nr_anoletivo 
join academico.tb_aluno_deficiencia tad on tad.cd_aluno = tu.cd_aluno 
where
tu.nr_anoletivo = 2021
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tu.fl_tipo_atividade <> 'AC'
and cd_etapa <>137
group by 1,2
)
SELECT 
crede.ci_unidade_trabalho, 
crede.nm_sigla, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab, 
tut.nm_unidade_trabalho,
--upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
mat.*
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
--JOIN util.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN public.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--and tut.cd_categoria =9
ORDER BY 1,3,4,6;