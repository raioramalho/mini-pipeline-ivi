# ☁️ Mini Pipeline IVI com OpenStack – Arquitetura Escalável de Ingestão e Visualização de Dados

Este projeto demonstra uma arquitetura de pipeline de dados totalmente orquestrada sobre infraestrutura OpenStack, simulando uma entrega real para times de ciência de dados. Utiliza serviços nativos como **Swift**, **Nova**, **Heat** e **Magnum**, além de integração com **Power BI** para visualização em tempo real.

---

## 🎯 Objetivo

- Receber arquivos `.csv` via API ou interface web.
- Armazenar os arquivos no **OpenStack Swift** (Object Storage).
- Detectar novos arquivos e processá-los com **FastAPI + Pandas**.
- Enviar os dados transformados para o **Power BI Streaming Dataset**.
- Executar toda a orquestração em VMs ou containers gerenciados no OpenStack.

---

## 🧱 Componentes da Arquitetura

| Camada             | Tecnologia                          | Função                                                   |
|--------------------|--------------------------------------|----------------------------------------------------------|
| Armazenamento      | OpenStack Swift                      | Persistência de arquivos `.csv`                          |
| Processamento      | FastAPI + Pandas (em VM ou container)| Leitura, transformação e entrega dos dados               |
| Detecção           | Webhook do Swift ou serviço de polling| Disparo do processamento ao detectar novo arquivo        |
| Entrega            | Power BI Streaming Dataset           | Consumo dos dados para visualização                      |
| Orquestração       | OpenStack (Heat, Ansible, Magnum)    | Provisionamento e gestão da infraestrutura               |

---

## 🛰️ Serviços OpenStack Utilizados

| Serviço      | Função                                                           |
|--------------|------------------------------------------------------------------|
| **Swift**    | Armazenamento de objetos (entrada e saída de arquivos `.csv`)   |
| **Nova**     | Execução de instâncias (VMs) para os serviços do pipeline        |
| **Magnum**   | (Opcional) Gerenciamento de containers com Kubernetes ou Docker |
| **Keystone** | Autenticação e autorização entre os serviços                     |
| **Heat**     | Orquestração de infraestrutura como código (IaC)                 |

---

## ⚙️ Arquitetura do Pipeline

```mermaid
graph TD
  A[Usuário envia CSV] --> B[OpenStack Swift]
  B -->|Webhook PUT| C[FastAPI Webhook Receiver]
  C -->|Trigger| D[Processor (Python + Pandas)]

  subgraph OpenStack Infra
    B
    C
    D
    H[VM ou Container gerenciado]
  end

  D -->|Leitura via Swift SDK| B
  D -->|Transformação com Pandas| E[DataFrame em Memória]
  D -->|POST JSON| F[Power BI Streaming Dataset]
  D -->|Exporta CSV tratado| G[Swift - Saída]
```

---

## 🔁 Fluxo do Pipeline

```plaintext
1. Upload do CSV via interface ou API
2. Armazenamento no Swift
3. Detecção automática via webhook ou polling
4. Processamento com FastAPI + Pandas
5. Envio para Power BI Streaming
6. Exportação opcional para Swift (dados tratados)
7. Visualização em dashboards em tempo real
```