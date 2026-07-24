/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
03_analise_pesquisas.sql

Objetivo:
Analisar a distribuição das pesquisas eleitorais.

Perguntas respondidas:

- Quantas pesquisas existem por ano?
- Quais estados possuem mais pesquisas?
- Quais cargos possuem mais pesquisas?
- Quais institutos realizaram mais pesquisas?
- Qual a média de entrevistas realizadas?
- Como as pesquisas se distribuem por turno?

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
-- 2. Quantidade de pesquisas por estado
-- =====================================================

SELECT
  sigla_uf,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE sigla_uf IS NOT NULL
GROUP BY sigla_uf
ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 3. Quantidade de pesquisas por cargo
-- =====================================================

SELECT
  cargo,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`
GROUP BY cargo
ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 4. Institutos que realizaram mais pesquisas
-- =====================================================

SELECT
  instituto,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE instituto IS NOT NULL
GROUP BY instituto
ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 5. Quantidade média de entrevistas por instituto
-- =====================================================

SELECT
  instituto,
  ROUND(AVG(quantidade_entrevistas), 0) AS media_entrevistas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE instituto IS NOT NULL
GROUP BY instituto
ORDER BY media_entrevistas DESC;



-- =====================================================
-- 6. Distribuição de pesquisas por turno
-- =====================================================

SELECT
  turno,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE turno IS NOT NULL
GROUP BY turno
ORDER BY turno;



-- =====================================================
-- 7. Quantidade de pesquisas por tipo de voto
-- =====================================================

SELECT
  tipo_voto,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE tipo_voto IS NOT NULL
GROUP BY tipo_voto
ORDER BY quantidade_pesquisas DESC;



-- =====================================================
-- 8. Média da margem de erro das pesquisas
-- =====================================================

SELECT
  ROUND(AVG(margem_mais), 2) AS media_margem_mais,
  ROUND(AVG(margem_menos), 2) AS media_margem_menos
FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 9. Quantidade de entrevistas realizadas por ano
-- =====================================================

SELECT
  ano,
  SUM(quantidade_entrevistas) AS total_entrevistas
FROM `basedosdados.br_poder360_pesquisas.microdados`
GROUP BY ano
ORDER BY ano;



-- =====================================================
-- 10. Municípios com maior número de pesquisas
-- =====================================================

SELECT
  nome_municipio,
  sigla_uf,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_municipio IS NOT NULL
GROUP BY
  nome_municipio,
  sigla_uf
ORDER BY quantidade_pesquisas DESC
LIMIT 20;
