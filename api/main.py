from fastapi import FastAPI, Request, HTTPException
from minio import Minio
from io import BytesIO
import pandas as pd
import os

app = FastAPI()

# Config MinIO
MINIO_ENDPOINT = os.getenv("MINIO_ENDPOINT", "localhost:9000")
MINIO_ACCESS_KEY = os.getenv("MINIO_ACCESS_KEY", "minioadmin")
MINIO_SECRET_KEY = os.getenv("MINIO_SECRET_KEY", "minioadmin")
BUCKET_NAME = "teste"

minio_client = Minio(
    MINIO_ENDPOINT,
    access_key=MINIO_ACCESS_KEY,
    secret_key=MINIO_SECRET_KEY,
    secure=False  # ⚠️ Apenas para ambiente local
)

@app.post("/webhook/csv")
async def receive_csv_event(req: Request):
    try:
        payload = await req.json()
        record = payload["Records"][0]
        event_name = record.get("eventName", "")
        key = record["s3"]["object"]["key"]

        if not key.endswith(".csv"):
            raise HTTPException(status_code=400, detail="Arquivo não é CSV.")

        print(f"📥 Evento recebido: {event_name} | Arquivo: {key}")

        # Baixa o CSV do MinIO
        obj = minio_client.get_object(BUCKET_NAME, key)
        csv_data = obj.read()

        df = pd.read_csv(BytesIO(csv_data))

        print("✅ CSV processado com sucesso:")
        print(df.head())  # Aqui você pode substituir por outro tratamento

        return {"status": "ok", "message": "CSV processado com sucesso"}

    except Exception as e:
        print(f"❌ Erro ao processar CSV: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
