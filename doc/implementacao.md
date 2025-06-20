# ✅ Passos Executados — Projeto Mini Pipeline IVI

## 1. Definição do Propósito
- Simular um caso de uso realista para a IVI Data Science.
- Foco em ingestão, processamento e entrega de dados via API.
- Usar o projeto como prova prática da capacidade como Arquiteto de Soluções.

---

## 2. Escolha do Stack e Arquitetura Base
- Tecnologias escolhidas:
  - FastAPI (API Webhook)
  - Python + Pandas (Processor)
  - MinIO (Object Storage)
  - Power BI (Streaming Dataset)
- Arquitetura definida:
  - Upload de CSV → Webhook → Processor → JSON + CSV tratado → Power BI / MinIO

---

## 3. Criação do Ambiente Local
- Docker Compose para orquestração.
- Arquivos criados:
  - `Dockerfile.api`
  - `Dockerfile.processor`
  - `Makefile`
- Estrutura de diretórios:
  - `api/`, `k8s/`, `dic/`

---

## 4. Integração com MinIO e Testes Manuais
- Subiu MinIO localmente.
- Usou `mc` (MinIO Client) para:
  - Criar bucket.
  - Configurar webhook de evento PUT.
  - Simular upload de CSV.
- Validou o fluxo completo:
  - Upload aciona webhook → FastAPI → Processor → Pandas → Exportações.

---

## 5. Integração com Power BI
- Criou Streaming Dataset no Power BI.
- Configurou ingestão via POST.
- Processor foi ajustado para enviar JSON tratado ao Power BI.

---

## 6. Desenho da Arquitetura
- Diagrama inicial em Mermaid no README.
- Versões geradas:
  - Estilo AWS (Graphviz)
  - Compatível com draw.io
- Criou `doc-openstack.md` com instruções para ambiente OpenStack.

---

## 7. Organização e Documentação
- Criou README estruturado com:
  - Objetivo, Componentes, Arquitetura, Execução, Melhorias.
- Exportações geradas:
  - PDF
  - Markdown sem ícones
- Instruções detalhadas com `make`, `docker-compose`, `mc`, Power BI.

---

## 8. Divulgação e Compartilhamento
- Compartilhou o projeto com o Hélcio (IVI).
- Enviou links e material explicativo via WhatsApp.
- Redigiu uma mensagem clara com contexto e link para o repositório.

---

## Estado Atual
- Projeto funcional (Upload > Processamento > Entrega).
- 70% concluído.
- Próximos passos:
  - Infraestrutura como código com Terraform.
  - Deploy para AWS, Azure, Kubernetes e OpenStack.
