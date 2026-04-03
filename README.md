# dbt Starter Template (BigQuery)

## Overview
This repository provides a standardized dbt project template for building
scalable and maintainable data pipelines using a layered architecture.
It allows any team member to set up and run a dbt project quickly with
pre-configured structure, templates, and macros.

---

## Architecture
The project follows a three-layer approach:

| Layer        | Purpose                                  | Materialization |
|--------------|------------------------------------------|-----------------|
| Staging      | Clean and standardize raw data           | View            |
| Intermediate | Apply joins and business logic           | View            |
| Marts        | Final models for reporting and analytics | Table           |

---

## Project Structure
```
models/
  staging/
    sources.yml
    schema.yml
    stg_your_source__your_table.sql
  intermediate/
    schema.yml
    int_your_entity__your_transformation.sql
  marts/
    schema.yml
    fct_your_entity.sql
    dim_your_entity.sql
dbt_macro_utils/
tests/
seeds/
snapshots/
analyses/
dbt_project.yml
packages.yml
profiles.yml
.env
.gitignore
```

---

## Prerequisites

- Python 3.8 or higher
- dbt with BigQuery adapter
- Google Cloud service account with BigQuery access

Install dbt:
```bash
pip install dbt-bigquery
```

---

## Quick Start

**1. Clone the repository**
```bash
git clone <repo-url>
cd <project-folder>
```

**2. Configure environment variables**
```bash
# fill in real values in .env
source .env
```

**3. Verify connection**
```bash
dbt debug --target dev
```

**4. Install dependencies**
```bash
dbt deps
```

**5. Run the project**
```bash
dbt seed                      # load static seed files
dbt source freshness          # check raw data is up to date
dbt run --target dev          # build models
dbt test --target dev         # run tests
```

**6. Generate documentation**
```bash
dbt docs generate
dbt docs serve
```

---

## Environment Variables

All sensitive values are managed via environment variables.
See `.env` for the full list of required variables.

| Variable | Description | Default |
|---|---|---|
| `DBT_TARGET` | Active target | `dev` |
| `DBT_DATASET` | Base dataset name | — |
| `DBT_GCP_PROJECT_DEV` | GCP project ID for dev | — |
| `DBT_GCP_PROJECT_QA` | GCP project ID for qa | — |
| `DBT_GCP_PROJECT_PROD` | GCP project ID for prod | — |
| `DBT_KEYFILE_DEV` | Service account path for dev | — |
| `DBT_KEYFILE_QA` | Service account path for qa | — |
| `DBT_KEYFILE_PROD` | Service account path for prod | — |
| `DBT_THREADS_DEV` | Parallel threads for dev | `4` |
| `DBT_THREADS_QA` | Parallel threads for qa | `4` |
| `DBT_THREADS_PROD` | Parallel threads for prod | `8` |

---

## Packages

| Package | Purpose |
|---|---|
| `dbt_utils` | Utility macros — surrogate keys, expression tests |
| `dbt_expectations` | Extended data quality tests — range checks, regex, row counts |

Install packages:
```bash
dbt deps
```

---

## Key Features

**Pre-configured structure**
- Layered model organization
- Production-ready configuration
- Environment-based target separation (dev / qa / prod)

**Reusable templates**
- `stg_your_source__your_table.sql`
- `int_your_entity__your_transformation.sql`
- `fct_your_entity.sql`
- `dim_your_entity.sql`

**Macro support**
```sql
{{ audit_columns('source_name') }}
```
Automatically adds:
- `_loaded_at` — timestamp when row was loaded
- `_source_system` — source system identifier
- `_dbt_model` — dbt model name that produced the row

---
`deduplicate_latest` — Removes duplicates keeping the latest record
```sql
{{ deduplicate_latest(
    relation   = ref('stg_your_source__your_table'),
    partition_by = 'id',
    order_by   = 'updated_at'
) }}
```
- Partitions by specified column
- Keeps latest record based on `order_by` column
- Automatically excludes row number column from output

`incremental_filter` — Standard incremental filter pattern
```sql
{{ incremental_filter('created_at') }}
```
- Only processes new records on incremental runs
- No-op on full refresh runs

---
## Development Guidelines

**Staging**
- Apply minimal transformations
- Use `source()` for raw tables, `ref()` for upstream models
- Avoid joins — keep models atomic
- Rename and cast columns only

**Intermediate**
- Apply joins and business logic
- Use CTEs for readability
- Select only required columns in each CTE

**Marts**
- Final business-ready models
- Select only required columns — no `SELECT *`
- Use `audit_columns` macro — do not hardcode audit fields
- Apply strict validation in `schema.yml`

---

## Naming Conventions

| Layer | Convention | Example |
|---|---|---|
| Staging | `stg_<source>__<table>` | `stg_shopify__orders` |
| Intermediate | `int_<entity>__<logic>` | `int_orders__enriched` |
| Fact | `fct_<entity>` | `fct_orders` |
| Dimension | `dim_<entity>` | `dim_customers` |

---

## Testing Strategy

| Layer | Severity | Tests |
|---|---|---|
| Staging | `warn` | `unique`, `not_null` on PK |
| Intermediate | `warn` | Optional — only where meaningful |
| Marts | `error` | `unique`, `not_null` on PK, `not_null` on audit columns |

---

## Creating a New Model

1. Copy the appropriate template from the layer folder
2. Remove `{{ config(enabled=false) }}`
3. Rename using naming conventions above
4. Replace `ref()` or `source()` with actual model names
5. Select only required columns
6. Add model to `schema.yml` with description and tests

---

## CI/CD
```bash
# QA
dbt run --target qa
dbt test --target qa

# Production
dbt run --target prod
dbt test --target prod
```

Targets are controlled via `DBT_TARGET` environment variable.
Set this in your CI/CD secrets alongside other required env vars.

---

## Goal
- Standardize dbt development across teams
- Enable quick onboarding for new engineers
- Ensure data quality at every layer
- Build scalable and maintainable data pipelines

---

## Summary
Standardize, simplify, and scale data workflows using a
structured dbt framework built for BigQuery.