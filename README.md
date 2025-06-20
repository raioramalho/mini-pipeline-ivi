# 🧪 Mini Pipeline IVI — Projeto de Arquitetura de Dados

Este projeto simula um pipeline real utilizado por empresas de ciência de dados, como a IVI Data Science. Ele é focado em ingestão, transformação e entrega de dados estruturados em tempo real, usando componentes modernos, desacoplados e prontos para rodar em Kubernetes.

---

## 🎯 Objetivo

Demonstrar capacidade arquitetural e técnica para:
- Receber arquivos CSV via upload.
- Armazenar os arquivos em object storage (MinIO).
- Detectar novos arquivos via webhook.
- Processar os dados com Pandas de forma desacoplada.
- Enviar os dados tratados diretamente para o Power BI (Streaming Dataset).
- Rodar tudo em ambiente orquestrado com Kubernetes (MicroK8s no lab).

---

## ⚙️ Componentes

| Serviço     | Tecnologia         | Função                                          |
|-------------|--------------------|--------------------------------------------------|
| MinIO       | Object Storage S3  | Armazena arquivos CSV recebidos                 |
| FastAPI     | Webhook Receiver   | Captura eventos do MinIO e aciona o Processor   |
| Processor   | Python + Pandas    | Realiza o ETL, trata dados e envia ao Power BI  |
| Power BI    | Streaming Dataset  | Visualiza dados tratados em tempo real          |
| Orquestração| Kubernetes / Docker Compose | Gerencia deploys e execução local/lab     |

---

## 📊 Relatório em Tempo Real

[![Abrir Relatório Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-ffc107?logo=power-bi&style=for-the-badge)](https://app.powerbi.com/reportEmbed?reportId=b279dc54-8d50-427a-83b5-72c8220bc143&autoAuth=true&ctid=da49a844-e2e3-40af-86a6-c3819d704f49)

## 🧠 Arquitetura Infra/Pipeline

```mermaid
graph TD
  A[Usuario] --> B[MinIO Object Storage]
  B -->|Webhook PUT| C[FastAPI Webhook Receiver]
  C -->|Trigger| D[Processor Python + Pandas]

  subgraph Cluster Kubernetes
    B
    C
    D
  end

  D -->|Read via MinIO SDK| B
  D -->|Transforma CSV| E[Memoria DataFrame]
  D -->|POST JSON| F[Power BI Streaming Dataset]
  D -->|Exporta CSV Tratado| G[MinIO Saida]
```

---

## 📦 Estrutura de Diretórios

```
mini-pipeline-ivi/
├── dic/                    # Doc do projeto
├── api/                    # Código da API FastAPI (webhook)
├── k8s/                    # Manifests do Kubernetes
├── Dockerfile.api          # Imagem da API FastAPI
├── Dockerfile.processor    # Imagem do Processor
├── Makefile                # Comandos úteis para build e automações
├── README.md               # Este arquivo
```

---

## 🚀 Como rodar (modo local)

### Pré-requisitos

- Docker
- Docker Compose
- Power BI com Streaming Dataset configurado (chave de ingestão)
- `make` instalado (opcional, mas recomendado)
- `mc` (MinIO Client) instalado e configurado

### Passos

1. **Build dos serviços**
```bash
make build
```

2. **Subir tudo com Docker Compose**
```bash
make dev
```

3. **Ver logs da API**
```bash
make logs
```

4. **Criar bucket e configurar webhook no MinIO**
```bash
mc alias set local http://localhost:9000 minioadmin minioadmin
mc mb local/teste
mc admin config set local notify_webhook:1 endpoint="http://api:8000/webhook/csv"
mc admin service restart local
mc event add local/teste arn:minio:sqs::1:webhook --event put --suffix .csv
```

5. **Enviar CSV manualmente**
```bash
mc cp dados.csv local/teste/
```

6. **Ver relatório no Power BI**
> Configure seu dashboard com base no Streaming Dataset correspondente.

---

## 🔄 Melhorias futuras

- Persistência de dados tratados (ex: SQLite, PostgreSQL)
- Agendamento de reprocessamento (Celery ou CronJob)
- Upload de CSV via frontend (UI simples com Dropzone.js)
- Fila para desacoplamento total do Processor (Redis, Kafka)
- Autenticação nos endpoints
- Observabilidade com Prometheus + Grafana
- Versionamento de arquivos tratados (via timestamp ou hash)

---

## 👨‍💻 Autor

Desenvolvido por **Alan Ramalho** como prova de conceito de arquitetura moderna, modular e orientada a eventos para uso real em projetos de ciência de dados e business intelligence.