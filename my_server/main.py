from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import JSONResponse
import whisper
import tempfile, shutil, os
from transformers import pipeline
import spacy
import nltk
from nltk.tokenize import word_tokenize
from collections import Counter

# NLTK veri seti (ilk çalıştırmada indir)
nltk.download("punkt")

app = FastAPI()

# 🔁 Modelleri yükle
print("🔁 Whisper yükleniyor...")
model = whisper.load_model("base")

print("🔁 Özetleyici yükleniyor...")
summarizer = pipeline("summarization", model="facebook/mbart-large-cc25")

print("🔁 Text düzeltici yükleniyor...")
text2text = pipeline("text2text-generation", model="google/flan-t5-small")

print("🔁 Soru-cevap modeli yükleniyor...")
qa_pipeline = pipeline("question-answering", model="deepset/roberta-base-squad2")

print("🔁 SpaCy yükleniyor...")
spacy_nlp = spacy.load("en_core_web_sm")


# 🔎 Prompt eşleştirme
def match_prompt(prompt: str, keywords: list[str]) -> bool:
    prompt = prompt.lower()
    return any(word in prompt for word in keywords)

SUMMARY_WORDS = ["özet", "özetle", "summary", "summarize", "özet çıkar"]
FIX_WORDS = ["düzelt", "düzeltme", "fix", "correct", "grammar"]
QA_WORDS = ["soru", "sor", "question", "soru-cevap", "qa"]
KEYWORD_WORDS = ["kelime", "keywords", "anahtar kelime", "etiket"]

@app.post("/process/")
async def process_file(audio_file: UploadFile = File(...), prompt: str = Form(default="")):
    # Ses dosyasını geçici olarak kaydet
    with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as tmp:
        shutil.copyfileobj(audio_file.file, tmp)
        tmp_path = tmp.name

    # Whisper ile transkript al
    result = model.transcribe(tmp_path, fp16=False)
    os.remove(tmp_path)

    text = result["text"]
    lang = result["language"]

    output = {
        "language": lang,
        "transcript": text,
        "prompt": prompt
    }

    # Prompt analizine göre işlem
    if match_prompt(prompt, SUMMARY_WORDS):
        output["summary"] = summarizer(text, max_length=150, min_length=40, do_sample=False)[0]['summary_text']

    if match_prompt(prompt, QA_WORDS):
        output["question_answer"] = qa_pipeline(question="What is the topic?", context=text)["answer"]

    if match_prompt(prompt, FIX_WORDS):
        output["correction"] = text2text(f"Fix grammar: {text}")[0]['generated_text']

    if match_prompt(prompt, KEYWORD_WORDS):
        tokens = word_tokenize(text)
        keywords = [w.lower() for w in tokens if w.isalnum()]
        common = Counter(keywords).most_common(5)
        output["keywords"] = [k for k, _ in common]

    return JSONResponse(content=output)
