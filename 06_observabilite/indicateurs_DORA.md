# Indicateurs DORA et Supervision - CareHub

## 1. Configuration de supervision
La supervision de l'application CareHub repose sur la stack Prometheus / Grafana. 
Le fichier `prometheus.yml` est utilisé pour scraper les métriques applicatives et l'état des conteneurs.

## 2. Indicateurs DORA (Méthodes de calcul)
Les indicateurs DORA (DevOps Research and Assessment) permettent de mesurer la performance et la fiabilité de notre chaîne pour le GHT.

### A. Fréquence de déploiement (Deployment Frequency)
* **Définition :** À quelle fréquence le nouveau code est déployé en production.
* **Méthode de calcul :** Nombre d'exécutions réussies du workflow GitHub Actions jusqu'au job de déploiement, divisé par une période donnée (ex: déploiements par semaine).
* **Objectif CareHub :** À la demande (Plusieurs fois par semaine).

### B. Délai de mise en production (Lead Time for Changes)
* **Définition :** Le temps écoulé entre un `git commit` par un développeur et son exécution effective en production.
* **Méthode de calcul :** Horodatage de la fin du pipeline de déploiement MOINS horodatage du commit initial. (Mesurable directement via les logs d'exécution GitHub Actions : environ 2 à 3 minutes).
* **Objectif CareHub :** Moins de 15 minutes.

### C. Délai moyen de restauration (Mean Time to Restore - MTTR)
* **Définition :** Le temps nécessaire pour restaurer le service aux utilisateurs après une panne.
* **Méthode de calcul :** Horodatage de la remise en ligne (healthcheck OK suite à la restauration) MOINS horodatage de l'alerte de panne (échec du smoke test).
* **Objectif CareHub :** Moins de 1 minute (Garantie par le rollback SSH automatique implémenté dans le pipeline).

### D. Taux d'échec des changements (Change Failure Rate)
* **Définition :** Le pourcentage de déploiements en production qui échouent ou nécessitent un correctif immédiat.
* **Méthode de calcul :** (Nombre de déclenchements de l'étape de Rollback / Nombre total de déploiements tentés) * 100.
* **Objectif CareHub :** Proche de 0% grâce à la rigueur des scans Trivy et Gitleaks qui bloquent le code non-conforme en amont.
