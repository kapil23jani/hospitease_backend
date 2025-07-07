import random
from faker import Faker
import os

fake = Faker('en_IN')  # For Indian names/addresses
start_id = 10001
hospital_id = 3

statuses = ['Married', 'Single', 'Widowed']
genders = ['Male', 'Female', 'Other']
blood_groups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
occupations = ['Teacher', 'Engineer', 'Doctor', 'Student', 'Farmer', 'Retired']

# Prepare file path on Mac Desktop
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop", "insert_patients.sql")

values = []
for i in range(500):
    first = fake.first_name()
    middle = fake.first_name() if random.choice([True, False]) else ''
    last = fake.last_name()
    dob = fake.date_of_birth(minimum_age=18, maximum_age=90).strftime('%Y-%m-%d')
    gender = random.choice(genders)
    phone = fake.phone_number().replace(" ", "").replace("+91", "91")[:10]
    landline = fake.phone_number() if random.choice([True, False]) else ''
    address = fake.street_address().replace("'", " ")
    landmark = fake.word()
    city = fake.city()
    state = fake.state()
    country = "India"
    blood = random.choice(blood_groups)
    email = f"{first.lower()}.{last.lower()}{i}@example.com"
    occupation = random.choice(occupations)
    dialysis = random.choice([True, False])
    zip_code = fake.postcode()
    marital = random.choice(statuses)
    patient_uid = str(start_id + i)

    values.append(f"('{first}', '{middle}', '{last}', '{dob}', '{gender}', '{phone}', '{landline}', '{address}', '{landmark}', '{city}', '{state}', '{country}', '{blood}', '{email}', '{occupation}', {dialysis}, '{zip_code}', '{marital}', '{patient_uid}', {hospital_id})")

# Write to file
with open(desktop_path, "w", encoding="utf-8") as f:
    f.write("INSERT INTO patients (first_name, middle_name, last_name, date_of_birth, gender, phone_number, landline, address, landmark, city, state, country, blood_group, email, occupation, is_dialysis_patient, zipcode, marital_status, patient_unique_id, hospital_id) VALUES\n")
    f.write(",\n".join(values))
    f.write(";")

print(f"✅ SQL dump created at: {desktop_path}")
