with aluno_turma as (
select 
nr_anoletivo,
cd_unidade_trabalho, 
concat(tta.nr_semestre,' Semestre') semestre,
ds_disciplina_atividade,
ds_codigo,
count(distinct tta.ci_turma_atividade)nr_turmas,
count(ue.cd_aluno) nr_alunos
from academico.tb_turma_atividade tta
left join academico.tb_enturmacao_atividade ue  on ue.cd_turma_atividade = tta.ci_turma_atividade
join academico.tb_disciplina_atividade da on da.ci_disciplina_atividade = tta.cd_disciplina_atividade
where tta.nr_anoletivo = 2020
and ds_codigo in('CHS045-A','EDH007')
--and da.ds_disciplina_atividade ilike '%cidada%'
and nr_semestre = 1
group by 1,2,3,4,5
),
esc as
(
select
tut.ci_unidade_trabalho,
crede.ci_unidade_trabalho id_crede, 
crede.nm_sigla nm_crede, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab inep_escola, 
tut.nm_unidade_trabalho nm_escola,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and tut.cd_categoria = 9
)
select
nr_anoletivo,
id_crede,
nm_crede,
nm_municipio,
nm_categoria,
inep_escola,
nm_escola,
ds_disciplina_atividade,
ds_codigo,
semestre,
nr_turmas,
coalesce(nr_alunos,0) nr_alunos
from esc join aluno_turma on ci_unidade_trabalho = cd_unidade_trabalho
ORDER BY 1,3,4,6
