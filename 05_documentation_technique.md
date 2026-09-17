Partie A : Remobilisation de la chaîne CI/CD1.
Exécution et commentaires des étapes du pipelineLe pipeline GitHub Actions s'exécute en plusieurs étapes séquentielles et conditionnelles pour garantir le principe de fail-fast :  Checkout & Setup : Récupération du code source et configuration de l'environnement d'exécution (ex: Node.js ou Python) via les actions officielles.  

Tests & Linting : Installation des dépendances, vérification du formatage du code et exécution des tests unitaires et d'intégration. 
Le pipeline s'interrompt si une erreur est détectée.Sécurité (SAST & SCA) : Lancement de gitleaks pour détecter la présence de secrets dans le code, et de trivy (filesystem) pour scanner les vulnérabilités de l'infrastructure as code et des dépendances. 

Build & Push : Construction de l'image Docker et publication sur le registre GHCR (GitHub Container Registry) uniquement si les tests et les scans de sécurité sont validés. 

Déploiement : Connexion SSH au VPS (environnement de production) pour déclencher la mise à jour via docker compose pull et docker compose up -d. 

2. Protections en placeProtection de branche : La branche main est verrouillée.
3. Les fusions nécessitent l'approbation d'une Pull Request (validation humaine) et le passage au vert des contrôles automatisés (Status Checks) du pipeline.
4.
5. Matrice de versions : Les tests s'exécutent en parallèle sur une matrice de versions (ex: Node 18, 20 et 22) pour garantir la compatibilité ascendante de l'application.
6.
7.   Seuil de couverture : Un outil de type Codecov est intégré au pipeline pour imposer un seuil minimum de 70 % de lignes testées.
8.   Sous ce seuil, la Pull Request est bloquée.  Hooks de pré-commit : Des outils locaux (comme Husky ou pre-commit) empêchent la création d'un commit si le code ne respecte pas les règles de linting ou s'il contient des secrets évidents.
9.
10.   Détection de secrets : L'outil gitleaks scanne systématiquement l'historique et les nouveaux commits pour empêcher toute fuite de clés API ou de mots de passe sur le dépôt.
11.
12.   3. Chaîne d'image DockerDockerfile : L'image utilise une construction multi-stage pour séparer les outils de compilation du livrable final. Elle s'appuie sur une image de base alpine (minimale), s'exécute via un utilisateur non privilégié (non-root) et intègre une instruction HEALTHCHECK.
      4.
      5.   Durcissement du runner : Lors de l'utilisation d'un runner self-hosted sur le VPS, celui-ci est isolé via Docker, configuré en mode éphémère (EPHEMERAL: 'true') et ses privilèges système sont drastiquement réduits (ex: cap_drop: [ALL]).
      6.
      7. Signature de l'image : Pour garantir l'intégrité de la chaîne d'approvisionnement (Supply Chain), l'image est signée de manière cryptographique sans clé statique (keyless) en utilisant Cosign et l'authentification OIDC avant d'être poussée sur GHCR.
      8.
      9.   Génération du SBOM : Un inventaire détaillé des composants logiciels (Software Bill of Materials) est généré au moment de la construction de l'image pour tracer précisément toutes les bibliothèques et dépendances embarquées en production.
      10.
      11.   4. Procédure de retour arrière (Rollback)La continuité de service est assurée par un smoke test exécuté via le pipeline immédiatement après le déploiement sur le serveur de production. Si le point de terminaison de santé de l'application (/health) ne répond pas correctement, le workflow exécute une clause conditionnelle de remédiation : il se reconnecte au VPS, récupère l'identifiant (tag) de l'image de la version précédente (N-1) et déclenche un redéploiement d'urgence avec cette version stable.
            5.
            6.   5. Faiblesses de la chaîne actuelleDépendance forte aux services Cloud externes : L'architecture repose entièrement sur la disponibilité des services GitHub (Actions, GHCR). U
                 6. ne panne majeure de cette plateforme paralyse la capacité de l'équipe à livrer des correctifs urgents ou à opérer des retours arrière.Absence de tests dynamiques de sécurité (DAST) : La chaîne valide la logique métier et analyse statiquement le code, mais elle ne simule actuellement aucun trafic réel ni aucune attaque dynamique (comme l'injection SQL ou le fuzzing HTTP) sur un environnement de recette avant de promouvoir l'application en production.  
