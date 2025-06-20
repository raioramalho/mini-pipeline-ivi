# 🧪 Mini Pipeline IVI — Projeto de Arquitetura de Dados

Este projeto simula um pipeline real utilizado por empresas de ciência de dados, como a IVI Data Science. Ele é focado em ingestão, pré-processamento e entrega de dados estruturados via API, usando componentes simples, modernos e prontos para rodar em Kubernetes.

---

## 🎯 Objetivo

Demonstrar capacidade arquitetural e técnica para:
- Receber arquivos CSV via API.
- Armazenar os arquivos em object storage (MinIO).
- Realizar pré-processamento com Pandas.
- Disponibilizar os dados tratados para consumo via API.
- Rodar tudo em ambiente orquestrado com Kubernetes (MicroK8s no lab).

---

## ⚙️ Componentes

| Serviço     | Tecnologia       | Função                                    |
|-------------|------------------|-------------------------------------------|
| API         | FastAPI + Uvicorn| Recebe arquivos CSV e entrega dados       |
| Processor   | Python + Pandas  | Realiza o tratamento dos dados            |
| Storage     | MinIO (S3-like)  | Armazena arquivos brutos e processados    |
| Orquestração| Kubernetes       | Gerencia deploys, jobs, ingress etc.      |

---

## 📦 Estrutura de Diretórios

```
mini-pipeline-ivi/
├── api/                    # Código da API FastAPI
├── processor/              # Código de processamento Pandas
├── k8s/                    # Manifests do Kubernetes
├── Dockerfile.api          # Build da imagem da API
├── Dockerfile.processor    # Build da imagem do processador
├── Makefile                # Comandos úteis para build e deploy
├── README.md               # Este arquivo
```

---

## 🚀 Como rodar

### Pré-requisitos
- Docker
- MicroK8s com ingress e storage habilitados
- `kubectl` e `make` instalados

### Passos

1. **Build das imagens**
```bash
make build
```

2. **Deploy no cluster**
```bash
make deploy
```

3. **Acessar API**
Configure seu `/etc/hosts`:
```
127.0.0.1   mini.local
```

Depois abra: [http://mini.local/upload](http://mini.local/upload)

---

## 🛠 Melhorias futuras

- Trigger automático de processamento via upload
- Integração com banco de dados para histórico
- Frontend para visualização dos dados
- Agendamento com Celery ou cronjob K8s

---

## 👨‍💻 Autor

Desenvolvido por Alan Ramalho como simulação de arquitetura moderna e prática para projetos reais em ciência de dados.
