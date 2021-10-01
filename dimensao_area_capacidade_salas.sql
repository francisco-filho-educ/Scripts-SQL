--Areas e capacidade de salas de aulas em uso (associado a uma turma)
with escola_ambiente as (
select 
cd_unidade_trabalho,
cd_ambiente
from academico.tb_turma tt
where
tt.nr_anoletivo = 2021
and tt.cd_prefeitura = 0
group by 1,2
)
select
crede.nm_sigla,
tut.nr_codigo_unid_trab id_inep_escola,
tt.cd_unidade_trabalho id_escola_sige, 
tut.nm_unidade_trabalho nm_escola,
ci_ambiente cd_ambiente,
tda.nr_area,
round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) nr_cap_fisica,
case when round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) >= 45 
then 45 else round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) end nr_cap_fisica_alinhada
--select tt.cd_unidade_trabalho, count(1) nr_linha, count(distinct ci_ambiente) nr_sala
from escola_ambiente tt
join rede_fisica.tb_ambiente tda on tda.ci_ambiente = tt.cd_ambiente
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
join rede_fisica.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
where 
tda.fl_sala_de_aula = true
and tut.cd_dependencia_administrativa = 2


