*** Settings ***

Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
# UI Configuration
${URL}		https://csse2669.cpkku.com
${BROWSER}	chrome

# Download
${DOWNLOAD_PATH}    ${CURDIR}${/}downloads

${DELAY}	0s

*** Keywords ***
Open Main Page
    [Documentation]     เปิดหน้าเว็บไซต์หลัก

    Create Directory    ${DOWNLOAD_PATH}
    ${prefs}=    Create Dictionary    download.default_directory=${DOWNLOAD_PATH}

    Open Browser    ${URL}    ${BROWSER}    options=add_experimental_option("prefs", ${prefs})
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}  

Go To Login Page
    [Documentation]     เปิดหน้าเข้าสู่ระบบ
	Click Go To Login Page
	Login Page Should Be Open

Login Page Should Be Open
	Wait Until Location Contains	${URL}/login		timeout=2s
	Wait Until Element Is Visible    id=identifier    timeout=2s
	Element Text Should Be		xpath=//main//h1    เข้าสู่ระบบ
	
Go To Register Page
    [Documentation]     เปิดหน้าลงทะเบียน
	Click Go To Register Page
	Register Page Should Be Open

Register Page Should Be Open
	Wait Until Location Contains	${URL}/register		timeout=2s
    Element Text Should Be		xpath=//main//h1    สมัครสมาชิก

Go To Profile Page
    [Documentation]     เปิดหน้าข้อมูลส่วนตัว
    Click My Profile
	Profile Page Should Be Open
    sleep    5s

Profile Page Should Be Open
	Wait Until Location Contains	${URL}/profile		timeout=2s
	Wait Until Element Is Visible    xpath=//button[contains(., 'ลบบัญชี')]    timeout=5s

Register Form
    [Documentation]     สมัครข้อมูลผู้ใช้ใหม่
    [Arguments]    ${username}	${email}	${password}     
    ...     ${firstname}		${lastname}		${phonenumber}	${value}    
    ...     ${idnumber}		${expirydate}
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
	
    ${IMAGE_PATH}    Join Path    ${CURDIR}    ..    ..    ..    img    Test_image.png
    ${IMAGE_PATH}    Normalize Path    ${IMAGE_PATH}

	Choose File		id=idCardFile	${IMAGE_PATH}
    Input Text		id=idNumber		${idnumber}
    Input Text		id=expiryDate	${expirydate}
	Choose File     id=selfieFile	${IMAGE_PATH}
	Click Element   xpath=//span[contains(text(),"ข้าพเจ้ายินยอมรับ")]/preceding-sibling::input
    Click Register Button
    sleep   1s

    Wait Until Element Is Visible
    ...    xpath=//div[contains(., 'สมัครสมาชิกเรียบร้อยแล้ว')]    timeout=10s

    Click Element    xpath=//button[contains(text(),'ไปสู่หน้าเข้าสู่ระบบ')]
    
    Wait Until Location Contains	${URL}		timeout=2s
	
Login
    [Documentation]     ลงทะเบียนผู้ใช้
	[Arguments]		${username}	${password}
	Input Text      id=identifier    ${username}
    Input Text      id=password      ${password}
	Click Login button
    sleep   2s
	
