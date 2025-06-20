# 🚀 Mini Pipeline IVI – Arquitetura Prática para Projetos de Dados

Este projeto simula uma arquitetura moderna de ingestão e entrega de dados estruturados, com foco em **eficiência**, **automação** e **integração com Power BI em tempo real**. Foi desenvolvido como prova de conceito de capacidade arquitetural aplicada à prática.

---

## 🎯 Objetivo

- Receber arquivos `.csv` em um bucket MinIO.
- Processar os dados automaticamente com Pandas.
- Tratar e validar campos como `idade`, `gênero` e `renda_mensal`.
- Enviar os dados para o Power BI Streaming Dataset.
- Alimentar dashboards com métricas em tempo real.

---

## 🧱 Componentes da Arquitetura

| Camada      | Tecnologia         | Função                                             |
|-------------|--------------------|----------------------------------------------------|
| Armazenamento | MinIO             | Recebe arquivos brutos `.csv` via upload           |
| Processamento | FastAPI + Pandas  | Trata, filtra e converte os dados para JSON        |
| Automação     | MinIO Webhook     | Dispara o processamento ao detectar arquivos novos |
| Entrega       | Power BI Streaming Dataset | Recebe push dos dados tratados                  |

---

## 🔁 Fluxo da Pipeline

1. Upload do CSV no bucket `teste` do MinIO.
2. Webhook dispara evento `PUT` com metadados.
3. FastAPI captura, lê e trata o CSV.
4. Dados tratados são enviados via `POST` para o endpoint do Power BI.
5. Dashboards refletem os dados em tempo real.

---

## 📊 Exemplo de Métricas Criadas

- Média e mediana de idade por gênero
- Média e máximos de renda mensal
- Contagem de registros por gênero
- Análises visuais via Power BI

---

## 🛠️ Deployment Local

O ambiente de desenvolvimento roda via `docker-compose`, com:

- MinIO
- FastAPI com reload ativo
- Webhook configurado via `mc admin config`

---

## ⚖️ Tradeoffs Arquiteturais

| Aspecto         | Em Corpo (Fácil)         | Em Fila (Escalável)                   |
|------------------|--------------------------|----------------------------------------|
| Simplicidade      | Alta                     | Média (requer worker e fila)          |
| Escalabilidade    | Limitada à instância     | Escala horizontal (K8s, Redis, etc)   |
| Tolerância a falhas | Baixa                  | Alta (retry garantido)                |
| Tempo real        | Sim                     | Sim                                   |

---

## 📦 Próximos Passos

- Substituir o push direto por fila (ex: Redis, Kafka)
- Armazenar histórico dos dados
- Adicionar autenticação nos endpoints
- Exportar relatórios por período
- Expor métricas via `/metrics` (Prometheus)

---

## 👨‍💻 Autor

Desenvolvido por Alan Ramalho como simulação de uma arquitetura real utilizada por empresas de ciência de dados, com foco em **eficiência operacional, integração contínua e entrega de valor visual**.

