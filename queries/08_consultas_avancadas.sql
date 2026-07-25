/*
=========================================================

Projeto:
Análise de Pesquisas Eleitorais com BigQuery

Arquivo:
08_consultas_avancadas.sql

Objetivo:
Aplicar técnicas avançadas de SQL para transformação,
classificação e criação de métricas analíticas.

Técnicas utilizadas:

- CTEs (WITH)
- CASE WHEN
- COALESCE
- SAFE_CAST
- Criação de métricas
- Preparação para dashboards

Fonte:
Base dos Dados

Tabela:
basedosdados.br_poder360_pesquisas.microdados

=========================================================
*/


-- =====================================================
-- 1. Classificação dos candidatos por faixa de percentual
-- =====================================================

SELECT

  nome_candidato,

  percentual,

  CASE

    WHEN percentual >= 40 THEN 'Alta intenção'

    WHEN percentual >= 20 THEN 'Média intenção'

    WHEN percentual >= 10 THEN 'Baixa intenção'

    ELSE 'Baixa participação'

  END AS categoria_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL;



-- =====================================================
-- 2. Classificação dos tamanhos de pesquisas
-- =====================================================

SELECT

  id_pesquisa,

  quantidade_entrevistas,


  CASE

    WHEN quantidade_entrevistas >= 3000
      THEN 'Pesquisa grande'

    WHEN quantidade_entrevistas >= 1000
      THEN 'Pesquisa média'

    ELSE 'Pesquisa pequena'

  END AS tamanho_pesquisa


FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 3. Tratamento de valores nulos com COALESCE
-- =====================================================

SELECT

  id_pesquisa,

  COALESCE(
    nome_candidato,
    'Não informado'
  ) AS candidato,

  COALESCE(
    sigla_partido,
    'Sem partido informado'
  ) AS partido


FROM `basedosdados.br_poder360_pesquisas.microdados`;



-- =====================================================
-- 4. Criação de uma tabela analítica usando CTE
-- =====================================================

WITH resumo_candidatos AS (

SELECT

  ano,

  cargo,

  nome_candidato,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas,


  AVG(percentual)
  AS media_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY

  ano,
  cargo,
  nome_candidato

)


SELECT

  ano,

  cargo,

  nome_candidato,

  quantidade_pesquisas,

  ROUND(media_percentual,2)
  AS media_percentual


FROM resumo_candidatos

ORDER BY media_percentual DESC;



-- =====================================================
-- 5. Criar indicador de presença dos candidatos
-- =====================================================

WITH presenca AS (

SELECT

  nome_candidato,

  COUNT(DISTINCT id_pesquisa)
  AS pesquisas

FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

GROUP BY nome_candidato

)


SELECT

  nome_candidato,

  pesquisas,


  CASE

    WHEN pesquisas >= 50
      THEN 'Alta presença'

    WHEN pesquisas >= 20
      THEN 'Presença média'

    ELSE 'Baixa presença'

  END AS classificacao_presenca


FROM presenca

ORDER BY pesquisas DESC;



-- =====================================================
-- 6. Comparação entre candidatos dentro do mesmo cenário
-- =====================================================

WITH cenarios AS (

SELECT

  ano,

  cargo,

  id_cenario,

  nome_candidato,

  percentual,


  MAX(percentual) OVER(

    PARTITION BY ano, cargo, id_cenario

  ) AS maior_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE nome_candidato IS NOT NULL

)


SELECT

  ano,

  cargo,

  id_cenario,

  nome_candidato,

  percentual,


  maior_percentual - percentual
  AS diferenca_lider


FROM cenarios;



-- =====================================================
-- 7. Média de intenção por instituto e cargo
-- =====================================================

WITH instituto_cargo AS (

SELECT

  instituto,

  cargo,

  AVG(percentual)
  AS media_percentual,


  COUNT(DISTINCT id_pesquisa)
  AS pesquisas


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE instituto IS NOT NULL

GROUP BY

  instituto,
  cargo

)


SELECT

  instituto,

  cargo,

  ROUND(media_percentual,2)
  AS media_percentual,

  pesquisas


FROM instituto_cargo

ORDER BY media_percentual DESC;



-- =====================================================
-- 8. Criar classificação dos períodos eleitorais
-- =====================================================

SELECT

  ano,

  data,


  CASE

    WHEN EXTRACT(MONTH FROM data) <= 6
      THEN 'Primeiro semestre'

    ELSE 'Segundo semestre'

  END AS periodo_ano


FROM `basedosdados.br_poder360_pesquisas.microdados`

WHERE data IS NOT NULL;



-- =====================================================
-- 9. Métrica consolidada para dashboard
-- =====================================================

WITH indicadores AS (

SELECT

  ano,

  cargo,

  COUNT(DISTINCT id_pesquisa)
  AS pesquisas,


  COUNT(DISTINCT nome_candidato)
  AS candidatos,


  AVG(percentual)
  AS media_percentual,


  SUM(quantidade_entrevistas)
  AS entrevistas


FROM `basedosdados.br_poder360_pesquisas.microdados`

GROUP BY

  ano,
  cargo

)


SELECT

  ano,

  cargo,

  pesquisas,

  candidatos,

  ROUND(media_percentual,2)
  AS media_percentual,

  entrevistas


FROM indicadores

ORDER BY ano, cargo;



-- =====================================================
-- 10. Conversão segura de valores
-- =====================================================

SELECT

  SAFE_CAST(ano AS STRING)
  AS ano_texto,

  SAFE_CAST(percentual AS INT64)
  AS percentual_inteiro


FROM `basedosdados.br_poder360_pesquisas.microdados`;




/*
=========================================================

Análise:
Tabela analítica final de pesquisas eleitorais

Objetivo:
Criar uma visão consolidada para consumo analítico
e preparação para dashboards.

=========================================================
*/


SELECT

  ano,

  cargo,

  tipo_voto,

  COUNT(DISTINCT id_pesquisa)
  AS quantidade_pesquisas,

  COUNT(DISTINCT nome_candidato)
  AS quantidade_candidatos,

  COUNT(DISTINCT sigla_uf)
  AS estados_analisados,

  ROUND(
    AVG(percentual),
    2
  ) AS media_percentual


FROM `basedosdados.br_poder360_pesquisas.microdados`


WHERE ano IS NOT NULL


GROUP BY

  ano,

  cargo,

  tipo_voto


ORDER BY

  ano,

  quantidade_pesquisas DESC;
