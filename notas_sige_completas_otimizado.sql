with turmas as (
select * from academico.tb_turma tt
where tt.nr_anoletivo::int = 2016
and tt.cd_prefeitura::int = 0
and tt.cd_nivel= 27
and  tt.cd_etapa in (184,185,186) and cd_unidade_trabalho = 34
),
ultimaenturmacao as (
select cd_aluno,cd_turma 
from academico.tb_ultimaenturmacao tu 
where 
exists (select 1 from turmas where cd_turma = ci_turma)
and tu.fl_tipo_atividade <> 'AC'
),
turma_disciplina as (
select 
tt2.cd_turma,
tt2.cd_disciplina
from academico.tb_turmadisciplina tt2 
where exists (select 1 from turmas where tt2.cd_turma = ci_turma)
),notas as (
select
cd_aluno,
cd_turma,
cd_disciplina,
cd_periodo bimestre,
ta.nr_nota nota
from academico.tb_alunoavaliacao ta 
where exists (select 1 from ultimaenturmacao ut where ut.cd_turma = ta.cd_turma 
                           and ut.cd_aluno = ta.cd_aluno)
),
alunos as (
select ci_aluno cd_aluno, nm_aluno,nr_cpf cpf from academico.tb_aluno ta2 
where exists (select 1 from ultimaenturmacao where cd_aluno = ci_aluno )
) 
select 
nr_anoletivo,
tut.nr_codigo_unid_trab id_inep_escola,
tut.nm_unidade_trabalho nm_escola,
ttd.cd_turma,
ds_ofertaitem,
a.*,
ttd.cd_disciplina,
td.ds_disciplina,
tg.ds_grupodisciplina nome_disciplina_base_comum,
bimestre,
nota
from turmas t
inner join ultimaenturmacao ut on ut.cd_turma = ci_turma
join alunos a on a.cd_aluno = ut.cd_aluno
inner join turma_disciplina ttd on ttd.cd_turma = ci_turma
left join notas n on ut.cd_aluno = n.cd_aluno and n.cd_turma = ut.cd_turma and n.cd_disciplina =ttd.cd_disciplina 
join academico.tb_disciplinas td on td.ci_disciplina = ttd.cd_disciplina 
left join academico.tb_grupodisciplina tg on tg.ci_grupodisciplina = td.cd_grupodisciplina
join rede_fisica.tb_unidade_trabalho tut on tut.ci_unidade_trabalho = t.cd_unidade_trabalho 

