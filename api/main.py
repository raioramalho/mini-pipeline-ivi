from fastapi import FastAPI, Request, HTTPException
from minio import Minio
from io import BytesIO
import requests
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
        
        data = df[["idade", "genero", "renda_mensal"]].to_dict(orient="records")
        
        # realizar. request com os dados em json
        reques = {
            "url": "https://api.powerbi.com/beta/da49a844-e2e3-40af-86a6-c3819d704f49/datasets/e2930daa-e554-4c90-80fd-a584ba525d16/rows?experience=power-bi&key=L%2Bs0U6BbOhep0N%2BttTjVIKbILZzCy%2FPUzfpvIfSD1GOjjNu6nSC1yr8vJ1yjLhHmlOJspR5UIQbQmWZsGLmCOg%3D%3D",
            "method": "POST",
            "headers": {"Content-Type": "application/json"},
            "data": data
        }

        # realiza o post        
        response = requests.post(reques["url"], headers=reques["headers"], json=reques["data"])
        
        if response.status_code != 200:
            print(f"❌ Erro ao enviar dados: {response.status_code} - {response.text}")
            

        print("✅ CSV processado com sucesso:")
        print(df.head())  # Aqui você pode substituir por outro tratamento

        return {"status": "ok", "message": "CSV processado com sucesso"}

    except Exception as e:
        print(f"❌ Erro ao processar CSV: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
