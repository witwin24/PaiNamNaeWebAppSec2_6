*** Settings ***

#Suite Setup		Run Keywords	Connect To Database		AND		My Log To Console
#Suite Teardown		Disconnect From Database
Test Setup		Open Main Page
Test Teardown	Close All Browsers

Resource	${CURDIR}/../Resource/common-resource.robot

*** Test Cases ***
Create User Account
	Go To Register Page
	Register Form	TestDeleteUser	Test@gmail.com	123456789		
	...		TE	ST	0999999999	male	
	...		${CURDIR}/Test_image.png	1234567891011	10011001	${CURDIR}/Test_image.png

TC02-01 Delete User With Empty Password
	Go To login Page
	Login	TestDeleteUser	123456789
	Go To Profile Page
	Delete User Account		${EMPTY}	กรุณากรอกรหัสผ่าน

TC02-02 Delete User With Inorrect Password
	Go To login Page
	Login	TestDeleteUser	123456789
	Go To Profile Page
	Delete User Account		121231212	ลบไม่สำเร็จ / รหัสผ่านผิด

TC02-03 Delete User With Correct Password
	Go To login Page
	Login	TestDeleteUser	123456789
	Go To Profile Page
	Delete User Account		123456789	ลบบัญชีสำเร็จ

	Go To login Page
	Login	TestDeleteUser	123456789
	Wait Until Page Contains    เข้าสู่ระบบไม่สำเร็จ    timeout=10s