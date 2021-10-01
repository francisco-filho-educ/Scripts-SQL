select 
nu_ano_censo,	
id_municipio,	
nm_municipio,	
case when tp_dependencia = 1 then 'Federal'
      when tp_dependencia = 2 then 'Estadual'
      when tp_dependencia = 3 then 'Municipal'
      when tp_dependencia = 4 then 'Privada' end ds_dependencia, 
sum(case when cd_ano_serie = 2 then 1 else 0 end) nr_2,
sum(case when cd_ano_serie = 5 then 1 else 0 end) nr_5,
sum(case when cd_ano_serie = 9 then 1 else 0 end) nr_9
from censo_esc_ce.tb_matricula tm 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
join dw_censo.tb_dm_etapa e on e.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
nu_ano_censo = 2019
and cd_etapa = 2
and cd_ano_serie in (2,5,9)
and tp_dependencia in (2,3)
group by 1,2,3,4
union 
select 
nu_ano_censo,	
id_municipio,	
nm_municipio,	
case when tp_dependencia = 1 then 'Federal'
      when tp_dependencia = 2 then 'Estadual'
      when tp_dependencia = 3 then 'Municipal'
      when tp_dependencia = 4 then 'Privada' end ds_dependencia, 
sum(case when cd_ano_serie = 2 then 1 else 0 end) nr_2,
sum(case when cd_ano_serie = 5 then 1 else 0 end) nr_5,
sum(case when cd_ano_serie = 9 then 1 else 0 end) nr_9
from censo_esc_ce.tb_matricula_2007_2018 tm 
join dw_censo.tb_dm_municipio tdm on tdm.id_municipio = tm.co_municipio 
join dw_censo.tb_dm_etapa e on e.cd_etapa_ensino = tm.tp_etapa_ensino 
where 
nu_ano_censo = 2018
and cd_etapa = 2
and cd_ano_serie in (2,5,9)
and tp_dependencia in (2,3)
group by 1,2,3,4



select 
count(1) total,
sum(case when tp_dependencia <> 4 then 1 else 0 end) nr_publica,
sum(case when tp_dependencia not in (4,1) then 1 else 0 end)::numeric / count(1)::numeric *100 per_escola


select 
nu_ano_censo,		
case when tp_dependencia = 1 then 'Federal'
      when tp_dependencia = 2 then 'Estadual'
      when tp_dependencia = 3 then 'Municipal'
      when tp_dependencia = 4 then 'Privada' end ds_dependencia,
 count(1) total
from censo_esc_ce.tb_matricula tm
where
nu_ano_censo = 2020
and tp_etapa_ensino is not null
group by 1,2
