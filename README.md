# dbt Starter Template (BigQuery)

## Overview

This repository provides a **production-ready dbt starter template** designed for scalable, maintainable, and standardized data pipelines.

It includes:

* Pre-configured project structure
* Multi-environment setup (dev / qa / prod)
* CI/CD pipeline with GitHub Actions
* SQL quality checks using SQLFluff
* Seed-based demo models for instant validation

# Goal: **Clone → Setup → Run → Works immediately**

---

## Architecture

| Layer        | Purpose                         | Materialization |
| ------------ | ------------------------------- | --------------- |
| Staging      | Clean and standardize data      | View            |
| Intermediate | Apply joins and transformations | View            |
| Marts        | Final business-ready models     | Table           |

---

## Project Structure

```
models/
  staging/
  intermediate/
  marts/
seeds/
macros/
snapshots/
analyses/
.github/workflows/
dbt_project.yml
packages.yml
profiles.yml
.env.example
```

---

## Prerequisites

* Python 3.8+
* Google Cloud account (BigQuery)
* Service account JSON key

---

## Setup

### 1. Clone the repository

```bash
git clone <repo-url>
cd dbt-starter-template
```

---

### 2. Create virtual environment

```bash
# Mac/Linux
python -m venv dbt-env
source dbt-env/bin/activate

# Windows
python -m venv dbt-env
dbt-env\Scripts\activate
```

---

### 3. Install dependencies

```bash
pip install dbt-bigquery
```

---

### 4. Configure environment variables

```bash
# Copy example
cp .env.example .env   # Mac/Linux
copy .env.example .env # Windows
```

Update `.env` with your values.

Load environment variables:

```bash
# Windows
.\load_env.ps1

# Mac/Linux
source load_env.sh
```

---

## Environment Variables

| Variable             | Description          |
| -------------------- | -------------------- |
| DBT_TARGET           | dev / qa / prod      |
| DBT_DATASET          | Base dataset         |
| DBT_GCP_PROJECT_DEV  | GCP project (dev)    |
| DBT_GCP_PROJECT_QA   | GCP project (qa)     |
| DBT_GCP_PROJECT_PROD | GCP project (prod)   |
| DBT_KEYFILE_DEV      | Service account path |
| DBT_KEYFILE_QA       | Service account path |
| DBT_KEYFILE_PROD     | Service account path |

---

## First Run (Important)

Run the following:

```bash
dbt debug --target dev
dbt deps
dbt seed
dbt build --target dev
```

### Expected Result

* Connection successful
* Seed data loaded
* Models created
* Tests passing

If this works, your setup is correct 

---

## Development Workflow

### Run locally

```bash
dbt build --target dev
```

### Run QA locally (optional)

```bash
dbt build --target qa
```

---

## Branching Strategy

| Branch    | Purpose     |
| --------- | ----------- |
| feature/* | Development |
| dev       | Integration |
| main      | Production  |

Flow:

```
feature → dev → main
```

---

## CI/CD Pipeline

### On Pull Request → dev

* SQLFluff (SQL linting)
* dbt debug (connection check)
* dbt Project Evaluator (governance)
* Slim CI (runs only modified models)

---

### On Merge → main

* Full dbt build runs on production

---

### Notes

* Uses **seed-based demo data** (no external dependencies)
* Source freshness is disabled by default
* Manifest storage (GCS) is optional and disabled

---

## SQL Linting (SQLFluff)

Run locally:

```bash
sqlfluff lint models/
sqlfluff fix models/
```

Rules enforced:

* No SELECT *
* Uppercase SQL keywords
* snake_case naming

---

## Governance

Run checks:

```bash
dbt build --select package:dbt_project_evaluator
```

---

## Creating a New Model

1. Create model in appropriate layer
2. Use naming conventions
3. Add tests in schema.yml
4. Run:

```bash
sqlfluff lint
dbt build
```

---

## Design Philosophy

This template is designed to be:

* **Self-contained** → no external data required
* **Zero-setup** → works immediately after cloning
* **Production-ready** → supports CI/CD and environments
* **Extensible** → advanced features can be enabled later

---

## Optional Advanced Features

These are disabled by default but can be enabled:

* Source freshness checks (for real data sources)
* Manifest storage (for advanced Slim CI)
* External data sources

---

## Goal

* Standardize dbt development
* Enable quick onboarding
* Ensure data quality
* Provide reusable architecture

---

## Summary

A clean, scalable, and production-ready dbt template that works out of the box and can be extended for enterprise use.