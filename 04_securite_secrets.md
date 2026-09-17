# Gestion des secrets et sécurité (C14.2)

## 1. Inventaire et stockage des secrets
Dans le cadre du projet CareHub, aucun secret n'est stocké en clair dans le dépôt Git (vérifié par notre job `gitleaks`). Les secrets applicatifs identifiés sont :
* `DB_PASSWORD` : Mot de passe de la base de données de production.
* `GH_TOKEN` : Jeton d'authentification pour pousser l'image sur le registre GHCR.
* `VPS_SSH_KEY` / `VPS_HOST` : Clé d'accès et adresse du VPS pour le déploiement.

**Lieu de stockage :** Ces valeurs sont stockées de manière chiffrée dans les **GitHub Actions Secrets**.

## 2. Mode d'injection
* **Dans le pipeline (CI/CD) :** Les secrets sont appelés via la syntaxe `${{ secrets.NOM_DU_SECRET }}` uniquement dans les jobs qui en ont besoin (principe du moindre privilège).
* **À l'exécution (Runtime) :** Lors du déploiement, les secrets sont passés au conteneur via des variables d'environnement définies dans le `docker-compose.yml`. Le fichier `.env` versionné (`.env.example`) ne contient que des clés vides.

## 3. Procédure de renouvellement
La rotation des secrets s'effectue manuellement depuis l'interface GitHub (Settings > Secrets and variables > Actions) en cas de compromission (détectée par Gitleaks) ou trimestriellement par mesure de précaution. Une fois le secret mis à jour, le prochain redéploiement injectera la nouvelle valeur.

## 4. Contrôle de sécurité bloquant et remédiation (Preuve C14.1)
* **Le contrôle mis en place :** Le pipeline intègre un scan IaC (Trivy) et un script sur mesure qui analyse le fichier `docker-compose.yml`. L'objectif est de s'assurer que des limites de ressources sont définies (`cpus:`) pour protéger l'infrastructure du GHT.
* **L'échec bloquant :** Lors de la première exécution, le fichier `docker-compose.yml` ne contenait pas ces limites. Le pipeline a renvoyé un code d'erreur, bloquant immédiatement le déploiement (voir preuve `pipeline_echec_conformite.png`).
* **La remédiation :** Nous avons modifié le fichier `docker-compose.yml` en y intégrant un bloc `resources: limits: cpus: '0.50'`. À l'exécution suivante, le script a détecté la présence de la limite et a autorisé la suite du pipeline (voir preuve `pipeline_succes_conformite.png`).


Inventaire et stockage des secretsDans le cadre du projet CareHub, aucun secret n'est stocké en clair dans le dépôt Git (vérifié par notre job gitleaks).
Les secrets applicatifs sont :  DB_PASSWORD : Mot de passe de la base de données de production.GH_TOKEN / DOCKER_PASSWORD : Jeton d'authentification pour pousser l'image sur le registre GHCR.SSH_PRIVATE_KEY : Clé d'accès au VPS pour le déploiement. 
Lieu de stockage : Ces valeurs sont stockées de manière chiffrée dans les GitHub Actions Secrets, et spécifiquement restreintes à l'environnement de "production" (Environment Secrets) pour limiter leur exposition.  

2. Mode d'injectionDans le pipeline : Les secrets sont appelés via la syntaxe ${{ secrets.NOM_DU_SECRET }} uniquement dans les jobs qui en ont besoin (principe du moindre privilège).
3. À l'exécution (Runtime) : Lors du déploiement, les secrets sont passés au conteneur via des variables d'environnement définies dans le docker-compose.yml.
4. Le fichier .env versionné (.env.example) ne contient que des valeurs factices ou vides.
5.
6. Procédure de renouvellementLa rotation des secrets s'effectue manuellement depuis l'interface GitHub (Settings > Secrets and variables) en cas de compromission (détectée par Gitleaks) ou trimestriellement par mesure de précaution. Une fois le secret mis à jour, le prochain redéploiement injectera la nouvelle valeur.4.
7. Contrôle de sécurité bloquant et remédiation (Preuve C14.1)Le contrôle mis en place : Le pipeline intègre un scan IaC (Trivy Config) et un script Bash sur mesure qui analyse le fichier docker-compose.yml.
8. L'objectif est de s'assurer que des limites de ressources (CPU) sont définies (cpus:) pour protéger l'infrastructure du GHT.  L'échec : Lors de la première exécution, le fichier docker-compose.yml était soit absent soit non-conforme. Le script a renvoyé un exit code 1, bloquant immédiatement le déploiement vers la production (voir capture pipeline_echec_conformite.png).
     6.  La remédiation : Nous avons créé le fichier docker-compose.yml en y intégrant un bloc resources: limits: cpus: '0.50' et memory: 512M.
     7.  À l'exécution suivante, le script a détecté la présence de la limite et a autorisé le déploiement (voir capture pipeline_succes_conformite.png).  
