/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
06_analise_temporal.sql

Objetivo:
Analisar a evolução temporal das pesquisas eleitorais,
considerando ano, data, cargo e candidatos.

Análises realizadas:

- Distribuição de pesquisas por ano;
- Evolução mensal;
- Intervalo entre pesquisas;
- Primeira e última pesquisa;
- Tendência de percentual;
- Comparação temporal por candidato.

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Quantidade de pesquisas por ano
-- =====================================================

SELECT
  ano,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 2. Quantidade de pesquisas por mês
-- =====================================================

SELECT
  ano,
  EXTRACT(MONTH FROM data) AS mes,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE data IS NOT NULL

GROUP BY
  ano,
  mes

ORDER BY
  ano,
  mes;



-- =====================================================
-- 3. Pesquisas por trimestre
-- =====================================================

SELECT
  ano,

  EXTRACT(QUARTER FROM data) AS trimestre,

  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE data IS NOT NULL

GROUP BY
  ano,
  trimestre

ORDER BY
  ano,
  trimestre;



-- =====================================================
-- 4. Primeira e última pesquisa de cada ano
-- =====================================================

SELECT
  ano,

  MIN(data) AS primeira_pesquisa,

  MAX(data) AS ultima_pesquisa

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE data IS NOT NULL

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 5. Intervalo médio entre pesquisas
-- =====================================================
-- Analisa a frequência das pesquisas

WITH datas AS (

SELECT DISTINCT
  ano,
  id_pesquisa,
  data

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE data IS NOT NULL

),

intervalos AS (

SELECT

  ano,
  data,

  DATE_DIFF(
    data,
    LAG(data) OVER(
      PARTITION BY ano
      ORDER BY data
    ),
    DAY
  ) AS dias_desde_ultima

FROM datas

)

SELECT
  ano,
  ROUND(AVG(dias_desde_ultima),2)
  AS media_dias_entre_pesquisas

FROM intervalos

WHERE dias_desde_ultima IS NOT NULL

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 6. Evolução da média de intenção de voto por ano
-- =====================================================

SELECT
  ano,

  ROUND(
    AVG(percentual),
    2
  ) AS media_percentual

FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 7. Evolução mensal dos candidatos
-- =====================================================

SELECT

  ano,

  EXTRACT(MONTH FROM data) AS mes,

  nome_candidato,

  ROUND(
    AVG(percentual),
    2
  ) AS media_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY

  ano,
  mes,
  nome_candidato

ORDER BY

  ano,
  mes,
  media_percentual DESC;



-- =====================================================
-- 8. Crescimento ou queda dos candidatos ao longo do ano
-- =====================================================

WITH medias AS (

SELECT

  ano,

  nome_candidato,

  EXTRACT(MONTH FROM data) AS mes,

  AVG(percentual) AS percentual_medio


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY

  ano,
  nome_candidato,
  mes

)


SELECT

  ano,

  nome_candidato,

  mes,

  percentual_medio,


  percentual_medio -

  LAG(percentual_medio) OVER(

    PARTITION BY ano, nome_candidato

    ORDER BY mes

  ) AS variacao_mensal


FROM medias;



-- =====================================================
-- 9. Distribuição das pesquisas por cargo ao longo do tempo
-- =====================================================

SELECT

  ano,

  cargo,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas


FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY

  ano,
  cargo

ORDER BY

  ano,
  quantidade_pesquisas DESC;



-- =====================================================
-- 10. Última pesquisa disponível por candidato
-- =====================================================

SELECT *

FROM (

SELECT

  ano,

  cargo,

  nome_candidato,

  data,

  percentual,


  ROW_NUMBER() OVER(

    PARTITION BY ano, cargo, nome_candidato

    ORDER BY data DESC

  ) AS ordem


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

)

WHERE ordem = 1;
