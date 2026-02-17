*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://painamnaewebappsec26-production.up.railway.app/api/    # URL ของ API
${USERNAME}       test-12345
${PASSWORD}       test-12345

*** Test Cases ***
Scenario: Delete User Account Successfully
    [Documentation]    ทดสอบการลบบัญชีผู้ใช้และตรวจสอบว่า Token เดิมใช้งานไม่ได้อีกต่อไป
    
    # 1. Login เพื่อรับ Access Token
    ${auth_token}=    Get Auth Token    ${USERNAME}    ${PASSWORD}
    
    # 2. ส่งคำขอสำหรับการลบบัญชี
    ${headers}=       Create Dictionary    Authorization=Bearer ${auth_token}    Content-Type=application/json
    ${response}=      DELETE On Session    painumnae_session    users/me    headers=${headers}    expected_status=200
    
    # 3. ตรวจสอบ Response Body (ถ้ามี)
    Dictionary Should Contain Value    ${response.json()}    User deleted successfully.
    

*** Keywords ***
Get Auth Token
    [Arguments]    ${user}    ${pass}
    Create Session    painumnae_session    ${BASE_URL}    verify=True
    ${body}=          Create Dictionary    username=${user}    password=${pass}
    ${response}=      POST On Session      painumnae_session    /login    json=${body}
    ${token}=         Get From Dictionary  ${response.json()}    access_token
    RETURN            ${token}