*** Settings ***
Library           SeleniumLibrary
Library           DatabaseLibrary
Suite Setup       Connect To My Database
Suite Teardown    Disconnect From Database

*** Variables ***
# Database Configuration
${DB_NAME}        postgres
${DB_USER}        postgres.sagopmktdtfejqbjnsar
${DB_PASS}        nokear12819
${DB_HOST}        aws-1-ap-south-1.pooler.supabase.com
${DB_PORT}        5432

# UI Configuration
${URL}            https://painumder.cpkku.com/login
${BROWSER}         chrome
${USERNAME}       test_Log
${PASSWORD}       123456789

# Locators
${INPUT_USER}      id=identifier
${INPUT_PASS}      id=password
${BTN_LOGIN}      xpath=//button[@type='submit' and contains(., 'เข้าสู่ระบบ')]

*** Keywords ***
Connect To My Database
    [Documentation]    เชื่อมต่อกับ Supabase PostgreSQL
    Connect To Database    psycopg2    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}

Get Activity Log Count
    [Documentation]    ดึงจำนวน Row ทั้งหมดในตาราง ActivityLog
    ${count}=    Row Count    SELECT * FROM "ActivityLog";
    RETURN    ${count}

*** Test Cases ***
Successful Login And Check Activity Log
    [Documentation]    ทดสอบการล็อกอินและเช็คค่า row ของคอลัม ActivityLog
    
    # 1. เชื่อมต่อ DB
    ${output}=    Query    SELECT NOW();
    Log To Console    Connected to DB at: ${output}

    ${count_before}=    Get Activity Log Count

    # 2. เปิดหน้าเว็บไซต์
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${INPUT_USER}    timeout=10s

    # 3. ทำการ Login
    Input Text       ${INPUT_USER}    ${USERNAME}
    Input Password   ${INPUT_PASS}    ${PASSWORD}
    Click Element    ${BTN_LOGIN}
    Wait Until Location Contains    https://painumder.cpkku.com/    timeout=10s
    [Teardown]    Close Browser

     Sleep    5s

    ${count_after}=    Get Activity Log Count

    # 4. เปรียบเทียบว่ามีการเพิ่มข้อมูล log ใน ActivityLog หรือไม่
    Should Be True    ${count_after} > ${count_before}  


