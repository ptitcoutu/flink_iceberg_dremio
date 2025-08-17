MINIO_DATA_FOLDER="$(pwd)/minio_data"
export MINIO_DATA_FOLDER
mkdir -p "${MINIO_DATA_FOLDER}"
docker volume create minio-data --opt type=none --opt o=bind  --opt device="${MINIO_DATA_FOLDER}"
DREMIO_DATA_FOLDER="$(pwd)/dremio_data"
export DREMIO_DATA_FOLDER
mkdir -p "${DREMIO_DATA_FOLDER}"
docker volume create dremio-data --opt type=none --opt o=bind  --opt device="${DREMIO_DATA_FOLDER}"