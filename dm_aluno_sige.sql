with mult as(
select
tm.nr_anoletivo,
tm.cd_turma id_turma_sige,
ti.cd_nivel cd_nivel,
ti.cd_etapa cd_etapa_sige,
te2.ds_etapa,
1 fl_multseriado,
tm.cd_aluno
from academico.tb_aluno_multiseriacao tm
join academico.tb_turma t on tm.cd_turma = ci_turma
join academico.tb_item ti on tm.cd_item=ti.ci_item
join academico.tb_etapa te2 on te2.ci_etapa = ti.cd_etapa 
where 
t.nr_anoletivo = 2021
and t.cd_prefeitura  = 0
), 
outras as (
select
tt.nr_anoletivo,
tu.cd_turma id_turma_sige,
cd_nivel cd_nivel,
tt.cd_etapa cd_etapa_sige,
ds_etapa,
0 fl_multseriado,
tu.cd_aluno
from academico.tb_ultimaenturmacao tu
join academico.tb_turma tt on tu.cd_turma = ci_turma
join academico.tb_etapa te on te.ci_etapa = tt.cd_etapa 
where 
tt.nr_anoletivo = 2021
and tt.cd_prefeitura  = 0
and not exists (select 1 from mult where tu.cd_aluno = mult.cd_aluno)
),
aluno_etapa as(
select * from mult
union
select * from outras
), etapas_padronizadas as(
select
nr_anoletivo,
id_turma_sige,
cd_nivel,
cd_etapa_sige,
ds_etapa ds_etapa_sige,
fl_multseriado,
case when cd_etapa_sige in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 1
	  when cd_etapa_sige in (213,214,195,194,175,196,174,173)  then 2 else 99 end cd_oferta_ensino,
      
case when cd_etapa_sige in (121,122,123,124,125,126,127,128,129,183,162,184,188,163,185,189,164,186,190,165,187,191,180,181)
      									             then 'Ensino Regular'
when cd_etapa_sige in (213,214,195,194,175,196,174,173)  then 'EJA' else 'N?o se aplica' end ds_oferta_ensino,
case when cd_nivel = 28 then 1
     when cd_nivel = 26 then 2
     when cd_nivel = 27 and cd_etapa_sige<>137 then 3 else 99 end cd_etapa_aluno,
case when cd_nivel = 28 then 'Educa??o Infantil'
     when cd_nivel = 26 then 'Ensino Fundamental'
     when cd_nivel = 27 and cd_etapa_sige<>137 then 'Ensino M?dio' else 'N?o se aplica' end ds_etapa_aluno,
case when cd_etapa_sige in (121,122,123,124,125,172,194) then 1
     when cd_etapa_sige in (126,127,128,129,174,195)     then 2
     when cd_etapa_sige  = 175                           then 3 else 99 end cd_subetapa,
case when cd_etapa_sige in (121,122,123,124,125,172,194) then 'Anos Iniciais'
     when cd_etapa_sige in (126,127,128,129,174,195)     then 'Anos Finais'
     when cd_etapa_sige  = 175                           then 'Anos Iniciais e Anos Finais' else 'N?o se aplica' end ds_subetapa,
case 
     when cd_etapa_sige = 121 then 1
     when cd_etapa_sige = 122 then 2
     when cd_etapa_sige = 123 then 3
     when cd_etapa_sige = 124 then 4
     when cd_etapa_sige = 125 then 5
     when cd_etapa_sige = 126 then 6
     when cd_etapa_sige = 127 then 7
     when cd_etapa_sige = 128 then 8
     when cd_etapa_sige = 129 then 9
     when cd_etapa_sige in(162,184,188) then 10
     when cd_etapa_sige in(163,185,189) then 11
     when cd_etapa_sige in(164,186,190) then 12
     when cd_etapa_sige in(165,187,191) then 13 else 99 end cd_ano_serie,
case 
     when cd_etapa_sige = 121 then ' 1? Ano'
     when cd_etapa_sige = 122 then ' 2? Ano'
     when cd_etapa_sige = 123 then ' 3? Ano'
     when cd_etapa_sige = 124 then ' 4? Ano'
     when cd_etapa_sige = 125 then ' 5? Ano'
     when cd_etapa_sige = 126 then ' 6? Ano'
     when cd_etapa_sige = 127 then ' 7? Ano'
     when cd_etapa_sige = 128 then ' 8? Ano'
     when cd_etapa_sige = 129 then ' 9? Ano'
     when cd_etapa_sige in(162,184,188) then '1? S?rie'
     when cd_etapa_sige in(163,185,189) then '2? S?rie'
     when cd_etapa_sige in(164,186,190) then '3? S?rie'
     when cd_etapa_sige in(165,187,191) then '4? S?rie' else 'N?o se aplica' end ds_ano_serie,
cd_aluno
from aluno_etapa
)
select * from etapas_padronizadas



