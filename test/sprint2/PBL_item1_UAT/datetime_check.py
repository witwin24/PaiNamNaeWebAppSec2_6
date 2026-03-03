import datetime

def convert_thai_table_time_to_datetime(thai_str):
    # ตัวอย่าง thai_str: "3 มี.ค. 2569 11:22:07"
    thai_months = {
        "ม.ค.": 1, "ก.พ.": 2, "มี.ค.": 3, "เม.ย.": 4, "พ.ค.": 5, "มิ.ย.": 6,
        "ก.ค.": 7, "ส.ค.": 8, "ก.ย.": 9, "ต.ค.": 10, "พ.ย.": 11, "ธ.ค.": 12
    }
    parts = thai_str.split()
    day = int(parts[0])
    month = thai_months[parts[1]]
    year = int(parts[2]) - 543  # แปลง พ.ศ. เป็น ค.ศ.
    time_part = parts[3]
    
    dt_str = f"{year}-{month:02d}-{day:02d} {time_part}"
    return datetime.datetime.strptime(dt_str, "%Y-%m-%d %H:%M:%S")

def convert_input_to_datetime(date_str, time_str):
    # date_str: 02032026, time_str: 1139AM
    # แปลงเป็น: 2026-03-02 11:39:00
    dt = datetime.datetime.strptime(f"{date_str} {time_str}", "%d%m%Y %I%M%p")
    return dt