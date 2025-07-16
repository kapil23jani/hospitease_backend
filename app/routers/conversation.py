from fastapi import APIRouter, HTTPException, Form, UploadFile, File
from fastapi import FastAPI, Request
import os
import uuid
from google.cloud import texttospeech, speech_v1p1beta1 as speech
from langchain.agents import initialize_agent, AgentType
from langchain_openai import ChatOpenAI
import json
from langchain.tools import BaseTool
from pydantic import BaseModel, Field
import whisper

router = APIRouter()

AUDIO_DIR = "static/audio"
os.makedirs(AUDIO_DIR, exist_ok=True)
required_fields = [ "mobile", "address", "department", "problem"]
try:
    tts_client = texttospeech.TextToSpeechClient()
    stt_client = speech.SpeechClient()
    llm = ChatOpenAI(model="gpt-4o", temperature=0.3)
except Exception as e:
    print(f"API क्लाइंट को इनिशियलाइज़ करने में त्रुटि: {e}")

class FollowUpQuestionInput(BaseModel):
    question: str = Field(description="The follow-up question to ask the user.")

class AskFollowUpQuestionTool(BaseTool):
    name: str = "ask_follow_up_question"
    description: str = "Useful for asking the user a follow-up question when more information is needed to complete the complaint details."
    args_schema: type = FollowUpQuestionInput

    def _run(self, question: str):
        return f"FOLLOW_UP_QUESTION:{question}"

    def _arun(self, question: str):
        raise NotImplementedError("This tool does not support async operations")

follow_up_tool = AskFollowUpQuestionTool()

agent = initialize_agent(
    tools=[follow_up_tool],
    llm=llm,
    agent=AgentType.CONVERSATIONAL_REACT_DESCRIPTION,
    verbose=True
)

def tts(text: str, lang: str = "hi", voice: str = "female", base_url: str = "http://localhost:8000") -> str:
    if not text or not text.strip():
        text = "क्षमा करें, कोई संदेश उपलब्ध नहीं है।"
    input_text = texttospeech.SynthesisInput(text=text)
    voice_params = texttospeech.VoiceSelectionParams(
        language_code="hi-IN",
        ssml_gender=texttospeech.SsmlVoiceGender.FEMALE if voice == "female" else texttospeech.SsmlVoiceGender.MALE
    )
    audio_config = texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.MP3)
    try:
        response = tts_client.synthesize_speech(input=input_text, voice=voice_params, audio_config=audio_config)
        filename = f"{uuid.uuid4().hex}.mp3"
        path = os.path.join(AUDIO_DIR, filename)
        with open(path, "wb") as out:
            out.write(response.audio_content)
        return f"{base_url}/static/audio/{filename}"
    except Exception as e:
        print(f"TTS सिंथेसिस के दौरान त्रुटि: {e}")
        return ""

whisper_model = whisper.load_model("large-v3")

def stt(audio_content: bytes, sample_rate_hertz: int, language_code: str = "hi") -> str:
    temp_filename = "temp_audio_input.wav"
    with open(temp_filename, "wb") as f:
        f.write(audio_content)
    print(f"[Whisper] Saved audio for Whisper: {temp_filename}")
    result = whisper_model.transcribe(temp_filename, language="hi")
    transcript = result.get("text", "").strip()
    print(f"[Whisper] Transcript: {transcript}")
    return transcript

def run_agent_for_followup(user_details: dict) -> str:
    prompt = (
        f"तुम एक दोस्ताना शिकायत अधिकारी हो। यूज़र ने ये जानकारी दी है: {json.dumps(user_details, ensure_ascii=False)}।\n"
        "अगर कोई जानकारी अधूरी या अस्पष्ट लगती है, तो विनम्रता से और स्पष्ट भाषा में एक सवाल पूछो।\n"
        "अगर सब जानकारी पूरी है, तो कहो '✅ धन्यवाद! आपकी शिकायत दर्ज कर ली गई है। हम जल्द ही आपसे संपर्क करेंगे।'\n"
        "जवाब सिर्फ हिंदी में दो।"
    )
    output = agent.run({"input": prompt, "chat_history": []})
    print("🤖 Agent output:", output)
    return output

def get_next_question(current_data):
    missing_fields = [field for field in required_fields if field not in current_data or not current_data[field].strip()]
    if not missing_fields:
        return None
    prompt = (
        f"तुम एक शिकायत अधिकारी हो। अब तक यूज़र ने ये जानकारी दी है: {json.dumps(current_data, ensure_ascii=False)}। "
        f"अभी '{missing_fields[0]}' जानकारी नहीं मिली है। कृपया सिर्फ उसी के लिए एक विनम्र सवाल पूछो।"
        "अगर सब जानकारी मिल गई है, तो शिकायत दर्ज करने की पुष्टि करो। जवाब सिर्फ हिंदी में दो।"
    )
    question = llm.invoke(prompt)
    if hasattr(question, "content"):
        question = question.content
    return str(question)

MAX_TTS_LENGTH = 4900

def safe_tts_text(text):
    encoded = text.encode("utf-8")
    if len(encoded) > MAX_TTS_LENGTH:
        truncated = encoded[:MAX_TTS_LENGTH].decode("utf-8", errors="ignore")
        return truncated + " ...[उत्तर लंबा था, कृपया संक्षिप्त करें]"
    return text

