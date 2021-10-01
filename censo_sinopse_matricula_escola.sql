select 
nr_ano_censo,
id_crede_sefor,
nm_crede_sefor,
ds_orgao_regional,
nm_municipio,
ds_dependencia,
ds_localizacao,
id_escola_inep,
nm_escola,
ds_categoria_escola_sige,
sum(nr_matriculas) mat_total,
sum (case when fl_regular = 1 then nr_matriculas else 0 end) reg_total,
--infantil
sum (case when cd_classe = 1 and fl_regular = 1 and cd_etapa = 1 then nr_matriculas else 0 end) reg_et_1,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_etapa_fase = 1 then nr_matriculas else 0 end) et_fase_1,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_etapa_fase = 2 then nr_matriculas else 0 end) et_fase_2,
--ensino fundamental
sum (case when cd_classe = 1 and fl_regular = 1 and cd_etapa = 2 then nr_matriculas else 0 end) reg_et_2,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_etapa_fase = 3 then nr_matriculas else 0 end) et_fase_3,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_etapa_fase = 4 then nr_matriculas else 0 end)et_fase_4,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 1 then nr_matriculas else 0 end) as_1,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 2 then nr_matriculas else 0 end) as_2,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 3 then nr_matriculas else 0 end) as_3,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 4 then nr_matriculas else 0 end) as_4,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 5 then nr_matriculas else 0 end) as_5,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 6 then nr_matriculas else 0 end) as_6,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 7 then nr_matriculas else 0 end) as_7,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 8 then nr_matriculas else 0 end) as_8,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 9 then nr_matriculas else 0 end) as_9,
--ensino médio
sum (case when cd_classe = 1 and fl_regular = 1 and cd_etapa = 3 then nr_matriculas else 0 end) reg_et_3,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_oferta_medio = 1 then nr_matriculas else 0 end) medio_1, --propedeutico
sum (case when cd_classe = 1 and fl_regular = 1 and cd_oferta_medio = 2 then nr_matriculas else 0 end) medio_2, --integrado ed prof
sum (case when cd_classe = 1 and fl_regular = 1 and cd_oferta_medio = 3 then nr_matriculas else 0 end) medio_3, --magisterio
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 9 then nr_matriculas else 0 end) as_10,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 9 then nr_matriculas else 0 end) as_11,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 9 then nr_matriculas else 0 end) as_12,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 9 then nr_matriculas else 0 end) as_13,
sum (case when cd_classe = 1 and fl_regular = 1 and cd_ano_serie = 9 then nr_matriculas else 0 end) as_14,
--educação especial
sum (case when cd_classe = 2 then nr_matriculas else 0 end) classe_2,--especial
sum (case when cd_classe = 1 then nr_matriculas else 0 end) classe_1,--especial
--ejas
sum (case when cd_classe = 1 and fl_eja= 1 then nr_matriculas else 0 end) eja_total,
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 2 then nr_matriculas else 0 end) eja_et_2_t, --total eja fund
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 2 and cd_mediacao = 1 then nr_matriculas else 0 end) eja_et_2_mp_1,
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 2 and cd_mediacao = 2 then nr_matriculas else 0 end)eja_et_2_mp_2,
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 2 and cd_mediacao = 3 then nr_matriculas else 0 end)eja_et_2_mp_3,
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 3 then nr_matriculas else 0 end) eja_et_3_t,--total eja medio
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 3 and cd_mediacao = 1 then nr_matriculas else 0 end) eja_et_3_mp_1,
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 3 and cd_mediacao = 2 then nr_matriculas else 0 end)eja_et_3_mp_2,
sum (case when cd_classe = 1 and fl_eja= 1 and cd_etapa = 3 and cd_mediacao = 3 then nr_matriculas else 0 end)eja_et_3_mp_3,
sum (case when cd_classe = 1 and cd_etapa_ensino in (39,40,68) then nr_matriculas else 0 end) prof_total,
sum (case when cd_classe = 1 and cd_etapa_ensino in (39,40) then nr_matriculas else 0 end) tec_c_s,
sum (case when cd_classe = 1 and cd_etapa_ensino = 68 then nr_matriculas else 0 end) fic_c_s
from dw_censo.tb_cubo_matricula tcm 
where 
nr_ano_censo = 2019
and cd_etapa in (1,2,3,4)
and id_municipio = 2304400
group by 1,2,3,4,5,6,7,8,9,10