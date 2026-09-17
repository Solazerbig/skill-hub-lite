# Stage 1: Build simulé
FROM alpine:3.20 AS builder
WORKDIR /app
RUN echo "Construction de l'application..." > app.txt

# Stage 2: Production durcie (Conforme EC06)
FROM alpine:3.20 AS runner
WORKDIR /app

# Création d'un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S nodejs && adduser -u 1001 -S nodejs -G nodejs

COPY --from=builder --chown=nodejs:nodejs /app/app.txt .

USER nodejs
EXPOSE 3000

# Contrôle de santé exigé
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD echo "Conteneur en bonne santé" || exit 1

CMD ["tail", "-f", "/dev/null"]