Delete User Account
    [Documentation]     ลบบัญชีผู้ใช้งาน
    [Arguments]         ${password}     ${massage}      ${dataoption}
    Wait Until Element Is Visible    xpath=//button[contains(., 'ลบบัญชี')]    timeout=5s
    Click Delete User Button

    # XPath ใหม่ — ตรงกับ HTML จริง (label > input)
    ${CHECKBOX_ALL}=        Set Variable    xpath=//label[.//p[contains(text(),'เลือกทั้งหมด')]]/input[@type='checkbox']
    ${CHECKBOX_PERSONAL}=   Set Variable    xpath=//label[.//p[contains(text(),'ข้อมูลส่วนตัว')]]/input[@type='checkbox']

    Wait Until Element Is Visible    ${CHECKBOX_ALL}    timeout=10s

    Checkbox Should Be Selected    ${CHECKBOX_ALL}

    IF    '${dataoption}' == 'all'
        Checkbox Should Be Selected    ${CHECKBOX_ALL}

    ELSE IF    '${dataoption}' == 'personal'
        Click Element    ${CHECKBOX_ALL}
        Checkbox Should Not Be Selected    ${CHECKBOX_ALL}

        ${is_checked}=    Run Keyword And Return Status    Checkbox Should Be Selected    ${CHECKBOX_PERSONAL}
        IF    not ${is_checked}
            Click Element    ${CHECKBOX_PERSONAL}
        END
        Checkbox Should Be Selected    ${CHECKBOX_PERSONAL}

    ELSE IF    '${dataoption}' == 'none'
        Click Element    ${CHECKBOX_ALL}
        Checkbox Should Not Be Selected    ${CHECKBOX_ALL}
        Checkbox Should Not Be Selected    ${CHECKBOX_PERSONAL}
    END

    Click Element    xpath=//button[contains(., 'ถัดไป')]

    ${INPUT_CONFIRM_PASS}    Set Variable    xpath=//input[@placeholder='กรอกรหัสผ่าน']
    Wait Until Element Is Visible    ${INPUT_CONFIRM_PASS}    timeout=5s
    Input Password    ${INPUT_CONFIRM_PASS}    ${password}
    Click Comfirm Delete

    Sleep    2s
    ${actual_msg}=    Handle Alert    action=ACCEPT
    Should Be Equal    ${actual_msg}    ${massage}
    Wait Until Location Contains    ${URL}    timeout=2s


Admin Go To Log Page
    [Documentation]     เปิดหน้า log
    Admin Click Dashboard
	Click Element    xpath=//a[@href="/admin/traffic-log"]
	Log Page Should Be Open

Log Page Should Be Open
    Wait Until Location Contains	${URL}/admin/traffic-log		timeout=2s

Admin Go To ExportLog Page
    [Documentation]     เปิดหน้า Exportlog
    Admin Click Dashboard
	Click Element    xpath=//a[@href="/admin/export-log"]
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

Admin Check Log Single Id
    ${rows}=    Get Element Count    xpath=//table/tbody/tr
    ${first_value}=    Get Text    xpath=//table/tbody/tr[1]/td[1]

    FOR    ${i}    IN RANGE    1    ${rows}+1
        ${value}=    Get Text    xpath=//table/tbody/tr[${i}]/td[1]
        Should Be Equal As Strings    ${value}    ${first_value}
    END

Admin Check Empty Traffic-Log Filter
    ${userid_value}=    Get Element Attribute    id=userID    value
    ${starttime_value}=    Get Element Attribute    id=startTime    value
    ${endtime_value}=    Get Element Attribute    id=endTime    value
    
    @{values}=    Create List    ${userid_value}    ${starttime_value}    ${endtime_value}
    FOR    ${val}    IN    @{values}
        Should Be Empty    ${val}
    END

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



Click Download And Verify By Counting
    [Arguments]     ${password}
    ${count_before}=    Count Items In Directory    ${DOWNLOAD_PATH}
    
    Admin Click Export Log Button
    Input Text    xpath=//input[@type="password"]    ${password}
    Admin Click Confirm

    Wait Until Keyword Succeeds    20s    2s    Check If File Count Increased    ${count_before}

Check If File Count Increased
    [Arguments]    ${old_count}
    ${new_count}=    Count Items In Directory    ${DOWNLOAD_PATH}
    Should Be True    ${new_count} > ${old_count}

Click Go To Register Page
    Click Element    xpath=//a[@href="/register"]

Click Go To Login Page
    Sleep   2
    Click Element    xpath=//a[@href="/login"]

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

Click My Profile    
    Hold Profile list
    Click Element    xpath=//a[@href="/profile"]

Hold Profile list 
    Scroll Element Into View    xpath=//div[contains(@class,"cursor-pointer")]

Admin Click Dashboard
    Hold Profile list 
    Click Element    xpath=//a[@href="/admin/users"]
    sleep   2s

Admin Click Filter Button
    Click Button	id=applyFilters
    sleep   2s

Admin Click Clear Log Button
    Click Button	id=clearFilters
    sleep    2s

Admin Click Detail Button
    Click Button	id=details

Admin Click Export Log Button
    Click Button	Export
	
Admin Click Confirm
    Click Button	ยืนยัน

Time Out
    [Arguments]     ${sleeptime}
    Sleep    ${sleeptime}
