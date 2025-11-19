# robot-rc

Projet expérimental pour remplir un formulaire via Selenium avec Robot Framework. L'objectif est de remonter des informations de réparation sur le site du Repair Café France.

Le projet est disponible comme base de départ pour des projets divers.

Attention : Une partie de ce code a été généré par GitHub Copilot et est relu par un humain.

## Prérequis
- Python 3.8+
- Chrome (ou le navigateur que vous voulez utiliser dans `index.robot`)

Ce projet utilise Selenium via `SeleniumLibrary` (voir `requirements.txt`).


## Installation (Windows - PowerShell)

1. Ouvrez PowerShell et placez-vous dans le répertoire du projet :

```powershell
cd C:\Users\brice\Documents\Workspace\robot-rc
```

2. (Optionnel mais recommandé) Créez et activez un environnement virtuel :

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

3. Mettre pip à jour et installer les dépendances :

```powershell
python -m pip install --upgrade pip
python -m pip install -r .\requirements.txt
```

4. Vérifier que Robot Framework est installé :

```powershell
robot --version
```

## Installation (Linux - Bash)

1. Ouvrez un terminal et placez-vous dans le répertoire du projet :

```bash
cd /home/<votre-utilisateur>/Documents/Workspace/robot-rc
```

2. (Optionnel mais recommandé) Créez et activez un environnement virtuel :

```bash
python3 -m venv .venv
source .venv/bin/activate
```

3. Mettre pip à jour et installer les dépendances :

```bash
python -m pip install --upgrade pip
python -m pip install -r ./requirements.txt
```

4. Vérifier que Robot Framework est installé :

```bash
robot --version
```

Notes pour le navigateur / chromedriver sur Linux:

- Option A : Selenium Manager (Selenium 4.6+) peut gérer automatiquement le driver si vous utilisez une version récente de `selenium` (recommandé).

- Option B : utiliser le script `scripts/get_chromedriver.py` fourni pour télécharger le binaire :

```bash
python3 ./scripts/get_chromedriver.py
```

Le script affiche le chemin complet du binaire téléchargé. Pour l'utiliser globalement, vous pouvez copier le binaire dans `/usr/local/bin` (nécessite sudo) :

```bash
sudo cp "$(python3 ./scripts/get_chromedriver.py)" /usr/local/bin/chromedriver
sudo chmod +x /usr/local/bin/chromedriver
```

Ou ajoutez le dossier contenant le binaire à votre PATH :

```bash
export PATH="$PATH:/chemin/vers/dossier/du/binaire"
```

- Sur Debian/Ubuntu il existe parfois un paquet `chromium-chromedriver` :

```bash
sudo apt update
sudo apt install chromium-chromedriver
```

  Attention : ce paquet peut ne pas correspondre exactement à la version de Chrome/Chromium installée.


## Lancer les tests

Vous pouvez lancer le test Robot principal (`index.robot`) ainsi, en mettant les variables de connexion USERNAME et PASSWORD. Pour le moment, le traitement des fichiers n'est pas totalement automatisé et il convient d'ajouter également la variavble INDEX indiquant la ligne du fichier CSV à traiter (attention la ligne 0 est la première ligne de données).

```powershell
robot --variable USERNAME:"Nom d'utilisateur" --variable PASSWORD:"mon mot de passe" --variable INDEX:0  .\index.robot
```


## Utiliser des données CSV

Le projet inclut un mot-clé Robot Framework pour charger les valeurs des champs de formulaire depuis un fichier CSV.

### Structure du fichier CSV

TODO


### Utiliser le mot-clé `Load Form Fields From CSV` dans Robot Framework

Dans `index.robot`, vous pouvez charger les données avant d'exécuter le formulaire :

```robotframework
*** Test Cases ***
Fill Drupal Form With CSV Data
    Load Form Fields From CSV    data/form_data.csv    0
    Open Browser    ${URL}    Chrome
    Maximize Browser Window
    Fill Form Fields
    Close Browser
```

**Paramètres du mot-clé :**

- `csv_file` (obligatoire) : Chemin vers le fichier CSV (absolu ou relatif au répertoire courant)
- `row_index` (optionnel, défaut = 0) : Index de la ligne de données à charger (0 = première ligne après l'en-tête)
- `delimiter` (optionnel, défaut = ,) : Délimiteur des champs dans le fichier CSV

Le mot-clé définit automatiquement des variables globales avec les valeurs du fichier CSV.

## ChromeDriver / WebDriver

Deux options courantes pour le driver Chrome :

- Option A : Selenium Manager (inclus dans Selenium 4.6+) tentera d'obtenir automatiquement
  le driver approprié. Nous recommandons `selenium>=4.8` pour en profiter.

- Option B : installer un `chromedriver` correspondant à votre version de Chrome
  et l'ajouter au `PATH`.

Si vous souhaitez télécharger explicitement le chromedriver via `webdriver-manager`,
vous pouvez créer un petit script Python tel que :

```python
# scripts/get_chromedriver.py
from webdriver_manager.chrome import ChromeDriverManager

if __name__ == '__main__':
    path = ChromeDriverManager().install()
    print('Chromedriver installé ici:', path)
```

Et l'exécuter :

```powershell
python .\scripts\get_chromedriver.py
```

Cela téléchargera le binaire dans le cache et affichera son chemin.

## Dépannage rapide
- Si `Open Browser` échoue, vérifiez la version de Chrome et le chromedriver.
- Si `robot` n'est pas trouvé, assurez-vous d'avoir activé l'environnement virtuel.

## Personnalisation
- Mettez à jour les variables dans `index.robot` (`${URL}`, `${USERNAME}`, `${PASSWORD}`, etc.)
  avant d'exécuter.

---

Si vous voulez, je peux aussi :
- ajouter automatiquement `scripts/get_chromedriver.py` au dépôt,
- ajouter un script PowerShell d'initialisation qui crée/active le venv et installe les dépendances.
