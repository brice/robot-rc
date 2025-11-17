*** Settings ***
Library    SeleniumLibrary
Library    Collections
Resource    pages/form_page.robot
*** Variables ***
${URL}         https://www.repairmonitor.org/fr/

## Variables de connexion à surcharger dans la ligne de commande
${USERNAME}    your-username
${PASSWORD}    your-password

${REPAIR_DATE}    2024-05-10
${CATEGORY}       1685
${KIND_PRODUCT}   Refrigerator
${STATUS}         Pending
${BRAND}          Inconnue/s.o.

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
    [Documentation]    Remplit le formulaire en utilisant les sélecteurs centralisés (Page Object).

    TRY
        Execute Javascript    document.getElementById('${REPAIR_DATE_INPUT_ID}').value='${REPAIR_DATE}';
        Input Text    id=${REFERENCE_INPUT_ID}      1
        Input Text    id=${KIND_PRODUCT_INPUT_ID}   ${KIND_PRODUCT}
        Execute Javascript    document.getElementById('${BRAND_INPUT_ID}').value='${BRAND}';

        Select From List By Label    id=${CATEGORY_INPUT_ID}    ${CATEGORY}

        IF    '${STATUS}' == 'réparé'
            Execute Javascript    document.getElementById('${PRODUCT_REPAIRED_YES_ID}').click();
        ELSE IF    '${STATUS}' == 'non réparable'
            Execute Javascript    document.getElementById('${PRODUCT_REPAIRED_NO_ID}').click();
        ELSE IF    '${STATUS}' == 'réparable'
            Execute Javascript    document.getElementById('${PRODUCT_REPAIRED_HALF_ID}').click();
        END
    EXCEPT
        Log     Erreur lors du remplissage du formulaire     level=ERROR
        Fail    Impossible de remplir le formulaire
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
