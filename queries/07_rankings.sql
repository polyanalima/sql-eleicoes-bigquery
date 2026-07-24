/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
07_rankings.sql

Objetivo:
Criar rankings analíticos sobre candidatos, partidos,
institutos, estados e pesquisas eleitorais.

Análises realizadas:

- Ranking de candidatos;
- Ranking de partidos;
- Ranking de institutos;
- Ranking de estados;
- Ranking por cargo;
- Ranking por eleição.

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Ranking de candidatos por quantidade de pesquisas
-- =====================================================

SELECT

  nome_candidato,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY nome_candidato

ORDER BY quantidade_pesquisas DESC

LIMIT 20;



-- =====================================================
-- 2. Ranking de candidatos por média de percentual
-- =====================================================

SELECT

  ano,

  cargo,

  nome_candidato,

  ROUND(
    AVG(percentual),
    2
  ) AS media_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY

  ano,
  cargo,
  nome_candidato

ORDER BY

  media_percentual DESC

LIMIT 20;



-- =====================================================
-- 3. Ranking de candidatos por maior percentual registrado
-- =====================================================

SELECT

  ano,

  cargo,

  nome_candidato,

  MAX(percentual)
  AS maior_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY

  ano,
  cargo,
  nome_candidato

ORDER BY

  maior_percentual DESC

LIMIT 20;



-- =====================================================
-- 4. Ranking de partidos por quantidade de candidatos
-- =====================================================

SELECT

  sigla_partido,

  COUNT(DISTINCT nome_candidato)
  AS quantidade_candidatos


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE sigla_partido IS NOT NULL

GROUP BY sigla_partido

ORDER BY quantidade_candidatos DESC;



-- =====================================================
-- 5. Ranking de partidos por média de percentual
-- =====================================================

SELECT

  sigla_partido,

  ROUND(
    AVG(percentual),
    2
  ) AS media_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE sigla_partido IS NOT NULL

GROUP BY sigla_partido

ORDER BY media_percentual DESC;



-- =====================================================
-- 6. Ranking de institutos por quantidade de pesquisas
-- =====================================================

SELECT

  instituto,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE instituto IS NOT NULL

GROUP BY instituto

ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 7. Ranking de estados por quantidade de pesquisas
-- =====================================================

SELECT

  sigla_uf,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE sigla_uf IS NOT NULL

GROUP BY sigla_uf

ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 8. Ranking de municípios pesquisados
-- =====================================================

SELECT

  sigla_uf,

  nome_municipio,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_municipio IS NOT NULL

GROUP BY

  sigla_uf,
  nome_municipio

ORDER BY quantidade_pesquisas DESC

LIMIT 30;



-- =====================================================
-- 9. Ranking de cargos por quantidade de pesquisas
-- =====================================================

SELECT

  cargo,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas


FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY cargo

ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 10. Ranking de eleições por volume de pesquisas
-- =====================================================

SELECT

  ano,

  cargo,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas,


  SUM(quantidade_entrevistas)
  AS total_entrevistas


FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY

  ano,
  cargo

ORDER BY

  quantidade_pesquisas DESC;



-- =====================================================
-- 11. Top candidatos por estado
-- =====================================================
-- Ranking usando Window Function

WITH candidatos_estado AS (

SELECT

  sigla_uf,

  nome_candidato,

  AVG(percentual)
  AS media_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY

  sigla_uf,
  nome_candidato

)


SELECT

  sigla_uf,

  nome_candidato,

  ROUND(media_percentual,2)
  AS media_percentual,


  RANK() OVER(

    PARTITION BY sigla_uf

    ORDER BY media_percentual DESC

  ) AS ranking_estado


FROM candidatos_estado;
