# Usage Guide

This guide explains how to interact with the services after launching the stack with `docker-compose up -d`.

## 1. Writing to Iceberg with Flink SQL

You can use the Flink SQL Client to create catalogs, define tables, and insert data from streams or batches.

### Step 1: Connect to the Flink Container

Open an interactive shell in the `flink-jobmanager` container to access the Flink distribution.

```bash
docker exec -it flink-jobmanager /bin/bash
```

### Step 2: Launch the Flink SQL Client
From inside the container's shell, start the SQL client.
```bash
./bin/sql-client.sh
```

### Step 3: Define Catalog and Tables
Execute SQL commands to set up your Iceberg environment. The client will submit these commands as Flink jobs.

```SQL
-- Create a Hadoop catalog pointing to the Minio bucket.
-- This catalog stores metadata for your Iceberg tables directly in the S3 bucket.
CREATE CATALOG hadoop_catalog WITH (
  'type'='iceberg',
  'catalog-type'='hadoop',
  'warehouse'='s3a://warehouse/',
  'property-fs.s3a.endpoint'='http://minio:9000',
  'property-fs.s3a.access.key'='admin',
  'property-fs.s3a.secret.key'='password',
  'property-fs.s3a.path.style.access'='true'
);

-- Switch the current session to use the newly created catalog.
USE CATALOG hadoop_catalog;

-- Create your first Iceberg table.
-- The 'format-version'='2' property enables features like row-level updates and deletes.
CREATE TABLE my_iceberg_table (
  id BIGINT,
  name STRING,
  event_timestamp TIMESTAMP(3)
) WITH (
  'format-version'='2'
);

-- Insert some sample data into the table.
INSERT INTO my_iceberg_table VALUES
  (1, 'Alice', TO_TIMESTAMP_LTZ(1672531200, 3)),
  (2, 'Bob', TO_TIMESTAMP_LTZ(1672534800, 3));
```
You can now check the Flink UI at http://localhost:8081 to see the completed jobs. You can also browse the Minio console at http://localhost:9001 to see the data and metadata files created in the `warehouse` bucket.

## 2. Querying Iceberg Data with Dremio
   Dremio provides a user-friendly UI to explore and query your Iceberg tables with high performance.

### Step 1: Access the Dremio UI
Navigate to http://localhost:9047 in your web browser. The first time you access it, you will be prompted to create an administrator account.

### Step 2: Add Minio as a Data Source
1. On the main dashboard, click "Add Source" (usually at the bottom-left).
2. Select "Amazon S3" from the list of available sources.
3. Fill in the configuration form:
* Name: minio_iceberg (or any other descriptive name).
* Authentication: Choose Access Key.
* AWS Access Key ID: admin
* AWS Access Secret: password
* Connection: Uncheck the "Encrypt connection" box since we are running locally without TLS.
4. Expand the "Advanced Options" section at the bottom.
5. Under "Connection Properties", add the following three properties to ensure Dremio can connect to Minio correctly:
* fs.s3a.endpoint: minio:9000
* fs.s3a.path.style.access: true
* dremio.s3.compat: true
6. Click Save.

### Step 3: Query Your Table
Once the source is saved, Dremio will automatically scan the `warehouse` bucket.
1. Navigate through the new minio_iceberg source in the left-hand panel.
2. You will see your `warehouse` bucket and inside it, the `my_iceberg_table` you created with Flink.
3. Dremio will automatically recognize it as an Iceberg table (indicated by a special icon).
4. Click on the table to open a new SQL query tab.
5. Run a query to see your data:

```SQL
SELECT * FROM minio_iceberg.warehouse.my_iceberg_table
```
You can now use Dremio's full capabilities to analyze your data, join it with other sources, or create virtual datasets.