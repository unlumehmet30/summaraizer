from fastapi import FastAPI, UploadFile, File
import whisper
import uvicorn
import tempfile
import shutil
import torch

app = FastAPI()

# CPU için thread sayısını çekirdek sayına göre ayarla
torch.set_num_threads(4)

# Base model yükle
model = whisper.load_model("base")

@app.post("/transcribe/")
async def transcribe(audio_file: UploadFile = File(...)):
    # Dosyayı geçici olarak kaydet
    with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as tmp:
        shutil.copyfileobj(audio_file.file, tmp)
        tmp_path = tmp.name

    # Model ile transkripte et (beam search kapalı, CPU uyumlu)
    result = model.transcribe(tmp_path, beam_size=1, fp16=False, language='tr')
    
    return {"text": result["text"]}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
