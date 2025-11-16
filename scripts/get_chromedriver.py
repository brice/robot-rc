"""Télécharge le chromedriver via webdriver-manager et affiche son chemin.

Usage:
    python scripts/get_chromedriver.py
    python scripts/get_chromedriver.py --print-add-path

Le script écrit simplement le chemin du binaire téléchargé sur stdout.
"""
import argparse
import sys
from webdriver_manager.chrome import ChromeDriverManager


def main(print_add_path: bool) -> int:
    try:
        path = ChromeDriverManager().install()
    except Exception as e:
        print("Erreur lors du téléchargement du chromedriver:", e, file=sys.stderr)
        return 2

    print(path)

    if print_add_path:
        # Suggestion for adding to PATH on Windows (PowerShell)
        print("\nConseil: pour ajouter ce dossier au PATH temporairement (PowerShell) :")
        print(f"$env:Path += \";{path.rsplit('\\\\', 1)[0]}\"")
        print("Ou copiez le binaire dans un répertoire de votre PATH.")

    return 0


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Télécharge chromedriver via webdriver-manager')
    parser.add_argument('--print-add-path', action='store_true', help='Afficher une suggestion pour ajouter le dossier au PATH')
    args = parser.parse_args()
    raise SystemExit(main(args.print_add_path))
