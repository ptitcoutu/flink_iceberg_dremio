# flink_iceberg_dremio
## Local Iceberg Dev Stack with Dremio, Flink, Kafka & Minio

This repository provides a `docker-compose` setup to quickly spin up a local development environment for Apache Iceberg.

The stack includes:
* **Dremio**: A powerful query engine to analyze your Iceberg tables.
* **Apache Flink**: A stream processing engine to read from/write to Iceberg tables.
* **Apache Kafka**: A message broker for data streaming.
* **Minio**: An S3-compatible object storage for Iceberg data and the Hadoop catalog.

This setup uses a simple **Hadoop Catalog** stored directly in Minio, avoiding the need for a Nessie server or Hive Metastore.

---

##  Prerequisites

* [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed.
* A shell environment (like Bash) with `curl` installed.

---

## 🚀 Getting Started

### 1. Download Dependencies

The Flink containers need the appropriate JAR files to connect to Kafka, S3 (Minio), and Iceberg. A helper script is provided to download them automatically.

Make the script executable and run it:
```bash
chmod +x ./download_prerequisites.sh
./download_prerequisites.sh