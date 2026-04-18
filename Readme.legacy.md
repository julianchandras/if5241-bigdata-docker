# Stack Big Data Legacy (HO_04)

## Purpose

This file documents the legacy runtime used for the HO_04 streaming notebook.
It exists so you can run the old Spark Streaming + Kafka notebook without mixing it with the main Spark 3.5 stack.

---

## What This Stack Uses

| Service            | Purpose                                                     | Port                                 |
| ------------------ | ----------------------------------------------------------- | ------------------------------------ |
| `jupyter-legacy`   | JupyterLab with PySpark 2.4.8                               | `8890`                               |
| `kafka-legacy`     | Kafka broker for the notebook and producer/consumer scripts | `9093` on host, `9092` inside Docker |
| `zookeeper-legacy` | ZooKeeper for the legacy Kafka broker                       | internal only                        |

Runtime details:

- Python 3.7
- PySpark 2.4.8
- Java 8 via Temurin JRE
- Kafka Streaming connector `spark-streaming-kafka-0-8_2.11:2.4.8`

---

## Start The Legacy Stack

```bash
docker compose -f docker-compose.legacy.yml up -d
```

If you only want to refresh the notebook container:

```bash
docker compose -f docker-compose.legacy.yml up -d --no-deps --force-recreate jupyter-legacy
```

If you rebuild the image after changing the Dockerfile:

```bash
docker compose -f docker-compose.legacy.yml build jupyter-legacy
docker compose -f docker-compose.legacy.yml up -d --no-deps --force-recreate jupyter-legacy
```

---

## Stop The Legacy Stack

```bash
docker compose -f docker-compose.legacy.yml stop
```

To remove everything, including volumes:

```bash
docker compose -f docker-compose.legacy.yml down -v
```

---

## Notebook Run Order

1. Open Jupyter at http://localhost:8890
2. Restart the kernel
3. Run the Spark context cell
4. Run the streaming cell
5. Run `producer_variance.py` from the HO_04 folder

If you rerun the streaming cell, stop the active stream first by running the cleanup cell.

---

## Kafka Endpoints

Use these endpoints depending on where the code runs:

- Inside Docker containers: `kafka-legacy:9092`
- On the host machine: `localhost:9093`

That means:

- The notebook cell should use `kafka-legacy:9092`
- `producer_variance.py` and `consumer_variance.py` should use `localhost:9093`

---

## Notebook Notes

The notebook is already adjusted for the legacy flow:

- SparkContext is initialized with JavaSerializer
- Kafka direct stream parsing handles the `(key, value)` shape
- A cleanup cell is available to stop the active StreamingContext

If you see `Only one StreamingContext may be started in this JVM`, run the cleanup cell first or restart the kernel.
