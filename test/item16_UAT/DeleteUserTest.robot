* Settings *
Library           SeleniumLibrary
Library           DatabaseLibrary
Suite Setup       Connect To My Database
Suite Teardown    Run Keywords    Close All Browsers    AND    Disconnect From Database

* Variables *
# Database Configuration
${DB_NAME}        postgres
${DB_USER}        postgres.sagopmktdtfejqbjnsar
${DB_PASS}        nokear12819
${DB_HOST}        aws-1-ap-south-1.pooler.supabase.com
${DB_PORT}        5432

# UI Configuration
${BASE_URL}       https://painumder.cpkku.com/profile/
${BROWSER}        chrome
${USERNAME}       TestDeleteUser
${PASSWORD}       123456789

* Test Cases *
User Delete Account And Verify Audit Table
    [Documentation]    ทดสอบการลบบัญชี และตรวจสอบว่าข้อมูลไปปรากฏในตาราง deleted_users จริง
    
    # 1. เข้าสู่ระบบ
    Login As User

    Sleep    5s

    # 2. ทำการลบบัญชี
    Delete Account Process


    Attempt Login Should Fail


    # 4. ตรวจสอบใน Database ว่ามีข้อมูลในตาราง Audit (deleted_users)
    # ใส่ Sleep เพื่อให้ชัวร์ว่า Database บันทึกข้อมูลเรียบร้อย
    Sleep    3s
    Deleted User Should Exist In Audit Table

* Keywords *
Connect To My Database
    Connect To Database    psycopg2    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}
    Log To Console    \nConnected to Supabase for Audit Check.

Login As User
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Input Text      id=identifier    ${USERNAME}
    Input Text      id=password      ${PASSWORD}
    Click Button    เข้าสู่ระบบ
    Wait Until Location Contains    https://painumder.cpkku.com/    timeout=10s

Delete Account Process
    [Documentation]    รอจนกว่าหน้าแรกจะโหลดเสร็จก่อนย้ายไปหน้า Profile
    # ตรวจสอบว่า URL ปัจจุบันคือหน้าแรกจริง (ระวังเรื่องเครื่องหมาย / ท้าย URL)
    # Wait Until Location Contains    https://painumder.cpkku.com/.* timeout=10s
    
    # หรือใช้วิธีรอ Element บางอย่างที่อยู่ในหน้าแรกให้ปรากฏก่อน
    # Wait Until Element Is Visible    xpath=//nav    timeout=10s

    # ย้ายไปหน้า Profile
    Go To           https://painumder.cpkku.com/profile
    
    # เช็คว่าย้ายมาหน้า profile จริงหรือไม่
    Wait Until Location Contains    /profile    timeout=10s
    
    Wait Until Element Is Visible    xpath=//button[contains(., 'ลบบัญชี')]    timeout=10s
    Click Button    xpath=//button[contains(., 'ลบบัญชี')]
    
    ${INPUT_CONFIRM_PASS}    Set Variable    xpath=//input[@placeholder='กรอกรหัสผ่าน']
    Wait Until Element Is Visible    ${INPUT_CONFIRM_PASS}    timeout=5s
    
    # 4. กรอกรหัสผ่านและยืนยัน
    Input Password    ${INPUT_CONFIRM_PASS}    ${PASSWORD}
    
    # คลิกปุ่มยืนยันการลบ (ใช้ข้อความบนปุ่ม)
    Click Button    xpath=//button[contains(., 'ยืนยันการลบ')]

    Handle Alert    action=ACCEPT    timeout=10s

    Wait Until Location Contains    https://painumder.cpkku.com/    timeout=10s

Attempt Login Should Fail
    Go To           ${BASE_URL}
    Input Text      id=identifier    ${USERNAME}
    Input Text      id=password      ${PASSWORD}
    Click Button    เข้าสู่ระบบ
    # ตรวจสอบว่าต้องมีข้อความแจ้งเตือนความผิดพลาด
    Wait Until Page Contains    เข้าสู่ระบบไม่สำเร็จ    timeout=10s

Deleted User Should Exist In Audit Table
    [Documentation]    เช็คว่าในตาราง deleted_users มี Username นี้โผล่ขึ้นมา
    # ใช้ Row Count เพื่อเช็คจำนวน หรือ Query เพื่อเช็คข้อมูล
    ${result}=    Query    SELECT "username", "deletedAt" FROM "UserArchive" WHERE "username"='${USERNAME}' ORDER BY "deletedAt" DESC LIMIT 1;
    Should Not Be Empty    ${result}    msg=ไม่พบประวัติการลบของยูสเซอร์ ${USERNAME} ในตาราง deleted_users
    Log To Console    Verified: User '${USERNAME}' exists in Audit Table.