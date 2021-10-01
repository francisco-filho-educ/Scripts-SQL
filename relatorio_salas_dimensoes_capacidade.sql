/*
select
crede.nm_sigla,
tut.nr_codigo_unid_trab id_inep_escola,
tt.cd_unidade_trabalho id_escola_sige, 
tut.nm_unidade_trabalho nm_escola,
ci_ambiente codigo_sala,
tda.nr_area,
 round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) nr_cap_fisica,
 case when round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) >= 45 
 then 45 else round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) end nr_cap_fisica_alinhada
from dl_sige.tb_turma_2021 tt
join dl_sige.tb_ambiente tda on tda.ci_ambiente = tt.cd_ambiente
join dl_sige.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
join dl_sige.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
where tt.nr_anoletivo = 2021
and tda.fl_sala_de_aula = true
and tut.cd_dependencia_administrativa = 2
and tt.cd_prefeitura  = 0
group by 1,2,3,4,5,6
*/
select
crede.nm_sigla,
tut.nr_codigo_unid_trab id_inep_escola,
tt.cd_unidade_trabalho id_escola_sige, 
tut.nm_unidade_trabalho nm_escola,
ci_ambiente codigo_sala,
tda.nr_area,
round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) nr_cap_fisica,
case when round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) >= 45 
then 45 else round(COALESCE(tda.nr_area::numeric,0) / 1.2,0) end nr_cap_fisica_alinhada
from academico.tb_turma tt
join rede_fisica.tb_ambiente tda on tda.ci_ambiente = tt.cd_ambiente
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho
join rede_fisica.tb_unidade_trabalho crede on crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
where tt.nr_anoletivo = 2021
and tda.fl_sala_de_aula = true
and tut.cd_dependencia_administrativa = 2
and tt.cd_prefeitura  = 0
group by 1,2,3,4,5,6
