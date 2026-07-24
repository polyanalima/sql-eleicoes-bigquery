/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
02_qualidade_dados.sql

Objetivo:
Avaliar a qualidade dos dados da tabela de pesquisas
eleitorais.

Análises realizadas:
- Valores nulos
- Valores vazios
- Consistência dos percentuais
- Consistência das entrevistas
- Qualidade das datas

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Verificar quantidade de valores nulos
-- =====================================================

SELECT
  COUNTIF(id_pesquisa IS NULL) AS id_pesquisa_nulo,
  COUNTIF(ano IS NULL) AS ano_nulo,
  COUNTIF(cargo IS NULL) AS cargo_nulo,
  COUNTIF(data IS NULL) AS data_nula,
  COUNTIF(instituto IS NULL) AS instituto_nulo,
  COUNTIF(nome_candidato IS NULL) AS candidato_nulo,
  COUNTIF(percentual IS NULL) AS percentual_nulo
FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 2. Verificar valores vazios em campos de texto
-- =====================================================

SELECT
  COUNTIF(TRIM(nome_candidato) = '') AS candidato_vazio,
  COUNTIF(TRIM(sigla_partido) = '') AS partido_vazio,
  COUNTIF(TRIM(instituto) = '') AS instituto_vazio,
  COUNTIF(TRIM(sigla_uf) = '') AS uf_vazio
FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 3. Verificar intervalo dos percentuais
-- =====================================================

SELECT
  MIN(percentual) AS menor_percentual,
  MAX(percentual) AS maior_percentual,
  AVG(percentual) AS media_percentual
FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 4. Encontrar percentuais inválidos
-- Percentual esperado: entre 0 e 100
-- =====================================================

SELECT *
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE percentual < 0
   OR percentual > 100;



-- =====================================================
-- 5. Verificar quantidade de entrevistas
-- =====================================================

SELECT
  MIN(quantidade_entrevistas) AS menor_quantidade,
  MAX(quantidade_entrevistas) AS maior_quantidade,
  AVG(quantidade_entrevistas) AS media_entrevistas
FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 6. Encontrar pesquisas sem quantidade de entrevistas
-- =====================================================

SELECT
  COUNT(*) AS registros_sem_entrevistas
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE quantidade_entrevistas IS NULL;



-- =====================================================
-- 7. Verificar datas disponíveis
-- =====================================================

SELECT
  MIN(data) AS primeira_data,
  MAX(data) AS ultima_data
FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 8. Pesquisas sem candidato identificado
-- =====================================================

SELECT
  COUNT(*) AS registros_sem_candidato
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE nome_candidato IS NULL;



-- =====================================================
-- 9. Pesquisas sem instituto informado
-- =====================================================

SELECT
  COUNT(*) AS registros_sem_instituto
FROM `basedosdados.br_poder360_pesquisas.microdados`
WHERE instituto IS NULL;



-- =====================================================
-- 10. Verificar duplicidade de linhas
-- =====================================================

SELECT
  id_pesquisa,
  id_cenario,
  nome_candidato,
  COUNT(*) AS quantidade
FROM `basedosdados.br_poder360_pesquisas.microdados`
GROUP BY
  id_pesquisa,
  id_cenario,
  nome_candidato
HAVING COUNT(*) > 1;
