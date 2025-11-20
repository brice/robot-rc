*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    Dialogs

Resource    pages/form_page.robot
*** Variables ***
${URL}          https://www.repairmonitor.org/fr/
${DATA_FILE}    data/form_data.csv
## Index de la ligne à utiliser dans le fichier CSV (0 pour la première ligne de données)
${INDEX}        0
${DELIMITER}    ,

## Variables de connexion à surcharger dans la ligne de commande
${USERNAME}    your-username
${PASSWORD}    your-password

## Variables de formulaire avec valeurs par défaut
${REFERENCE_NUMBER}      TO-REPLACE
${REPAIR_DATE}           2024-05-10
${KIND_PRODUCT}          Refrigerator
${STATUS}                Pending
${BRAND}                 Inconnue/s.o.
${CATEGORY}              UNKNOWN


*** Test Cases ***
Fill Drupal Form
    Load Form Fields From CSV    ${DATA_FILE}    ${INDEX}    ${DELIMITER}
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    Login To Drupal
    Navigate To Form Page
    Fill Form Fields
    Submit Form
    Verify Creation
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

        Execute Javascript    document.getElementById('${REFERENCE_INPUT_ID}').value='${REFERENCE_NUMBER}';

        Execute Javascript    document.getElementById('${CATEGORY_INPUT_ID}').value='${CATEGORY}';
        Sleep    1000ms

        Input Text    id=${KIND_PRODUCT_INPUT_ID}   ${KIND_PRODUCT}
        Sleep    5000ms

        Execute Javascript    document.getElementById('${BRAND_INPUT_ID}').value='${BRAND}';
        Sleep    5000ms

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
    Click Button    id=${EDIT_SUBMIT_BUTTON_ID}

Load Form Fields From CSV
    [Documentation]    Charge les valeurs depuis un fichier CSV.
    ...    Usage: Load Form Fields From CSV    data/form_data.csv    0    ,
    ...    Pour un délimiteur point-virgule: Load Form Fields From CSV    data/form_data.csv    0    ;

    [Arguments]    ${csv_file}    ${row_index}=0    ${delimiter}=,

    # Variables calculées
    ${REFERENCE_NUMBER}=    Evaluate    str(${row_index} + 1)
    Set Global Variable    ${REFERENCE_NUMBER}

    # Variables récupérées depuis le CSV
    ${rows}=    Evaluate    list(__import__('csv').DictReader(open('${csv_file}', encoding='utf-8'), delimiter='${delimiter}'))
    ${row}=    Get From List   ${rows}     ${row_index}

    # Pour le moment la date de réparation est fixée dans le code en attendant la gestion des formats de date
    # Set Global Variable    ${REPAIR_DATE}    ${row}[0]
    Set Global Variable    ${KIND_PRODUCT}    ${row}[Appareil concerné]
    Set Global Variable    ${STATUS}    ${row}[Réparé ?]
    ${CATEGORY}=    Get Category ID    ${row}[Catégorie]
    Set Global Variable    ${CATEGORY}

    IF    '${row}[Marque]' != 'None'
        Set Global Variable    ${BRAND}    ${row}[Marque]
    END

    Log To Console  Variables chargées du fichier ${csv_file} REFERENCE_NUMBER=${REFERENCE_NUMBER}, REPAIR_DATE=${REPAIR_DATE}, CATEGORY=${CATEGORY}, KIND_PRODUCT=${KIND_PRODUCT}, STATUS=${STATUS}, BRAND=${BRAND}

Get Category ID
    [Arguments]    ${CATEGORY_NAME}
    Log To Console    Getting category ID for category name: ${CATEGORY_NAME}

    ${CATEGORY_ID}=    Get From Dictionary    ${CATEGORY_BY_LABEL}    ${CATEGORY_NAME}    default=UNKNOWN
    IF     '${CATEGORY_ID}' == 'UNKNOWN'
        Log To Console    ${CATEGORY_BY_LABEL}
        ${CATEGORY_ID}=    Get Value From User    Nous n'avons pas trouvé de categorie pour ${KIND_PRODUCT}:${CATEGORY_NAME}. Please provide the correct category ID:
        Log To Console    ${CATEGORY_ID}
    END
    RETURN    ${CATEGORY_ID}

Verify Creation
    [Documentation]    Vérifie que le message "a été créé." est présent sur la page.
     [Arguments]    ${message}=a été créé.    ${timeout}=10s
     Wait Until Page Contains    ${message}    timeout=${timeout}    error=Le message "${message}" n'a pas été trouvé sur la page après ${timeout}
     Log    Message trouvé: ${message}