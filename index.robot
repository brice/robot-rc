*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${URL}     NO_URL_PROVIDED
${USERNAME}    your-username
${PASSWORD}    your-password
${FORM_FIELD_1}    field_1_value
${FORM_FIELD_2}    field_2_value
${REPAIR_DATE}    2024-05-10
${CATEGORY}      REF-001
${KIND_PRODUCT}  Refrigerator
${STATUS}    Pending
${BRAND}    Inconnue

*** Test Cases ***
Fill Drupal Form
    Load Form Fields From CSV    data/form_data_bis.csv    1    ;
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    Login To Drupal
    Navigate To Form Page
    Fill Form Fields
    # Submit Form
    Sleep    10000ms
    Close Browser

*** Keywords ***
Login To Drupal
    Input Text    id=edit-name    ${USERNAME}
    Input Password    id=edit-pass    ${PASSWORD}
    Click Button    id=edit-submit

Navigate To Form Page
    Click Link    xpath=//a[contains(text(), 'Introduire nouvelle réparation')]

Fill Form Fields

    # Input Text    id=edit-field-repair-date-0-value    ${REPAIR_DATE}
    # Sleep    1000ms
    Input Text    id=edit-field-reference-number-0-value    1
    Input Text    id=edit-field-kind-product-0-target-id    ${KIND_PRODUCT}
    # Select From List By Value    @id='edit-field-categorie    1679
    # Input Text    id=edit-field-brand-0-target-id    ${FORM_FIELD_2}
    Input Text    id=edit-field-brand-0-target-id    ${BRAND}
    # Input Text    id=edit-field-product-buildyear-0-value    ${FORM_FIELD_2}
    # Input Text    id=edit-field-cause-of-fault-0-value    ${FORM_FIELD_2}
    # Input Text    id=edit-field-repairer-0-target-id    ${FORM_FIELD_2}
    # Input Text    id=edit-field-fault-0-value    ${FORM_FIELD_2}
    # Input Text    id=edit-field-fault-0-value    ${FORM_FIELD_2}
    # Click Element    xpath=/html/body/div[1]/div[3]/div/section[2]/div/div/form/div[4]/div[8]/fieldset/div/div/div[1]/label
    Sleep    1000ms
    IF    '${STATUS}' == 'réparé'
        Select Radio Button    field_repair_information    yes
    ELSE IF    '${STATUS}' == 'non réparable'
        Select Radio Button    field_product_repaired    no
    ELSE IF    '${STATUS}' == 'réparable'
        Select Radio Button    field_product_repaired    half
    END

    Sleep    3000ms


Submit Form
    Click Button    id=edit-submit

Load Form Fields From CSV
    [Documentation]    Charge les valeurs de FORM_FIELD_1 et FORM_FIELD_2 depuis un fichier CSV.
    ...    Usage: Load Form Fields From CSV    data/form_data.csv    0    ,
    ...    Pour un délimiteur point-virgule: Load Form Fields From CSV    data/form_data.csv    0    ;
    [Arguments]    ${csv_file}    ${row_index}=0    ${delimiter}=,
    ${rows}=    Evaluate    list(__import__('csv').DictReader(open('${csv_file}', encoding='utf-8'), delimiter='${delimiter}'))
    ${row}=    Get From List   ${rows}     ${row_index}

    # Set Global Variable    ${REPAIR_DATE}    ${row}[0]
    Set Global Variable    ${CATEGORY}    ${row}[Catégorie]
    Set Global Variable    ${KIND_PRODUCT}    ${row}[Appareil concerné]
    Set Global Variable    ${STATUS}    ${row}[Réparé ?]
    Log To Console  Loaded form fields from ${csv_file}, row ${row_index}, delimiter '${delimiter}': REPAIR_DATE=${REPAIR_DATE}, CATEGORY=${CATEGORY}, KIND_PRODUCT=${KIND_PRODUCT}, STATUS=${STATUS}
