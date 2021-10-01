/* --CONTAGEM GERAL
with fund as (
select 
nr_anoletivo,
cd_unidade_trabalho
from academico.tb_turma tt 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where tt.nr_anoletivo = 2021
and cd_prefeitura = 0
and cd_nivel = 26
and tt.fl_tipo_seriacao =  'RG'
and tut.cd_dependencia_administrativa = 2
group by 1,2
), medio as (
select 
nr_anoletivo,
cd_unidade_trabalho
from academico.tb_turma tt 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where tt.nr_anoletivo = 2021
and cd_prefeitura = 0
and cd_nivel = 27
and tt.fl_tipo_seriacao =  'RG'
and tut.cd_dependencia_administrativa = 2
group by 1,2
),ex_fund as (
select 
nr_anoletivo, count(1) nr_exc_fund
from fund f
where not exists (select 1 from medio m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
group by 1
),ex_medio as (
select 
nr_anoletivo, count(1) nr_exc_medio
from medio f
where not exists (select 1 from fund m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
group by 1
),medio_fund as (
select 
nr_anoletivo, count(1) nr_fund_medio
from medio f
where exists (select 1 from fund m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
group by 1
)
select * from ex_fund
join ex_medio using(nr_anoletivo)
join medio_fund using(nr_anoletivo)
*/
with fund as (
select 
nr_anoletivo,
cd_unidade_trabalho
from academico.tb_turma tt 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where tt.nr_anoletivo = 2021
and cd_prefeitura = 0
and cd_nivel = 26
and tt.fl_tipo_seriacao =  'RG'
and tut.cd_dependencia_administrativa = 2
group by 1,2
), medio as (
select 
nr_anoletivo,
cd_unidade_trabalho
from academico.tb_turma tt 
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = tt.cd_unidade_trabalho 
where tt.nr_anoletivo = 2021
and cd_prefeitura = 0
and cd_nivel = 27
and tt.fl_tipo_seriacao =  'RG'
and tut.cd_dependencia_administrativa = 2
group by 1,2
),exc_medio as(
select 
nr_anoletivo, cd_unidade_trabalho
from medio f
where not exists (select 1 from fund m where m.cd_unidade_trabalho = f.cd_unidade_trabalho)
group by 1,2
)
SELECT -- lista as escolas ensino medio puro
nr_anoletivo,
crede.ci_unidade_trabalho, 
crede.nm_sigla, 
upper(tmc.nm_municipio) AS nm_municipio,
upper(tc.nm_categoria) AS nm_categoria
,tut.nr_codigo_unid_trab, 
tut.nm_unidade_trabalho,
upper(tlz.nm_localizacao_zona) AS nm_localizacao_zona,
m.*
FROM rede_fisica.tb_unidade_trabalho tut 
JOIN rede_fisica.tb_unidade_trabalho crede ON crede.ci_unidade_trabalho = tut.cd_unidade_trabalho_pai
JOIN rede_fisica.tb_local_unid_trab tlut ON tlut.cd_unidade_trabalho = tut.ci_unidade_trabalho
JOIN rede_fisica.tb_local_funcionamento tlf ON tlf.ci_local_funcionamento = tlut.cd_local_funcionamento
JOIN rede_fisica.tb_categoria tc ON tc.ci_categoria = tut.cd_categoria
JOIN rede_fisica.tb_localizacao_zona tlz ON tlz.ci_localizacao_zona = tlf.cd_localizacao_zona
JOIN util.tb_municipio_censo tmc ON tmc.ci_municipio_censo = tlf.cd_municipio_censo
join exc_medio m on m.cd_unidade_trabalho = tut.ci_unidade_trabalho 
WHERE tut.cd_dependencia_administrativa = 2
--AND tut.cd_situacao_funcionamento = 1
AND tut.cd_tipo_unid_trab = 401
AND tlut.fl_sede = TRUE 
and tut.cd_categoria =9
ORDER BY 1,3,4,6;

