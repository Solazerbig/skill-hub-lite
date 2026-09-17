# CareHub CI/CD - EC06

## Présentation de la solution
Ce dépôt contient l'infrastructure as code (IaC) et la configuration CI/CD pour le déploiement du portail CareHub. L'objectif est d'assurer une livraison continue, sécurisée et à haute disponibilité pour le Groupement Hospitalier de Territoire (GHT). 

## Prérequis
* Machine hôte (VPS) sous Linux.
* Docker et le plugin Docker Compose installés.
* Accès au registre d'images GitHub (GHCR).

## Commande unique de démarrage
Le démarrage de la pile complète en production s'effectue via une seule commande à la racine du répertoire `02_conteneurisation/` :
```bash

Variables d'environnement
Le système s'appuie sur un fichier .env. Un modèle sécurisé est fourni (.env.example). Les variables attendues sont :

NODE_ENV : Environnement d'exécution (dev, staging, production).

APP_PORT : Port d'écoute du conteneur.

DB_HOST, DB_USER : Paramètres de connexion à la base.

DB_PASSWORD : Mot de passe de la base (injecté dynamiquement par la CI, ne jamais inscrire en dur).

Déclaration d'Usage de l'Intelligence Artificielle (Obligatoire)
Dans le cadre de cette épreuve, l'Intelligence Artificielle a été utilisée comme assistant technique sous ma supervision, conformément au règlement de l'examen.

Outils IA utilisés : Gemini.

Périmètre d'utilisation : Aide à la structuration du fichier docker-compose.yml (gestion dynamique des ressources et réplicas).

Démarche de Context Engineering :

"Fournis un docker-compose respectant le Zero Downtime avec healthcheck et limites CPU/RAM pour la compétence C13.1."

Justification et Audit (Validation technique) :

Le code généré a été audité pour vérifier qu'aucune valeur sensible (secret) n'était exposée dans les fichiers d'infrastructure (utilisation de ${DB_PASSWORD}).

J'ai volontairement validé l'ajout d'un script Bash sur mesure dans le workflow YAML pour imposer la déclaration des limites cpus: dans le fichier compose. J'ai audité ce mécanisme en provoquant un échec (preuve fournie) pour m'assurer que le pipeline ne laissait pas passer de code non conforme, garantissant ainsi la robustesse requise pour le projet.
docker compose up -d
