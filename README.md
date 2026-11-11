# Pedidos API

API REST de gestión de pedidos (Java 21 + Spring Boot 3.2) con un pipeline CI/CD completo:
Gitflow + GitHub Actions + Docker multi-stage + GHCR.

## Endpoints

| Método | Ruta | Descripción |
| --- | --- | --- |
| GET | `/api/pedidos` | Lista pedidos |
| GET | `/api/pedidos/{id}` | Consulta un pedido |
| POST | `/api/pedidos` | Crea un pedido |
| DELETE | `/api/pedidos/{id}` | Elimina un pedido |
| GET | `/actuator/health` | Health check del pipeline |

## Correr localmente

```bash
./mvnw clean test          # ejecuta los tests
./mvnw spring-boot:run     # levanta la API en http://localhost:8080

docker build -t pedidos-api:dev .
docker run -p 8080:8080 --name pedidos pedidos-api:dev
```

## Pipeline (`.github/workflows/ci-cd.yml`)

1. **build-and-test**: en cada push y PR a `main`/`develop`. Compila, prueba y sube el JAR como artefacto.
2. **docker-publish**: solo en push. Construye la imagen, la escanea con Trivy (reporte en *Security*) y la publica en GHCR con tags de rama, `sha-<commit>` y `latest` en `main`.
3. **deploy-staging**: solo en push a `develop`.

## Gitflow

- `main`: solo código de producción; cada commit es una versión etiquetada (`v1.0.0`, `v1.0.1`).
- `develop`: rama de integración.
- `feature/*` salen de `develop` y vuelven por PR.
- `release/*` salen de `develop` y se mergean a `main` + `develop`.
- `hotfix/*` salen de `main` y se mergean a `main` + `develop`.
