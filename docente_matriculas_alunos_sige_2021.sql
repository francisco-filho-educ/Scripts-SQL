with doc as (
select
tt.cd_unidade_trabalho,
count(distinct cpf) nr_docente
from  academico.tb_turma tt
join lotacaocoave.mvw_coave_turmas_presenciais lt on lt.ci_turma = tt.ci_turma
join lotacaocoave.mvw_coave_docentes dl on dl.cd_vinculo = lt.cd_vinculo
join rede_fisica.tb_unidade_trabalho tut2 on tut2.ci_unidade_trabalho = tt.cd_unidade_trabalho and tut2.cd_dependencia_administrativa = 2
where 
tt.nr_anoletivo::int = 2021
and tt.cd_prefeitura::int = 0
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
and tt.fl_tipo_seriacao <>'AC'
group by 1
), mat as(
select 
tu.nr_anoletivo,
tt.cd_unidade_trabalho, 
count(1) nr_matricula
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma 
where tt.nr_anoletivo = 2021
and tu.fl_tipo_atividade <>'AC'
and tt.cd_prefeitura = 0
and tt.cd_nivel in (26,27,28)
group by 1,2
)
SELECT 
nr_anoletivo,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
sum(nr_docente) nr_docente,
sum(nr_matricula)nr_matricula
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
join doc on tut.ci_unidade_trabalho = doc.cd_unidade_trabalho
join mat on tut.ci_unidade_trabalho = mat.cd_unidade_trabalho
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
group by 1,2
