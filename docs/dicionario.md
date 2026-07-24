# Dicionário de Dados

## Projeto

Análise de Pesquisas Eleitorais utilizando SQL e BigQuery.

Fonte dos dados:

Base dos Dados

Tabela utilizada:

`basedosdados.br_poder360_pesquisas.microdados`

---

# Estrutura da tabela

A tabela contém informações sobre pesquisas eleitorais, incluindo:

- identificação da pesquisa;
- localização;
- cargo analisado;
- instituto responsável;
- candidatos;
- partidos;
- cenários eleitorais;
- percentual de intenção de voto.

---

# Campos principais

| Campo | Tipo | Descrição |
|---|---|---|
| id_pesquisa | STRING | Identificador único da pesquisa |
| ano | INTEGER | Ano da eleição ou pesquisa |
| sigla_uf | STRING | Estado da pesquisa |
| nome_municipio | STRING | Município analisado |
| cargo | STRING | Cargo eleitoral pesquisado |
| data | DATE | Data da pesquisa |
| instituto | STRING | Instituto responsável |
| contratante | STRING | Organização contratante |
| quantidade_entrevistas | FLOAT | Número de entrevistas realizadas |
| margem_mais | FLOAT | Margem superior de erro |
| margem_menos | FLOAT | Margem inferior de erro |
| turno | INTEGER | Turno eleitoral |
| tipo_voto | STRING | Tipo de intenção de voto |
| id_cenario | STRING | Identificação do cenário eleitoral |
| descricao_cenario | STRING | Descrição do cenário |
| nome_candidato | STRING | Nome do candidato |
| sigla_partido | STRING | Partido do candidato |
| percentual | FLOAT | Percentual obtido pelo candidato |

---

# Granularidade dos dados

Um ponto importante sobre a tabela:

Uma linha representa:

> Um candidato dentro de um cenário de uma pesquisa eleitoral.

Exemplo:

| Pesquisa | Cenário | Candidato | Percentual |
|-|-|-|-|
| 001 | A | Candidato X | 35 |
| 001 | A | Candidato Y | 30 |
| 001 | A | Candidato Z | 10 |

Por isso, para contar pesquisas devemos utilizar:

```sql
COUNT(DISTINCT id_pesquisa)

````
 e não:

```sql
COUNT(*)

````


# Tratamento dos Dados

Antes das análises, foram realizadas verificações de qualidade
sobre a tabela original.

Os tratamentos e validações realizados foram:

## Valores nulos

Foram identificados campos com valores ausentes, principalmente
em informações como:

- candidato;
- partido;
- instituto;
- percentual;
- quantidade de entrevistas.

Os valores nulos não foram removidos da tabela original.
Quando necessário, foram tratados nas consultas analíticas.

---

## Valores vazios

Foram verificados campos de texto contendo valores vazios.

Exemplos:

- nome do candidato;
- sigla do partido;
- instituto;
- unidade federativa.

---

## Validação de percentuais

Foi realizada uma verificação dos valores da coluna
`percentual`.

Regra aplicada:

- valores esperados entre 0 e 100.

Valores fora desse intervalo foram considerados inconsistentes.

---

## Duplicidade

Foi realizada uma análise de possíveis registros duplicados
considerando:

- id_pesquisa;
- id_cenario;
- nome_candidato.

---

## Datas

Foram analisados:

- menor data disponível;
- maior data disponível;
- distribuição das pesquisas ao longo do tempo.

---

## Preservação dos dados originais

A tabela original da Base dos Dados não foi alterada.

Todas as análises foram realizadas utilizando consultas SQL
no BigQuery.
