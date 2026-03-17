*** Settings ***

Library     DateTime

#Suite Setup     Run Keywords    Connect To My Database  AND     My Log To Console
#Suite Teardown  Disconnect From Database
Test Setup      Open Main Page
Test Teardown	Close All Browsers

Resource	${CURDIR}/../Resource/datetime-resource.robot
Resource	${CURDIR}/../Resource/common-resource.robot

*** Variables ***
${ADMIN_USERNAME}   AdminNokia
${ADMIN_PASSWORD}   adminnokia007xRovxMLBB
${TEST_USER_ID}     cmmaqoiy8000a23jry6jcccf5
${INCORRECT_USER_ID}     cpcskkuintelcorei13Amdryzen

${startdate}    01012026  
${starttime}    1139AM    
${enddate}      05052026
${endtime}      1139AM

*** Test Cases ***
TC01-01 Login Admin And Filter Log By UserID

    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter With ID     ${TEST_USER_ID} 
    Admin Click Filter Button
    Admin Check Log Single Id

TC01-02 Login Admin And Filter Log By Startdatetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Click Filter Button
    Admin Check Traffic-log Last Row Is Within Lower Bound      ${startdate}    ${starttime}

TC01-03 Login Admin And Filter Log By Enddatetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Filter Button
    Admin Check Traffic-Log First Row Is Within Upper Bound     ${enddate}      ${endtime}

TC01-04 Login Admin And Filter Log By Datetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Filter Button
    Admin Check Traffic-Log First Row Is Within Upper Bound     ${enddate}      ${endtime}

TC01-05 Login Admin And Filter Log By UserID And Datetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter With ID     ${TEST_USER_ID}
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Filter Button
    Admin Check Traffic-Log First Row Is Within Upper Bound     ${enddate}      ${endtime}

TC01-06 Login Admin Filter Log By UserID And Datetime Then Clear Activity log
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter With ID   ${TEST_USER_ID} 
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Clear Log Button 
    Admin Check Empty Traffic-Log Filter

TC01-07 Login Admin Filter Incorrect UserID
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter With ID   ${INCORRECT_USER_ID} 
    Admin Click Filter Button 
    Admin Check Empty Traffic-Log table

TC01-08 Login Admin Go ExportLog Pages To See The Detail
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD} 
    Admin Go To ExportLog Page
    Admin Click Detail Button
    sleep   10s
    Element Should Contain    xpath=//h2    รายละเอียด Export Log