*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Login And Get Token
    Create Session    api    ${BASE_URL}

    ${body}=    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}

    ${res}=    POST    api    /auth/login    json=${body}
    Status Should Be    200    ${res}

    ${token}=    Get From Dictionary    ${res.json()}    token
    [Return]    ${token}


*** Variables ***
${BASE_URL}       https://painamnaewebappsec26-production.up.railway.app/api
${ADMIN_TOKEN}    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjbWxxc2N2aTcwMDAwYjdjenNjNXlodGllIiwicm9sZSI6IkRSSVZFUiIsImlhdCI6MTc3MTM1NjA5MSwiZXhwIjoxNzcxMzU5NjkxfQ.5I5ccx0AzeGbHD8ntYfNPZChSiZ2MKqaMLB8gT86HTg
${TEST_USER_ID}   cmlqscvi70000b7czsc5yhtie

${EMAIL}       delete@test.com
${PASSWORD}    123456


*** Test Cases ***
User Can Delete Own Account
    ${token}=    Login And Get Token

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    ${res}=    DELETE    api    /users/me    headers=${headers}
    Status Should Be    200    ${res}

Delete Account Without Token
    Create Session    api    ${BASE_URL}
    ${res}=    DELETE    api    /users/me    expected_status=401

Delete Account With Invalid Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer invalid.token

    ${res}=    DELETE    api    /users/me    headers=${headers}    expected_status=401

Delete Account Twice Should Fail
    ${token}=    Login And Get Token

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}

    DELETE    api    /users/me    headers=${headers}
    ${res}=    DELETE    api    /users/me    headers=${headers}    expected_status=404

