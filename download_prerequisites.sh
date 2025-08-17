#!/bin/bash

# --- Version Configuration ---
# Ensure these versions are compatible with the Flink image in your docker-compose.yml (1.17.1)
FLINK_VERSION="1.20.0"
ICEBERG_VERSION="1.9.2"
HADOOP_VERSION="3.4.1"
AWS_SDK_VERSION="1.12.788"
FLINK_KAFKA_CONNECTOR_VERSION="3.4.0-1.20"

# --- Destination Directory ---
JAR_DIR="flink-jars"

# --- Cleanup and Directory Creation ---
echo "--- Creating directory ${JAR_DIR} ---"
rm -rf "${JAR_DIR}"
mkdir -p "${JAR_DIR}"

# --- Download Function ---
download_jar() {
  url=$1
  filename=$(basename "$url")
  echo "Downloading ${filename}..."
  curl -L -o "${JAR_DIR}/${filename}" "$url"
  if [ $? -ne 0 ]; then
    echo "ERROR: Download of ${filename} failed."
    exit 1
  fi
}

# --- Download Dependencies from Maven Central ---
echo "--- Downloading Flink/Iceberg/S3 dependencies ---"

# 1. Iceberg Flink Runtime
download_jar "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-${FLINK_VERSION}/${ICEBERG_VERSION}/iceberg-flink-runtime-${FLINK_VERSION}-${ICEBERG_VERSION}.jar"

# 2. Flink SQL Connector for Kafka
download_jar "https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kafka/${FLINK_KAFKA_CONNECTOR_VERSION}/flink-sql-connector-kafka-${FLINK_KAFKA_CONNECTOR_VERSION}.jar"

# 3. S3 Support (Hadoop AWS)
download_jar "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar"

# 4. AWS SDK Bundle (dependency for hadoop-aws)
download_jar "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar"

echo "✅ All prerequisites have been successfully downloaded into the '${JAR_DIR}' directory."