from fastapi import APIRouter, HTTPException
import requests
import os
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

def get_zoom_credentials():
    return {
        "account_id": os.getenv("ZOOM_ACCOUNT_ID"),
        "client_id": os.getenv("ZOOM_CLIENT_ID"),
        "client_secret": os.getenv("ZOOM_CLIENT_SECRET"),
        "secret_token": os.getenv("ZOOM_SECRET_TOKEN"),
    }

def get_server_to_server_access_token():
    creds = get_zoom_credentials()
    url = "https://zoom.us/oauth/token"
    params = {
        "grant_type": "account_credentials",
        "account_id": creds["account_id"]
    }
    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }
    response = requests.post(
        url,
        params=params,
        auth=(creds["client_id"], creds["client_secret"]),
        headers=headers
    )
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response.json()["access_token"]

def create_zoom_meeting(access_token: str):
    url = "https://api.zoom.us/v2/users/me/meetings"
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    data = {
        "topic": "Live Consultation",
        "type": 1,
        "settings": {
            "join_before_host": True,
            "approval_type": 0
        }
    }
    response = requests.post(url, headers=headers, json=data)
    if response.status_code != 201:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    return response.json()

@router.post("/api/zoom/create_meeting_server")
async def api_create_zoom_meeting_server():
    access_token = get_server_to_server_access_token()
    meeting_info = create_zoom_meeting(access_token)
    return meeting_info