*** Variables ***
${REPAIR_DATE_INPUT_ID}        edit-field-repair-date-0-value
${REFERENCE_INPUT_ID}          edit-field-reference-number-0-value
${KIND_PRODUCT_INPUT_ID}       edit-field-kind-product-0-target-id
${BRAND_INPUT_ID}              edit-field-brand-0-target-id
${CATEGORY_INPUT_ID}           edit-field-categorie
${PRODUCT_REPAIRED_YES_ID}     edit-field-product-repaired-yes
${PRODUCT_REPAIRED_NO_ID}      edit-field-product-repaired-no
${PRODUCT_REPAIRED_HALF_ID}    edit-field-product-repaired-half

## Les identifiants de la catégorie sont mappés ici pour une utilisation facile
## Ils sont basés sur les labels des catégories du site repairmonitor
&{CATEGORY_BY_LABEL}    Articles ménagers non électriques=5343
...                     Autres=1685
...                     Bijoux=18707
...                     Jouets non électriques=1693
...                     Jouets électriques=1692
...                     Matériel d'image et de son=1689
...                     Matériel informatique/téléphones=1677
...                     Meubles=1683
...                     Outils non électriques=1691
...                     Outils électriques=1690
...                     Pendules, horloges et réveils=18706
...                     Textiles=1684
...                     Vélos=1679
...                     Électroménager=1678