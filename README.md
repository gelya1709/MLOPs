# LendingClub Default Prediction — End-to-End MLOps on Databricks

![image](https://www.databricks.com/company/newsroom/press-releases/introducing-shutterstock-imageai-powered-databricks-image)

## Overview

This project demonstrates a production-style MLOps workflow on Databricks using LendingClub loan data.
The focus is not only on model training, but on operationalizing a model end to end: from raw data ingestion to deployment and monitoring.

The use case is binary classification — predicting probability of loan default.

## Architecture & Stack

- Databricks Lakehouse
- Unity Catalog (tables & volumes)
- Apache Spark (data processing & ML)
- MLflow (experiments, registry, serving)
- Databricks Jobs & SQL Dashboards

Design principles:
- Bronze / Silver / Gold data layers
- Append-only, traceable data
- Versioned and reproducible models

## Data Pipeline
### Bronze — Raw ingestion
- Raw CSV files ingested from a Unity Catalog Volume
- Metadata added (_source_file, _ingest_ts)
- Deduplication by source file
- Stored as Delta table

### Silver — Feature preparation
- Column cleanup and leakage removal
- Separation of numeric and categorical features
- Label preparation for modeling

### Gold — Predictions
- Batch inference outputs appended
- Stored predictions with: predicted probability, predicted label, true label, model name & alias, scoring timestamp and date

## Model Training
- Logistic Regression with Spark ML
- Median imputation for numeric features
- Feature hashing for categoricals (controls dimensionality)
- Class imbalance handled via weights
- Full preprocessing + model wrapped in a single Spark ML Pipeline

Training and validation metrics are logged to MLflow, and the model is registered and promoted to the Champion alias.

## Deployment
### Batch Inference
- Implemented as a Databricks Job
- Loads the Champion model from registry
- Scores new data and appends to Gold table
- Enables historical monitoring

### Real-Time Serving (Optional)
- Model deployed via Databricks Model Serving
- REST endpoint returns default probability
- Supports partial inputs
- Scales to zero when idle

## Monitoring & Drift Detection

A lightweight but credible monitoring layer is implemented:
- AUC over time
- Population Stability Index (PSI) on predicted probabilities
- Default rate by score band

Monitoring metrics are written to Delta tables and visualized using Databricks SQL Dashboards, which update automatically as jobs run.
Synthetic drift is introduced to demonstrate how monitoring detects population shifts.

## Notes 
The project intentionally avoids over-engineering and focuses on realistic industry practices.
It can be extended with automated retraining, alerting, or CI/CD via Databricks API/CLI.
