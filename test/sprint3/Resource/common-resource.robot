*** Settings ***

Library     SeleniumLibrary
Library     DatabaseLibrary
Library     OperatingSystem

*** Variables ***
# Database Configuration
#${DB_NAME}        postgres
#${DB_USER}        postgres.sagopmktdtfejqbjnsar
#${DB_PASS}        nokear12819
#${DB_HOST}        aws-1-ap-south-1.pooler.supabase.com
#${DB_PORT}        5432

# UI Configuration
${URL}		https://csse2669.cpkku.com
${BROWSER}	chrome

# Download path
${DOWNLOAD_PATH}    ${CURDIR}${/}downloads

${DELAY}	0s

*** Keywords ***
Connect To My Database
    [Documentation]     เชื่อมต่อกับ Supabase PostgreSQL
    Connect To Database     psycopg2    ${DB_NAME}  ${DB_USER}  ${DB_PASS}  ${DB_HOST}    ${DB_PORT}

My Log To Console
    Log To Console    \nConnected to PostgreSQL.

Open Main Page
    [Documentation]     เปิดหน้าเว็บไซต์หลัก
    Create Directory    ${DOWNLOAD_PATH}
    ${prefs}=    Create Dictionary    download.default_directory=${DOWNLOAD_PATH}

    Open Browser    ${URL}    ${BROWSER}    options=add_experimental_option("prefs", ${prefs})
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}  

Go To Login Page
    [Documentation]     เปิดหน้าเข้าสู่ระบบ
	Go To	${URL}/login
	Login Page Should Be Open

Login Page Should Be Open
    Wait Until Location Contains	${URL}/login		timeout=2s
	Wait Until Element Is Visible    id=identifier    timeout=2s
	Element Text Should Be		xpath=//main//h1    เข้าสู่ระบบ
	
Go To Register Page
    [Documentation]     เปิดหน้าลงทะเบียน
	Go To	${URL}/register
	Register Page Should Be Open

Register Page Should Be Open
	Wait Until Location Contains	${URL}/register		timeout=2s
    Element Text Should Be		xpath=//main//h1    สมัครสมาชิก

Go To Profile Page
    [Documentation]     เปิดหน้าข้อมูลส่วนตัว
	Go To	${URL}/profile
	Profile Page Should Be Open

Profile Page Should Be Open
	Wait Until Location Contains	${URL}/profile		timeout=2s
	Wait Until Element Is Visible    xpath=//button[contains(., 'ลบบัญชี')]    timeout=5s

Register Form
    [Documentation]     สมัครข้อมูลผู้ใช้ใหม่
    [Arguments]    ${username}	${email}	${password}     
    ...     ${firstname}		${lastname}		${phonenumber}	${value}    
    ...     ${idcardfile}	${idnumber}		${expirydate}	${selfiefile}
    Input Text    id=username	${username}   
    Input Text    id=email	${email} 
    Input Text    id=password	${password}
    Input Text    id=confirmPassword	${password}
    Execute JavaScript	document.querySelector('nuxt-devtools-frame')?.remove();
    Click Next Button
    sleep   1s
  
    Input Text    id=firstName	${firstname}
    Input Text    id=lastName	${lastname}
    Input Text    id=phoneNumber	${phonenumber}
	Select Radio Button    gender	${value}
    Click Next Button
    sleep   1s
	
	Choose File		id=idCardFile	${idcardfile}
    Input Text		id=idNumber		${idnumber}
    Input Text		id=expiryDate	${expirydate}
	Choose File     id=selfieFile	${selfiefile}
	Click Element   xpath=//span[contains(text(),"ข้าพเจ้ายินยอมรับ")]/preceding-sibling::input
    Click Register Button
    sleep   1s

    Wait Until Element Is Visible
    ...    xpath=//div[contains(., 'สมัครสมาชิกเรียบร้อยแล้ว')]    timeout=5s
    
    Wait Until Location Contains	${URL}		timeout=2s
	
Login
    [Documentation]     ลงทะเบียนผู้ใช้
	[Arguments]		${username}	${password}
	Input Text      id=identifier    ${username}
    Input Text      id=password      ${password}
	Click Login button
    sleep   1s
	
