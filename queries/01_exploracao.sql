/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
01_exploracao.sql

Objetivo:
Explorar a estrutura inicial da tabela de pesquisas
eleitorais do Poder360.

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Visualizar alguns registros da tabela
-- =====================================================

SELECT *
FROM `basedosdados.br_poder360_pesquisas.microdados`
LIMIT 20;


-- =====================================================
-- 2. Quantidade total de registros
-- =====================================================

SELECT
  COUNT(*) AS total_registros
FROM `basedosdados.br_poder360_pesquisas.microdados`;


-- =====================================================
-- 3. Quantidade de pesquisas únicas
-- =====================================================

SELECT
  COUNT(DISTINCT id_pesquisa) AS total_pesquisas
FROM `basedosdados.br_poder360_pesquisas.microdados`;


-- =====================================================
-- 4. Quantidade de cenários existentes
-- =====================================================

SELECT
  COUNT(DISTINCT id_cenario) AS total_cenarios
FROM `basedosdados.br_poder360_pesquisas.microdados`;


-- =====================================================
-- 5. Anos disponíveis
-- =====================================================

SELECT DISTINCT
  ano
FROM `basedosdados.br_poder360_pesquisas.microdados`
ORDER BY ano;


-- =====================================================
-- 6. Cargos pesquisados
-- =====================================================

SELECT DISTINCT
  cargo
FROM `basedosdados.br_poder360_pesquisas.microdados`
ORDER BY cargo;


-- =====================================================
-- 7. Estados presentes na base
-- =====================================================

SELECT DISTINCT
  sigla_uf
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE sigla_uf IS NOT NULL
ORDER BY sigla_uf;


-- =====================================================
-- 8. Institutos de pesquisa
-- =====================================================

SELECT DISTINCT
  instituto
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE instituto IS NOT NULL
ORDER BY instituto;


-- =====================================================
-- 9. Partidos existentes
-- =====================================================

SELECT DISTINCT
  sigla_partido
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE sigla_partido IS NOT NULL
ORDER BY sigla_partido;


-- =====================================================
-- 10. Tipos de voto
-- =====================================================

SELECT DISTINCT
  tipo_voto
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE tipo_voto IS NOT NULL
ORDER BY tipo_voto;


-- =====================================================
-- 11. Turnos disponíveis
-- =====================================================

SELECT DISTINCT
  turno
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE turno IS NOT NULL
ORDER BY turno;