def clean_reply_text(text):
    unwanted_phrases = ["tarankan", "सारांश:", "summary:"]
    for phrase in unwanted_phrases:
        text = text.replace(phrase, "")
    return text.strip()

def sanitize_reply_text(text):
    text = text.replace("*", "")
    text = text.replace("•", "")
    import re
    text = re.sub(r"\d+\.\s*", lambda m: f"\n{m.group(0)}", text)
    text = re.sub(r"\n{2,}", "\n", text)
    text = text.strip()
    return text

@router.post("/api/complaint/start_no_session_audio_in")
async def start_complaint_no_session_audio_in(request: Request):
    welcome_message = "नमस्ते! मैं आपकी शिकायत दर्ज करने में मदद करूंगा। शुरू करने के लिए, कृपया अपना पूरा नाम बताइए।"
    base_url = str(request.base_url).rstrip("/")
    audio_url = tts(welcome_message, base_url=base_url)
    return {
        "prompt": welcome_message,
        "audio_url": audio_url,
        "next_field_to_ask": "name",
        "current_data": {}
    }

@router.post("/api/complaint/talk_no_session_audio_in")
async def complaint_talk_no_session_audio_in(
    audio_file: UploadFile = File(...),
    sample_rate_hertz: int = Form(...),
    next_field_to_ask: str = Form(...),
    current_data_json: str = Form("{}"),
    request: Request = None
):
    try:
        current_data = json.loads(current_data_json)
    except json.JSONDecodeError:
        raise HTTPException(status_code=400, detail="Invalid current_data_json format.")
    audio_content = await audio_file.read()
    user_input_text = stt(audio_content, sample_rate_hertz, language_code="hi")
    print("STT output:", user_input_text)
    if next_field_to_ask and user_input_text:
        current_data[next_field_to_ask] = user_input_text.strip()
    print("Updated current_data:", current_data)
    next_question = get_next_question(current_data)
    base_url = str(request.base_url).rstrip("/") if request else "http://localhost:8000"
    if next_question:
        audio_url = tts(next_question, base_url=base_url)
        return {
            "done": False,
            "prompt": next_question,
            "audio_url": audio_url,
            "next_field_to_ask": [field for field in required_fields if field not in current_data or not current_data[field].strip()][0],
            "current_data": current_data
        }
    else:
        confirm_text = "✅ धन्यवाद! आपकी शिकायत दर्ज कर ली गई है। हम जल्द ही आपसे संपर्क करेंगे।"
        audio_url = tts(confirm_text, base_url=base_url)
        return {
            "done": True,
            "prompt": confirm_text,
            "audio_url": audio_url,
            "next_field_to_ask": None,
            "current_data": current_data
        }

@router.post("/jarvis_hindi_audio")
async def jarvis_hindi_audio(
    audio_file: UploadFile = File(...),
    sample_rate_hertz: int = Form(48000)
):
    audio_content = await audio_file.read()
    user_text = stt(audio_content, sample_rate_hertz, language_code="hi")
    print(f"[Jarvis] User said: {user_text}")
    if not user_text:
        reply_text = "क्षमा करें, मुझे आपकी बात समझ नहीं आई। कृपया फिर से बोलें।"
    else:
        prompt = (
            "तुम एक कृषि विशेषज्ञ हो, जिसने 40 वर्षों तक कृषि में पीएचडी और अनुभव प्राप्त किया है। "
            "तुम हमेशा किसानों को उनकी समस्याओं का व्यावहारिक, वैज्ञानिक और सरल हिंदी में समाधान देते हो। "
            f"यूज़र ने पूछा: \"{user_text}\"। कृपया कृषि विशेषज्ञ की तरह विस्तार से जवाब दो।"
        )
        reply_text = llm.invoke(prompt)
        if hasattr(reply_text, "content"):
            reply_text = reply_text.content
        reply_text = str(reply_text)
    print(f"[Jarvis] Reply: {reply_text}")
    reply_text = clean_reply_text(reply_text)
    reply_text = sanitize_reply_text(reply_text)
    reply_text = safe_tts_text(reply_text)
    input_text = texttospeech.SynthesisInput(text=reply_text)
    voice_params = texttospeech.VoiceSelectionParams(
        language_code="hi-IN",
        ssml_gender=texttospeech.SsmlVoiceGender.FEMALE
    )
    audio_config = texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.MP3)
    response = tts_client.synthesize_speech(input=input_text, voice=voice_params, audio_config=audio_config)
    filename = f"{uuid.uuid4().hex}.mp3"
    path = os.path.join(AUDIO_DIR, filename)
    with open(path, "wb") as out:
        out.write(response.audio_content)
    audio_url = f"/static/audio/{filename}"
    return {
        "user_text": user_text,
        "reply_text": reply_text,
        "audio_url": audio_url
    }

@router.post("/jarvis_welcome")
async def jarvis_welcome(request: Request):
    welcome_message = (
        "नमस्ते! मैं आपका कृषि विशेषज्ञ हूँ "
        "मैं आपकी कृषि संबंधी समस्याओं का समाधान देने में मदद करूंगा। "
        "शुरू करने के लिए, कृपया अपना नाम बताइए।"
    )
    base_url = str(request.base_url).rstrip("/")
    audio_url = tts(welcome_message, base_url=base_url)
    return {
        "prompt": welcome_message,
        "audio_url": audio_url,
        "next_field_to_ask": "name",
        "current_data": {}
    }