with 
    funcionarios as (
        select
            func_id,
            func_id_gerente,
            func_nome_completo,
            func_data_nascimento,
            func_data_contratacao,
            func_endereco,
            func_cidade,
            func_regiao,
            func_cep,
            func_pais,
            func_notas
        from
            {{ ref('stg_erp__funcionarios') }}
    ),

    self_join_gerentes as (
        select
            funcionarios.func_id                as id_funcionario,
            funcionarios.func_nome_completo     as nm_funcionario,
            gerentes.func_nome_completo         as nm_gerente,
            funcionarios.func_data_nascimento   as dt_nascimento,
            funcionarios.func_data_contratacao  as dt_contratacao,
            funcionarios.func_endereco          as ds_endereco,
            funcionarios.func_cidade            as ds_cidade,
            funcionarios.func_regiao            as ds_regiao,
            funcionarios.func_cep               as nr_cep,
            funcionarios.func_pais              as ds_pai,
            funcionarios.func_notas             as ds_notas
        from
            funcionarios            as funcionarios
            left join funcionarios  as gerentes
                on funcionarios.func_id_gerente = gerentes.func_id   
    ),

    transformacoes as (
        select
            row_number() over (order by id_funcionario) as sk_funcionario,
            *
        from
            self_join_gerentes
    )

select
    *
from
    transformacoes  