-- CPF, matrícula e nome dos alunos da 3ª série do Ensino Médio de 2015 até 2019
with mat as (
select 
tt.cd_unidade_trabalho,
tt.nr_anoletivo,
tt.ds_ofertaitem,
cd_aluno,
ta.nm_aluno,
ta.dt_nascimento,
ta.nr_cpf
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma 
join academico.tb_aluno ta on ta.ci_aluno = tu.cd_aluno 
where cd_nivel = 27
and tt.nr_anoletivo between 2015 and 2019
and cd_etapa in(164,186,190)
and tu.fl_tipo_atividade <>'AC'
and tt.cd_prefeitura =0
)
SELECT 
nr_anoletivo,
crede.nm_sigla, 
upper(tl.ds_localidade) AS nm_municipio,
tut.nr_codigo_unid_trab id_escola_inep, 
tut.nm_unidade_trabalho,
ds_ofertaitem,
cd_aluno,
nm_aluno,
dt_nascimento,
nr_cpf
--select count(1)
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
--JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join util.tb_localidades tl on tl.cd_inep = tlf.cd_municipio_censo
join mat on mat.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
--ORDER BY 1,3,4,6;