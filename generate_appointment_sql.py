import random
from faker import Faker
from datetime import datetime, timedelta, time
import os

fake = Faker('en_IN')

total_appointments = 2000
hospital_id = 3
start_uid = 10001
today = datetime.now().date()

# Save to Desktop
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop", "spread_appointments.sql")

problems = ["Fever", "Headache", "Back Pain", "Skin Rash", "Cough", "High BP", "Diabetes Check", "Routine Checkup"]
appointment_types = ["OPD", "Emergency", "Follow-up", "New"]

values = []
appointment_counter = 0
day_offset = 0

while appointment_counter < total_appointments:
    appointments_today = random.randint(20, 30)
    if appointment_counter + appointments_today > total_appointments:
        appointments_today = total_appointments - appointment_counter
    
    current_date = today + timedelta(days=day_offset)
    
    for _ in range(appointments_today):
        patient_id = random.randint(2, 501)
        doctor_id = random.randint(3, 10)

        hour = random.randint(11, 16)
        minute = random.choice([0, 15, 30, 45])
        appt_datetime = datetime.combine(current_date, time(hour, minute))
        appointment_date = appt_datetime.strftime('%Y-%m-%d')
        appointment_time = appt_datetime.strftime('%H:%M')

        problem = random.choice(problems)
        appointment_type = random.choice(appointment_types)
        reason = fake.sentence(nb_words=6)
        created_at = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        updated_at = created_at

        bp = f"{random.randint(100, 140)}/{random.randint(60, 90)}"
        pulse = str(random.randint(65, 100))
        temp = str(round(random.uniform(97.5, 100.5), 1))
        spo2 = str(random.randint(95, 100))
        weight = str(random.randint(55, 85))
        notes = fake.text(60)
        advice = fake.sentence(8)
        follow_up_date = (current_date + timedelta(days=random.randint(7, 30))).strftime('%Y-%m-%d')
        follow_up_notes = fake.sentence()
        status = "pending"
        appointment_uid = f"APT{start_uid + appointment_counter}"

        values.append(f"({patient_id}, {doctor_id}, '{appt_datetime}', '{problem}', '{appointment_type}', '{reason}', '{created_at}', '{updated_at}', {hospital_id}, '{bp}', '{pulse}', '{temp}', '{spo2}', '{weight}', '{notes}', '{advice}', '{follow_up_date}', '{follow_up_notes}', '{appointment_date}', '{appointment_time}', '{status}', '{appointment_uid}')")

        appointment_counter += 1
    
    day_offset += 1

# Write to SQL file
with open(desktop_path, "w", encoding="utf-8") as f:
    f.write("INSERT INTO appointments (patient_id, doctor_id, appointment_datetime, problem, appointment_type, reason, created_at, updated_at, hospital_id, blood_pressure, pulse_rate, temperature, spo2, weight, additional_notes, advice, follow_up_date, follow_up_notes, appointment_date, appointment_time, status, appointment_unique_id) VALUES\n")
    f.write(",\n".join(values))
    f.write(";")

print(f"✅ 2000 appointments created across multiple days — saved to: {desktop_path}")
