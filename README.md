# dbt Starter Template (BigQuery)

## Overview

This repository provides a **production-ready dbt starter template** designed for scalable, maintainable, and standardized data pipelines.

It includes:

* Pre-configured project structure
* Multi-environment setup (dev / qa / prod)
* CI/CD pipeline with GitHub Actions
* SQL quality checks using SQLFluff
<<<<<<< HEAD
* Seed-based demo models for instant validation

# Goal: **Clone → Setup → Run → Works immediately**
=======
* Example models and structure for custom data implementation

**Goal:** Clone → Configure → Run → Works successfully
>>>>>>> main

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
<<<<<<< HEAD
seeds/
=======
seeds/ (optional)
>>>>>>> main
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

<<<<<<< HEAD
Run the following:

```bash
dbt debug --target dev
dbt deps
dbt seed
=======
```bash
dbt debug --target dev
dbt deps
>>>>>>> main
dbt build --target dev
```

### Expected Result

* Connection successful
<<<<<<< HEAD
* Seed data loaded
* Models created
* Tests passing

If this works, your setup is correct 
=======
* Models run successfully (based on user configuration)
* No errors during execution
>>>>>>> main

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

<<<<<<< HEAD
| Branch    | Purpose     |
| --------- | ----------- |
| feature/* | Development |
| dev       | Integration |
| main      | Production  |

Flow:

```
feature → dev → main
```
=======
| Branch         | Purpose                    |
| -------------- | -------------------------- |
| feature/*      | Development                |
| dev            | Integration                |
| main           | Stable / Production        |
| clean-template | Clean template for sharing |

Flow:

```
feature → dev → main
```

**Note:**
The `clean-template` branch is a simplified version intended for peer review and reuse.
It is not part of the CI/CD workflow.
>>>>>>> main

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

<<<<<<< HEAD
### Notes

* Uses **seed-based demo data** (no external dependencies)
* Source freshness is disabled by default
* Manifest storage (GCS) is optional and disabled
=======
## Git & CI/CD Setup Guide

This template includes a GitHub Actions pipeline for CI/CD.
However, after cloning, you must configure it in your own repository.

---

### 1. Create Your Own Repository

```bash
git remote remove origin
git remote add origin <your-repo-url>
git push -u origin main
```

---

### 2. Enable GitHub Actions

* Go to your repository → **Actions tab**
* Enable workflows if prompted

---

### 3. Configure Secrets

Go to:

Settings → Secrets and Variables → Actions

Add the following:

* DBT_KEYFILE_JSON
* DBT_GCP_PROJECT_QA
* DBT_GCP_PROJECT_PROD
* DBT_MANIFEST_BUCKET (optional)

---

### 4. Verify CI/CD

#### Pull Request → dev

```bash
git checkout -b feature/test-ci
git add .
git commit -m "Test CI"
git push origin feature/test-ci
```

Create PR → dev

Expected:

* SQLFluff runs
* dbt debug runs
* Slim CI executes

---

#### Merge → main

Expected:

* Full dbt build runs

---

### Notes

* CI/CD requires project-specific configuration
* Without secrets, workflows will fail
* This setup mirrors real-world production pipelines
>>>>>>> main

---

## SQL Linting (SQLFluff)

<<<<<<< HEAD
Run locally:

=======
>>>>>>> main
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
<<<<<<< HEAD

Run checks:
=======
>>>>>>> main

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

<<<<<<< HEAD
* **Self-contained** → no external data required
* **Zero-setup** → works immediately after cloning
* **Production-ready** → supports CI/CD and environments
* **Extensible** → advanced features can be enabled later
=======
* Self-contained
* Quick to set up
* Production-ready
* Extensible
>>>>>>> main

---

## Optional Advanced Features

<<<<<<< HEAD
These are disabled by default but can be enabled:

* Source freshness checks (for real data sources)
* Manifest storage (for advanced Slim CI)
=======
These can be enabled as needed:

* Source freshness checks
* Manifest storage for Slim CI
>>>>>>> main
* External data sources

---

## Goal

* Standardize dbt development
* Enable quick onboarding
* Ensure data quality
* Provide reusable architecture

---

## Summary

<<<<<<< HEAD
A clean, scalable, and production-ready dbt template that works out of the box and can be extended for enterprise use.
=======
A clean, scalable, and production-ready dbt template that can be configured and extended for real-world data workflows.
>>>>>>> main
