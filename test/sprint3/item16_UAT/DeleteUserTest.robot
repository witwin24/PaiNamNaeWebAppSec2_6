*** Settings ***
Test Teardown    Close All Browsers

Resource    ${CURDIR}/../Resource/common-resource.robot


*** Keywords ***
Create Test User And Login
    Open Main Page
    Go To Register Page
    Register Form    TestDeleteUser    Test@gmail.com    123456789
    ...    TE    ST    0999999999    male
    ...    1234567891011    10011001


*** Test Cases ***
TC02-01 Delete User With Empty Data Export
    [Setup]    Create Test User And Login

	Time Out	2
	Go To Login Page
    Login    TestDeleteUser    123456789
	Time Out	2
    Go To Profile Page
    Delete User Account    123456789
    ...    ลบบัญชีสำเร็จ ข้อมูลของคุณจะไม่ถูกส่งไปยัง Email เนื่องจากคุณไม่ได้เลือกข้อมูลใดๆ ในขั้นตอนก่อนหน้า
    ...    none

    Open Main Page
    Go To Login Page
    Login    TestDeleteUser   123456789
    Wait Until Page Contains    เข้าสู่ระบบไม่สำเร็จ    timeout=10s

TC02-02 Delete User With Incorrect Password
    [Setup]    Create Test User And Login

	Time Out	2
	Go To Login Page
    Login    TestDeleteUser    123456789
	Time Out	2
    Go To Profile Page
    Delete User Account    121231212    ลบไม่สำเร็จ: รหัสผ่านไม่ถูกต้อง    none
    
    Open Main Page
    Go To Login Page
    Login    TestDeleteUser    123456789
	Go To Profile Page
    Profile Page Should Be Open

TC02-03 Delete User With All Data Export
	[Setup]    Run Keywords
    ...    Open Main Page    AND
    ...    Go To Login Page

    Login    TestDeleteUser    123456789
	Time Out	2
    Go To Profile Page
    Delete User Account    123456789
    ...    ลบบัญชีสำเร็จ ข้อมูลของคุณได้ถูกส่งไปยัง Email แล้ว
    ...    all
    Go To Login Page
    Login    TestDeleteUser    123456789
    Wait Until Page Contains    เข้าสู่ระบบไม่สำเร็จ    timeout=10s

TC02-04 Delete User With Some Data Export
    [Setup]    Create Test User And Login

	Time Out	2
	Go To Login Page
    Login    TestDeleteUser    123456789
	Time Out	2
    Go To Profile Page
    Delete User Account    123456789
    ...    ลบบัญชีสำเร็จ ข้อมูลของคุณได้ถูกส่งไปยัง Email แล้ว
    ...    personal
    Go To Login Page
    Login    TestDeleteUser    123456789
    Wait Until Page Contains    เข้าสู่ระบบไม่สำเร็จ    timeout=10s
