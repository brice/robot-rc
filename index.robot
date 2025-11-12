*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}     NO_URL_PROVIDED
${USERNAME}    your-username
${PASSWORD}    your-password
${FORM_FIELD_1}    field_1_value
${FORM_FIELD_2}    field_2_value

*** Test Cases ***
Fill Drupal Form
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    # Login To Drupal
    # Navigate To Form Page
    Fill Form Fields
    # Submit Form
    Close Browser

*** Keywords ***
Login To Drupal
    Input Text    id=username    ${USERNAME}
    Input Password    id=password    ${PASSWORD}
    Click Button    id=edit-submit

Navigate To Form Page
    Click Link    xpath=//a[contains(text(), 'Form Page')]

Fill Form Fields
    Input Text    id=edit-field-repair-date-0-value    ${FORM_FIELD_1}
    Input Text    id=edit-field-reference-number-0-value    ${FORM_FIELD_2}
    Input Text    id=edit-field-kind-product-0-target-id    ${FORM_FIELD_2}
    # Select From List By Value    @id='edit-field-categorie    1679
    # Input Text    id=edit-field-brand-0-target-id    ${FORM_FIELD_2}
    Input Text    id=edit-field-brand-0-target-id    ${FORM_FIELD_2}
    Input Text    id=edit-field-product-buildyear-0-value    ${FORM_FIELD_2}
    Input Text    id=edit-field-cause-of-fault-0-value    ${FORM_FIELD_2}
    Input Text    id=edit-field-repairer-0-target-id    ${FORM_FIELD_2}
    Input Text    id=edit-field-fault-0-value    ${FORM_FIELD_2}
    Input Text    id=edit-field-fault-0-value    ${FORM_FIELD_2}
    Click Element    xpath=/html/body/div[1]/div[3]/div/section[2]/div/div/form/div[4]/div[8]/fieldset/div/div/div[1]/label
    Select Radio Button    field_repair_information    yes

    Sleep    3000ms


Submit Form
    Click Button    id=edit-submit