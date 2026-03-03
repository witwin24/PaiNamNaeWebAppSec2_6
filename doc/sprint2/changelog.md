# Change log
เอกสารนี้ใช้บันทึกการเปลี่ยนแปลงที่สำคัญของระบบ


##Sprint 2 [03-03-2569]

# Added
-	Feature: 
    - การลบบัญชีผู้ใช้แบบ Soft Delete 
    - การส่งข้อมูลของผู้ใช้ให้ผู้ใช้ผ่านอีเมล เมื่อผู้ใช้ทำการลบบัญชี
-	UI: 
    - เพิ่มหน้า Traffic Log เพื่อแสดงข้อมูลของ TrafficLog 
    - เพิ่ม ปุ่ม Export เพื่อ Export ข้อมูลของ TrafficLog 
    - เพิ่มหน้า Export Log เพื่อแสดงข้อมูลของ LogExportAdmin 
-	Backend:  
    - เพิ่ม TrafficLog เพื่อทำการเก็บ log การใช้งานตามกฎหมาย 
    - เพิ่ม LogExportAdmin เพื่อทำการเก็บ Log การ Export ข้อมูลของ TrafficLog
# Changed
- ปรับปรุง Database Schema (Prisma) 
    - +เพิ่ม TrafficLog, ExportLog
    - -ลบ ActivityLog, UserArchive

รายงานฉบับนี้ นําปัญญาประดิษฐ์ ChatGPT, Gemini, copilot มาใช้ในขั้นตอนดังต่อไปนี้ (1) ใช้ในการช่วยแก้ไขข้อผิดพลาดของโค้ด 
(2) ใช้แนะนำแนวทางในการพัฒนาฟังก์ชันการทำงาน (3) ใช้ในการช่วยแนะนำการตั้งค่าสภาพแวดล้อมการทำงานของโปรเจค (4) แก้ api url ใน frontend ทั้งหมด (5) ช่วยคิดและสร้างสร้างโค้ด api testing automate 90% และช่วยคิด testcase senario (6) ช่วยสร้าง UI หน้า Traffic Log และหน้า Export Log
โดยข้าพเจ้าได้ตรวจสอบความถูกต้องและแก้ไขข้อผิดพลาดอันเนื่องมาจากผลลัพธ์จากปัญญาประดิษฐ์เรียบร้อยแล้ว

