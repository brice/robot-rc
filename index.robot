*** Settings ***
Library    SeleniumLibrary
Library    Collections

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

Load Form Fields From CSV
    [Documentation]    Charge les valeurs de FORM_FIELD_1 et FORM_FIELD_2 depuis un fichier CSV.
    ...    Usage: Load Form Fields From CSV    data/form_data.csv    0
    [Arguments]    ${csv_file}    ${row_index}=0
    ${rows}=    Evaluate    list(__import__('csv').DictReader(open('${csv_file}', encoding='utf-8')))
    ${row}=    Evaluate    ${rows}[${row_index}]
    Set Global Variable    ${FORM_FIELD_1}    ${row}[FORM_FIELD_1]
    Set Global Variable    ${FORM_FIELD_2}    ${row}[FORM_FIELD_2]
    Log    Champs CSV chargés (ligne ${row_index}): FORM_FIELD_1=${FORM_FIELD_1}, FORM_FIELD_2=${FORM_FIELD_2}