# Change log
เอกสารนี้ใช้บันทึกการเปลี่ยนแปลงที่สำคัญของระบบ


##Sprint 3 [17-03-2569]

# Added
-	Feature: 
    - การลบบัญชีผู้ใช้แบบ Soft Delete 
    - การส่งข้อมูลของผู้ใช้ให้ผู้ใช้ผ่านอีเมล เมื่อผู้ใช้ทำการลบบัญชี
-	UI: 
    - เพิ่ม checkbox เลือกข้อมูลที่ต้องการส่งไปยังอีเมล ก่อนใส่รหัสผ่านลบบัญชี เมื่อผู้ใช้ต้องการลลบบัญชี
    - เพิ่มการใส่รหัสผ่านก่อน Export ข้อมูลในหน้า Traffic log
-	Backend:  
    - 
-   เพิ่มโครงสร้าง Export File ดังนี้<br>
        traffic_logs_<timestamp>.zip : 
          <br>- traffic_logs_<timestamp>.json
          <br>- traffic_logs_<timestamp>.sha256
          <br>- verify-log.bat
        
# Changed
- ปรับปรุง Database Schema (Prisma) 
    - +เพิ่ม TrafficLog, ExportLog
    - -ลบ ActivityLog, UserArchive
- ฟังก์ชันส่งเมล
- ปรับเปลี่ยน test data ใน api testing item1
- เปลี่ยนรูปแบบการป้องกันไฟล์ Traffic Log จาก AES-256 Encryption เป็น SHA-256 HASH integrity Verification
- เปลี่ยนวิธีการดาวน์โหลดไฟล์จาก Encrypted Binary (.enc) เป็น ZIP Archive

รายงานฉบับนี้ นําปัญญาประดิษฐ์ ChatGPT, Gemini, copilot มาใช้ในขั้นตอนดังต่อไปนี้ 
- ใช้ในการช่วยแก้ไขข้อผิดพลาดของโค้ด 
- ใช้แนะนำแนวทางในการพัฒนาฟังก์ชันการทำงาน 
- ใช้ในการช่วยแนะนำการตั้งค่าสภาพแวดล้อมการทำงานของโปรเจค 
- แก้ api url ใน frontend ทั้งหมด 
- ช่วยคิดและสร้างสร้างโค้ด api testing automate 90% และช่วยคิด testcase senario 
- ช่วยสร้าง UI หน้า Traffic Log และหน้า Export Log 
- ช่วยในการเขียนทำฟังก์ชันการส่งอีเมลทั้งหมด
โดยข้าพเจ้าได้ตรวจสอบความถูกต้องและแก้ไขข้อผิดพลาดอันเนื่องมาจากผลลัพธ์จากปัญญาประดิษฐ์เรียบร้อยแล้ว

