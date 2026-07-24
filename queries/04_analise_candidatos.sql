/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
04_analise_candidatos.sql

Objetivo:
Analisar a presença e o desempenho dos candidatos
nas pesquisas eleitorais.

Perguntas respondidas:

- Quais candidatos aparecem mais nas pesquisas?
- Qual a média de percentual por candidato?
- Qual o maior percentual registrado?
- Quais partidos aparecem com maior frequência?
- Quantos cenários cada candidato possui?

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Candidatos com maior quantidade de pesquisas
-- =====================================================

SELECT
  nome_candidato,
  COUNT(DISTINCT id_pesquisa) AS quantidade_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NOT NULL
GROUP BY nome_candidato
ORDER BY quantidade_pesquisas DESC
LIMIT 20;



-- =====================================================
-- 2. Média de percentual por candidato
-- =====================================================

SELECT
  nome_candidato,
  ROUND(AVG(percentual),2) AS media_percentual
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NOT NULL
GROUP BY nome_candidato
ORDER BY media_percentual DESC;



-- =====================================================
-- 3. Maior percentual registrado por candidato
-- =====================================================

SELECT
  nome_candidato,
  MAX(percentual) AS maior_percentual
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NOT NULL
GROUP BY nome_candidato
ORDER BY maior_percentual DESC;



-- =====================================================
-- 4. Menor percentual registrado por candidato
-- =====================================================

SELECT
  nome_candidato,
  MIN(percentual) AS menor_percentual
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NOT NULL
GROUP BY nome_candidato
ORDER BY menor_percentual;



-- =====================================================
-- 5. Quantidade de candidatos por partido
-- =====================================================

SELECT
  sigla_partido,
  COUNT(DISTINCT nome_candidato) AS quantidade_candidatos
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE sigla_partido IS NOT NULL
GROUP BY sigla_partido
ORDER BY quantidade_candidatos DESC;



-- =====================================================
-- 6. Média de percentual por partido
-- =====================================================

SELECT
  sigla_partido,
  ROUND(AVG(percentual),2) AS media_percentual
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE sigla_partido IS NOT NULL
GROUP BY sigla_partido
ORDER BY media_percentual DESC;



-- =====================================================
-- 7. Quantidade de cenários por candidato
-- =====================================================

SELECT
  nome_candidato,
  COUNT(DISTINCT id_cenario) AS quantidade_cenarios
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NOT NULL
GROUP BY nome_candidato
ORDER BY quantidade_cenarios DESC;



-- =====================================================
-- 8. Candidatos por cargo
-- =====================================================

SELECT
  cargo,
  COUNT(DISTINCT nome_candidato) AS quantidade_candidatos
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NOT NULL
GROUP BY cargo
ORDER BY quantidade_candidatos DESC;



-- =====================================================
-- 9. Distribuição de candidatos por estado
-- =====================================================

SELECT
  sigla_uf,
  COUNT(DISTINCT nome_candidato) AS quantidade_candidatos
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE sigla_uf IS NOT NULL
GROUP BY sigla_uf
ORDER BY quantidade_candidatos DESC;



-- =====================================================
-- 10. Evolução média de candidatos por ano
-- =====================================================

SELECT
  ano,
  COUNT(DISTINCT nome_candidato) AS quantidade_candidatos,
  ROUND(AVG(percentual),2) AS media_percentual
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NOT NULL
GROUP BY ano
ORDER BY ano;
