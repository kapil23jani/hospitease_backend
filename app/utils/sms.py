from dotenv import load_dotenv
import os
from twilio.rest import Client
import logging

logging.basicConfig(level=logging.DEBUG)

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../../.env'))

TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_FROM_NUMBER = os.getenv("TWILIO_FROM_NUMBER")

def send_sms(
    to_number: str,
    body: str
) -> dict:
    logging.info(f"Preparing to send SMS to {to_number} with body '{body}'")
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        message = client.messages.create(
            to=to_number,
            from_=TWILIO_FROM_NUMBER,
            body=body
        )
        logging.info(f"SMS sent to {to_number}, SID: {message.sid}")
        return {"sid": message.sid, "status": message.status}
    except Exception as e:
        logging.error(f"Error sending SMS to {to_number}: {e}")
        return {"error": str(e)}