import re

# Set your input and output file paths
input_file = "peoria_fire_users_new.sql"
output_file = "peoria_fire_users_new_inserts.sql"

def parse_copy_header(line):
    # Extract column names from COPY ... (col1, col2, ...) FROM stdin;
    match = re.search(r'COPY\s+\S+\s+\((.*?)\)\s+FROM', line, re.IGNORECASE)
    if match:
        columns = [col.strip() for col in match.group(1).split(',')]
        return columns
    return []

def convert_field(field):
    if field == r'\N' or field == '':
        return 'NULL'
    # Try to detect booleans
    if field in ('t', 'f'):
        return f"'{field}'"
    # Try to detect numbers (int or float)
    try:
        float(field)
        return field
    except ValueError:
        pass
    # Otherwise, treat as string
    return "'" + field.replace("'", "''") + "'"

def main():
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        columns = []
        in_copy = False
        for line in infile:
            line = line.rstrip('\n')
            if line.startswith("COPY "):
                columns = parse_copy_header(line)
                in_copy = True
                continue
            if in_copy:
                if line == r'\.':
                    in_copy = False
                    continue
                fields = line.split('\t')
                # Pad fields if line is short
                if len(fields) < len(columns):
                    fields += [''] * (len(columns) - len(fields))
                values = [convert_field(f) for f in fields]
                insert_stmt = f"INSERT INTO public.peoria_users ({', '.join(columns)}) VALUES ({', '.join(values)});"
                outfile.write(insert_stmt + "\n")

if __name__ == "__main__":
    main()