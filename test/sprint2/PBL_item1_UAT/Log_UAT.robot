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

TC01-04 Login Admin And Filter Log By UserID And Startdatetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter With ID     ${TEST_USER_ID}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Filter Button
    Admin Check Traffic-Log First Row Is Within Upper Bound     ${enddate}      ${endtime}

TC01-05 Login Admin And Filter Log By UserID And Startdatetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter With ID     ${TEST_USER_ID}
    Admin Filter Log With Startdatetime    ${startdate}  ${starttime}
    Admin Click Filter Button
    Admin Check Traffic-Log First Row Is Within Upper Bound     ${enddate}      ${endtime}

TC01-06 Login Admin And Filter Log By Datetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Filter Button
    Admin Check Traffic-Log First Row Is Within Upper Bound     ${enddate}      ${endtime}

TC01-07 Login Admin And Filter Log By UserID And Startdatetime
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}       
    Admin Go To Log Page
    Admin Filter With ID     ${TEST_USER_ID}
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Filter Button
    Admin Check Traffic-Log First Row Is Within Upper Bound     ${enddate}      ${endtime}

TC01-08 Login Admin Filter UserID And Clear Activity log
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter With ID   ${TEST_USER_ID} 
    Admin Click Clear Log Button 
    Admin Check Empty Traffic-Log Filter

TC01-09 Login Admin Filter Datetime And Clear Activity log
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Clear Log Button 
    Admin Check Empty Traffic-Log Filter

TC01-10 Login Admin Filter UserID, Datetime And Clear Activity log
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter With ID   ${TEST_USER_ID} 
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime}
    Admin Click Clear Log Button 
    Admin Check Empty Traffic-Log Filter

TC01-11 Login Admin Filter Incorrect UserID and Datetime 
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter With ID   ${INCORRECT_USER_ID} 
    Admin Filter Log With Startdatetime     123456  1130PM
    Admin Filter Log With Enddatetime    121230     1130AM
    Admin Click Filter Button 
    Admin Check Empty Traffic-Log table

TC01-12 Login Admin Filter Log By UserID And Export file
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter With ID   ${TEST_USER_ID} 

    Admin Click Filter Button 
    Admin Click Export Log Button
    
    Wait Until Keyword Succeeds    20s    2s    Check If CSV Exists

TC01-13 Login Admin Filter Log By Datetime And Export file
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD}    
    Admin Go To Log Page
    Admin Filter Log With Startdatetime  ${startdate}    ${starttime}
    Admin Filter Log With Enddatetime    ${enddate}  ${endtime} 

    Admin Click Filter Button 
    Click Download And Verify By Counting

TC01-14 Login Admin Go To ExportLog Pages See Detail
    Go To Login Page
    Login   ${ADMIN_USERNAME}   ${ADMIN_PASSWORD} 
    Admin Go To ExportLog Page
    Admin Click Detail Button
    sleep   5s
    Element Should Contain    xpath=//h2    รายละเอียด Export Log
