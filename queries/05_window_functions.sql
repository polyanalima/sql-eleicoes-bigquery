/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
05_window_functions.sql

Objetivo:
Aplicar funções analíticas (Window Functions) para
analisar rankings, evolução temporal e comparações
entre candidatos nas pesquisas eleitorais.

Funções utilizadas:

- RANK()
- DENSE_RANK()
- ROW_NUMBER()
- LAG()
- LEAD()
- FIRST_VALUE()
- LAST_VALUE()
- AVG() OVER()
- QUALIFY

Observações:
A análise considera:
- ano eleitoral;
- cargo;
- candidato;
- pesquisa;
- cenário.

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Ranking dos candidatos dentro de cada pesquisa
-- =====================================================
-- Mostra a posição dos candidatos em cada pesquisa
-- separando por ano e cargo

SELECT
  ano,
  cargo,
  id_pesquisa,
  nome_candidato,
  percentual,

  RANK() OVER(
    PARTITION BY ano, cargo, id_pesquisa
    ORDER BY percentual DESC
  ) AS ranking

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 2. Ranking dos candidatos dentro de cada cenário
-- =====================================================

SELECT
  ano,
  cargo,
  id_cenario,
  nome_candidato,
  percentual,

  DENSE_RANK() OVER(
    PARTITION BY ano, cargo, id_cenario
    ORDER BY percentual DESC
  ) AS ranking_cenario

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 3. Primeiro colocado em cada pesquisa
-- =====================================================
-- Utilizando ROW_NUMBER para retornar apenas um registro

SELECT *

FROM (

  SELECT
    ano,
    cargo,
    id_pesquisa,
    nome_candidato,
    sigla_partido,
    percentual,

    ROW_NUMBER() OVER(
      PARTITION BY ano, cargo, id_pesquisa
      ORDER BY percentual DESC
    ) AS posicao

  FROM `basedosdados.br_poder360_pesquisas.microdados`

  WHERE nome_candidato IS NOT NULL

)

WHERE posicao = 1;



-- =====================================================
-- 4. Comparação com a pesquisa anterior
-- =====================================================
-- Mostra o percentual anterior do candidato

SELECT
  ano,
  cargo,
  nome_candidato,
  data,
  percentual,

  LAG(percentual) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
  ) AS percentual_anterior

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 5. Variação de percentual entre pesquisas
-- =====================================================
-- Calcula crescimento ou queda

SELECT
  ano,
  cargo,
  nome_candidato,
  data,
  percentual,

  percentual -
  LAG(percentual) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
  ) AS variacao_percentual

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 6. Próxima pesquisa do candidato
-- =====================================================
-- Utilizando LEAD

SELECT
  ano,
  cargo,
  nome_candidato,
  data,
  percentual,

  LEAD(data) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
  ) AS proxima_data,

  LEAD(percentual) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
  ) AS proximo_percentual

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 7. Média móvel do percentual do candidato
-- =====================================================
-- Suaviza oscilações entre pesquisas

SELECT
  ano,
  cargo,
  nome_candidato,
  data,
  percentual,

  ROUND(
    AVG(percentual) OVER(
      PARTITION BY ano, cargo, nome_candidato
      ORDER BY data
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ),
    2
  ) AS media_movel

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 8. Ranking dos partidos dentro de cada pesquisa
-- =====================================================

WITH partidos AS (

SELECT
  ano,
  cargo,
  id_pesquisa,
  sigla_partido,

  AVG(percentual) AS media_percentual

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE sigla_partido IS NOT NULL

GROUP BY
  ano,
  cargo,
  id_pesquisa,
  sigla_partido

)

SELECT
  *,
  
  RANK() OVER(
    PARTITION BY ano, cargo, id_pesquisa
    ORDER BY media_percentual DESC
  ) AS ranking_partido

FROM partidos;



-- =====================================================
-- 9. Primeiro e último percentual registrado
-- =====================================================

SELECT
  ano,
  cargo,
  nome_candidato,
  data,
  percentual,

  FIRST_VALUE(percentual) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
  ) AS primeiro_percentual,


  LAST_VALUE(percentual) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND UNBOUNDED FOLLOWING
  ) AS ultimo_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 10. Líder de cada pesquisa usando QUALIFY
-- =====================================================
-- Forma recomendada no BigQuery

SELECT
  ano,
  cargo,
  id_pesquisa,
  nome_candidato,
  sigla_partido,
  percentual

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

QUALIFY

RANK() OVER(
  PARTITION BY ano, cargo, id_pesquisa
  ORDER BY percentual DESC
) = 1;



-- =====================================================
-- 11. Evolução do candidato comparando primeira
-- e última pesquisa
-- =====================================================

WITH evolucao AS (

SELECT
  ano,
  cargo,
  nome_candidato,

  FIRST_VALUE(percentual) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
  ) AS primeiro_percentual,


  LAST_VALUE(percentual) OVER(
    PARTITION BY ano, cargo, nome_candidato
    ORDER BY data
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND UNBOUNDED FOLLOWING
  ) AS ultimo_percentual

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

)

SELECT DISTINCT
  ano,
  cargo,
  nome_candidato,
  primeiro_percentual,
  ultimo_percentual,

  ultimo_percentual - primeiro_percentual
  AS variacao_total

FROM evolucao;
