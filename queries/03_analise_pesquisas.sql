/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
03_analise_pesquisas.sql

Objetivo:
Realizar análises gerais sobre as pesquisas eleitorais,
considerando período, cargo, localização, institutos
e características metodológicas.

Observação:
A tabela possui granularidade por candidato/cenário.
Por isso, pesquisas são contabilizadas utilizando
COUNT(DISTINCT id_pesquisa).

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Quantidade total de pesquisas disponíveis
-- =====================================================

SELECT

  COUNT(DISTINCT id_pesquisa)
  AS total_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 2. Distribuição de pesquisas por ano
-- =====================================================

SELECT

  ano,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 3. Distribuição de pesquisas por cargo
-- =====================================================

SELECT

  cargo,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE cargo IS NOT NULL

GROUP BY cargo

ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 4. Pesquisas por ano e cargo
-- =====================================================
-- Evita misturar eleições diferentes

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
-- 5. Distribuição geográfica por estado
-- =====================================================
-- Mostra onde existem registros de pesquisas

SELECT

  sigla_uf,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE sigla_uf IS NOT NULL

GROUP BY sigla_uf

ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 6. Distribuição geográfica por estado e cargo
-- =====================================================
-- Permite comparar eleições diferentes

SELECT

  sigla_uf,

  cargo,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE sigla_uf IS NOT NULL

GROUP BY

  sigla_uf,
  cargo

ORDER BY

  quantidade_pesquisas DESC;



-- =====================================================
-- 7. Municípios com maior quantidade de pesquisas
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

ORDER BY

  quantidade_pesquisas DESC

LIMIT 20;



-- =====================================================
-- 8. Cobertura geográfica das pesquisas por ano
-- =====================================================
-- Mede quantos estados e municípios foram analisados

SELECT

  ano,

  COUNT(DISTINCT sigla_uf)
  AS estados_analisados,

  COUNT(DISTINCT nome_municipio)
  AS municipios_analisados,

  COUNT(DISTINCT id_pesquisa)
  AS pesquisas_realizadas


FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 9. Institutos responsáveis pelas pesquisas
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
-- 10. Quantidade média de entrevistas por pesquisa
-- =====================================================

SELECT

  ano,

  ROUND(
    AVG(quantidade_entrevistas),
    2
  ) AS media_entrevistas,


  COUNT(DISTINCT id_pesquisa)
  AS pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 11. Margem média de erro das pesquisas
-- =====================================================

SELECT

  ano,

  ROUND(
    AVG(margem_mais),
    2
  ) AS media_margem_superior,


  ROUND(
    AVG(margem_menos),
    2
  ) AS media_margem_inferior

FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY ano

ORDER BY ano;



-- =====================================================
-- 12. Distribuição dos tipos de voto
-- =====================================================

SELECT

  tipo_voto,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE tipo_voto IS NOT NULL

GROUP BY tipo_voto

ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 13. Quantidade de cenários por pesquisa
-- =====================================================
-- Mostra a complexidade das pesquisas

SELECT

  id_pesquisa,

  COUNT(DISTINCT id_cenario)
  AS quantidade_cenarios

FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY id_pesquisa

ORDER BY quantidade_cenarios DESC;



-- =====================================================
-- 14. Pesquisas realizadas por período do ano
-- =====================================================

SELECT

  ano,

  EXTRACT(MONTH FROM data)
  AS mes,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE data IS NOT NULL

GROUP BY

  ano,
  mes

ORDER BY

  ano,
  mes;
