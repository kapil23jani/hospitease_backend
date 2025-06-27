import random
from faker import Faker
from datetime import datetime, timedelta
import os

fake = Faker('en_IN')

hospital_id = 3
genders = ['Male', 'Female']
blood_groups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
specializations = ['Cardiology', 'Neurology', 'Orthopedics', 'Pediatrics', 'Dermatology', 'Radiology', 'General Medicine', 'ENT', 'Gynecology']
titles = ['Dr.', 'Prof.', 'Dr. (Ms.)']

# Desktop path to save
desktop_path = os.path.join(os.path.expanduser("~"), "Desktop", "insert_doctors.sql")

values = []

for i in range(20):
    gender = random.choice(genders)
    first = fake.first_name_male() if gender == "Male" else fake.first_name_female()
    last = fake.last_name()
    specialization = random.choice(specializations)
    phone = fake.phone_number().replace(" ", "").replace("+91", "91")[:10]
    email = f"{first.lower()}.{last.lower()}{i}@hospital.com"
    experience = random.randint(1, 35)
    title = random.choice(titles)
    dob = fake.date_of_birth(minimum_age=30, maximum_age=65).strftime('%Y-%m-%d')
    blood_group = random.choice(blood_groups)
    mobile_number = phone
    emergency_contact = fake.phone_number().replace(" ", "").replace("+91", "91")[:10]
    address = fake.address().replace("'", " ")
    city = fake.city()
    state = fake.state()
    country = "India"
    zipcode = fake.postcode()
    license_number = f"MED{random.randint(10000,99999)}IND"
    license_authority = "Medical Council of India"
    expiry_date = (datetime.today() + timedelta(days=random.randint(365, 1825))).strftime('%Y-%m-%d')

    values.append(f"('{first}', '{last}', '{specialization}', '{phone}', '{email}', {experience}, TRUE, '{title}', '{gender}', '{dob}', '{blood_group}', '{mobile_number}', '{emergency_contact}', '{address}', '{city}', '{state}', '{country}', '{zipcode}', '{license_number}', '{license_authority}', '{expiry_date}', {hospital_id})")

# Write to SQL file
with open(desktop_path, "w", encoding="utf-8") as f:
    f.write("INSERT INTO doctors (first_name, last_name, specialization, phone_number, email, experience, is_active, title, gender, date_of_birth, blood_group, mobile_number, emergency_contact, address, city, state, country, zipcode, medical_licence_number, licence_authority, license_expiry_date, hospital_id) VALUES\n")
    f.write(",\n".join(values))
    f.write(";")

print(f"✅ SQL dump created successfully at: {desktop_path}")
