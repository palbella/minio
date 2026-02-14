# ETAPA 1: Compilación (Aquí es donde se crea el archivo 'minio' que te falta)
FROM golang:1.21-alpine AS builder

WORKDIR /src
COPY . .

# Compilamos el código fuente para generar el binario
RUN go build -o minio .

# ETAPA 2: Imagen final
FROM alpine:3.19

# Instalamos dependencias para que MinIO funcione en Alpine
RUN apk add --no-cache ca-certificates curl

# Copiamos el binario recién fabricado y el script de entrada
COPY --from=builder /src/minio /usr/bin/minio
COPY dockerscripts/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN chmod +x /usr/bin/minio /usr/bin/docker-entrypoint.sh

EXPOSE 9000 9001

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
# El comando server /data es necesario para que MinIO arranque
CMD ["server", "/data"]