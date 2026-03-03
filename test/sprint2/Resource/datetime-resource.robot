*** Settings ***

Library    datetime_check.py

*** Keywords ***

Admin Check Traffic-Log First Row Is Within Upper Bound
    [Arguments]    ${enddate}    ${endtime}
    ${upper_bound}=     Convert Input To Datetime    ${enddate}    ${endtime}
    ${first_row_text}=  Get Text    xpath=//table/tbody/tr[1]/td[2]
    ${first_row_dt}=    Convert Thai Table Time To Datetime    ${first_row_text}
    Should Be True      '${first_row_dt}' <= '${upper_bound}'    msg=แถวแรกเกินเวลาที่กำหนด (${first_row_text} > ขอบเขตบน)

Admin Check Traffic-log Last Row Is Within Lower Bound
    [Arguments]    ${startdate}    ${starttime}
    ${lower_bound}=     Convert Input To Datetime    ${startdate}    ${starttime}
    ${row_count}=       Get Element Count    xpath=//table/tbody/tr
    ${last_row_text}=    Get Text    xpath=//table/tbody/tr[${row_count}]/td[2]
    ${last_row_dt}=     Convert Thai Table Time To Datetime    ${last_row_text}
    Should Be True      '${last_row_dt}' >= '${lower_bound}'    msg=แถวสุดท้ายเก่ากว่าเวลาที่กำหนด (${last_row_text} < ขอบเขตล่าง)