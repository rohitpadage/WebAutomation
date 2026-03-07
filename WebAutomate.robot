*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String

Test Setup       Open Web Browser
Test Teardown    Close Browser 


*** Variables ***
${Url}                    https://www.saucedemo.com/
${Browser}                Chrome
${UserNameLocator}        //input[@id="user-name"]
${PasswordLocator}        //input[@id="password"]
${LoginButtonLocator}     //input[@id="login-button"]
${PriceLocator}           //div[@data-test="inventory-item-price"]
${ProductNameLocator}     //div[@data-test="inventory-item-name"]
${User1}                  standard_user
${Password}               secret_sauce
${User2}                  locked_out_user  
${User3}                  problem_user
${User4}                  error_user  
${User5}                  visual_user      

*** Keywords ***
Open Web Browser
    # Disable Chrome password manager pop-up
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_experimental_option    prefs
    ...    ${{{"credentials_enable_service": False, "profile.password_manager_enabled": False}}}
    Open Browser    ${Url}    ${Browser}    options=${options}
    Maximize Browser Window

Enter the UserName & Password
    [Arguments]    ${UserNameArg}    ${PasswordArg}
    Wait Until Element Is Visible    ${UserNameLocator}
    Wait Until Element Is Visible    ${PasswordLocator}
    Input Text    ${UserNameLocator}    ${UserNameArg}
    Input Text    ${PasswordLocator}    ${PasswordArg}

Click on Login Button
    Wait Until Element Is Visible    ${LoginButtonLocator}
    Click Element    ${LoginButtonLocator}

Get All Product Names & Prices
    Wait Until Element Is Visible    ${ProductNameLocator}
    Wait Until Element Is Visible    ${PriceLocator}

    # Get all WebElements
    @{ProductNames}=     Get WebElements    ${ProductNameLocator}
    @{ProductPrices}=    Get WebElements    ${PriceLocator}

    @{ProductNameList}=    Create List
    @{ProductPriceList}=     Create List

    FOR    ${element}    IN    @{ProductNames}
        ${Name}   Get Text    ${element}
        Append To List    ${ProductNameList}    ${Name}
        Log To Console    ProductName: ${Name}
    END
    
    FOR    ${element}    IN    @{ProductPrices}
        ${Price}   Get Text    ${element}
        ${Price}    Strip String    ${Price}
        Log To Console    Currency:${Price}[0]
        ${Price}    Evaluate    float('${Price}'.replace('$',''))
        Append To List    ${ProductPriceList}    ${Price}
        Log To Console    ProductPrice: ${Price}
    END


    ${MinPrice}   Evaluate    min(${ProductPriceList})
    ${MinPriceIndex}    Evaluate    ${ProductPriceList}.index(${MinPrice})    
    ${ProductHavingMinPrice}      Get From List  ${ProductNameList}    ${MinPriceIndex}
    
    Log To Console    "##########"
    Log To Console    ${ProductHavingMinPrice}
    Log To Console    ${MinPrice}



*** Test Cases ***
List the Product having lowest price
    [Tags]    Regression    Critical
    Enter the UserName & Password    ${User1}    ${Password}
    Click on Login Button
    Sleep    10s
    Page Should Contain    Swag Labs
    Get All Product Names & Prices

Locked User
    [Tags]    Sanity    Medium
    Enter the UserName & Password    ${User1}    ${Password}
    Click on Login Button
    Sleep    5s

Problem User
    [Tags]    Sanity    High
    Enter the UserName & Password    ${User3}    ${Password}
    Click on Login Button
    Sleep    2s

Error User
    [Tags]    Regression    low
    Enter the UserName & Password    ${User4}    ${Password}
    Click on Login Button
    Sleep    2s    
    Page Should Contain    Rock

Visual User
    [Tags]    Regression    low
    Enter the UserName & Password    ${User5}    ${Password}
    Click on Login Button
    Capture Page Screenshot    
    Sleep    2s  
    Page Should Contain    John