Delete User Account
    [Documentation]     ลบบัญชีผู้ใช้งาน
    [Arguments]	    ${password}     ${massage}
    Wait Until Element Is Visible    xpath=//button[contains(., 'ลบบัญชี')]    timeout=5s
    Click Delete User Button
    
    ${INPUT_CONFIRM_PASS}    Set Variable    xpath=//input[@placeholder='กรอกรหัสผ่าน']
    Wait Until Element Is Visible    ${INPUT_CONFIRM_PASS}    timeout=5s
    Input Password    ${INPUT_CONFIRM_PASS}    ${password}
    Click Comfirm Delete

    sleep   2s
    ${actual_msg}=    Handle Alert    action=ACCEPT
    Should Be Equal    ${actual_msg}    ${massage}
    Wait Until Location Contains	${URL}		timeout=2s

Admin Go To Log Page
    [Documentation]     เปิดหน้าlog
	Go To	${URL}/admin/traffic-log
	Log Page Should Be Open

Log Page Should Be Open
    Wait Until Location Contains	${URL}/admin/traffic-log		timeout=2s

Admin Go To ExportLog Page
    [Documentation]     เปิดหน้าlog
	Go To	${URL}/admin/export-log
	ExportLog Page Should Be Open
    Wait Until Element Is Visible    id=details    timeout=10s

ExportLog Page Should Be Open
    Wait Until Location Contains	${URL}/admin/export-log		timeout=2s

Admin Filter With ID
    [Arguments]     ${userid}
    Wait Until Element Is Visible    id=userID    timeout=5s
    Wait Until Element Is Enabled    id=userID    timeout=5s

    Input Text            id=userID    ${userid}
    sleep   2s

Admin Filter With AdminID
    [Arguments]     ${adminid}
    Wait Until Element Is Visible    id=adminID    timeout=5s
    Wait Until Element Is Enabled    id=adminID    timeout=5s

    Input Text            id=adminID    ${adminid}
    sleep   2s

Admin Check Log Single Id
    ${rows}=    Get Element Count    xpath=//table/tbody/tr
    ${first_value}=    Get Text    xpath=//table/tbody/tr[1]/td[1]

    FOR    ${i}    IN RANGE    1    ${rows}+1
        ${value}=    Get Text    xpath=//table/tbody/tr[${i}]/td[1]
        Should Be Equal As Strings    ${value}    ${first_value}
    END

Admin Check Empty Traffic-Log Filter
    ${value}=    Get Element Attribute    id=userID    value
    Should Be Empty    ${value}

Admin Check Empty Traffic-Log table
    Wait Until Element Is Visible    xpath=//table/tbody/tr    timeout=10s
    Element Should Contain    xpath=//table/tbody/tr[1]/td    ไม่มีข้อมูล Traffic Log

Admin Filter Log With Startdatetime
    [Arguments]     ${startdate}    ${starttime}
    Wait Until Element Is Visible    id=userID    5s

    Input Text    id=startTime  ${startdate}
    Press Keys    NONE  TAB
    Input Text    id=startTime  ${starttime}
    sleep   2s

Admin Filter Log With Enddatetime
    [Arguments]     ${enddate}  ${endtime}
    Wait Until Element Is Visible    id=userID    5s

    Input Text    id=endTime    ${enddate}
    Press Keys    NONE  TAB
    Input Text    id=endTime    ${endtime}
    sleep   2s

Check If CSV Exists
    ${files}=    List Directory    ${DOWNLOAD_PATH}
    Should Match Regexp    ${files[0]}    .*\.csv    # วิธีนี้จะเช็คไฟล์แรกที่เจอ

Click Download And Verify By Counting
    ${count_before}=    Count Items In Directory    ${DOWNLOAD_PATH}
    
    Admin Click Export Log Button

    Wait Until Keyword Succeeds    20s    2s    Check If File Count Increased    ${count_before}

Check If File Count Increased
    [Arguments]    ${old_count}
    ${new_count}=    Count Items In Directory    ${DOWNLOAD_PATH}
    Should Be True    ${new_count} > ${old_count}

Click Next Button
	Click Button	ถัดไป
	
Click Register Button
	Click Button	สมัครสมาชิก
	
Click Login Button
	Click Button    เข้าสู่ระบบ

Click Delete User Button
    Click Button    xpath=//button[contains(., 'ลบบัญชี')]
	
Click Comfirm Delete
	Click Button	xpath=//button[contains(., 'ยืนยันการลบ')]
    sleep   2s

Admin Click Filter Button
    Click Button	id=applyFilters
    sleep   2s

Admin Click Clear Log Button
    Click Button	id=clearFilters

Admin Click Export Log Button
    Click Button	Export

Admin Click Detail Button
    Click Button	id=details
