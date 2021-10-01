with escola as (
select 
tut.ci_unidade_trabalho,
tut.cd_unidade_trabalho_pai id_crede_sefor,
crede.nm_sigla nm_crede_sefor,
tmc.ci_municipio_censo,
tmc.nm_municipio,
'Estadual' ds_dependencia,
tut.nr_codigo_unid_trab id_escola,
tut.nm_unidade_trabalho nm_escola,
tc.nm_categoria 
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
)
select 
e. *,
tt.ds_turma,
tt.ds_ofertaitem,
ta.ci_aluno cd_aluno_sige,
ta.nm_aluno,
to_char(ta.dt_nascimento::date,'dd/mm/yyyy') dt_nascimento,
ta.nm_mae,
ta.ds_nacionalidade,
tp.ds_pais pais_origem
from academico.tb_ultimaenturmacao tu 
join academico.tb_turma tt on tt.ci_turma = tu.cd_turma and tt.nr_anoletivo = tu.nr_anoletivo 
join academico.tb_aluno ta on ta.ci_aluno = tu.cd_aluno 
join academico.tb_pais tp on tp.ci_pais = ta.cd_pais_origem
join escola e on e.ci_unidade_trabalho = tt.cd_unidade_trabalho
where 
tt.nr_anoletivo = 2021
and ta.ds_nacionalidade is not null 
and ta.ds_nacionalidade <> 'Brasileira'
and ta.cd_pais_origem <> 3034
and tt.cd_prefeitura = 0
order by id_crede_sefor, nm_municipio,nm_escola,nm_aluno


