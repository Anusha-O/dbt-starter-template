# dbt Starter Template (BigQuery)
## test
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
  audit_columns.sql
  deduplicate_latest.sql
  incremental_filter.sql 
tests/
  sample_test.sql
seeds/
  seed.yml
  sample_seed.csv
snapshots/
snapshots.yml
snapshot_sql_example.sql
analyses/
dbt_project.yml
packages.yml
profiles.yml
.env.example
.gitignore
.sqlfluff
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
# copy example file and fill in real values
   cp .env.example .env.local   (Mac/Linux)
   copy .env.example .env.local (Windows)
 Update `.env.local` with your credentials
```
Do NOT commit `.env.local` (it contains sensitive information)
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
dbt seed                # load static seed files
dbt source freshness   # check raw data is up to date
dbt run --target dev   # build models
dbt test --target dev   # run tests
```

**6. Generate documentation**
```bash
dbt docs generate
dbt docs serve
```


## Packages

| Package | Purpose |
|---|---|
| `dbt_utils` | Utility macros — surrogate keys, expression tests |
| `dbt_expectations` | Extended data quality tests — range checks, regex, row counts |
| `dbt_project_evaluator` | Automated governance — naming, folder structure, documentation coverage |

Install packages:
```bash
dbt deps
```
Run governance checks:
```bash
dbt build --select package:dbt_project_evaluator
```

---
## Macro Package

**`audit_columns()`** — Adds standard audit fields to every mart model
```sql
{{ audit_columns('source_name') }}
```
Automatically adds:
- `_loaded_at` — timestamp when row was loaded into warehouse
- `_source_system` — source system identifier (e.g. shopify, stripe)
- `_dbt_model` — dbt model name that produced this row

---

**`deduplicate_latest()`** — Removes duplicates keeping the latest record
```sql
{{ deduplicate_latest(
    relation     = ref('stg_your_source__your_table'),
    partition_by = 'id',
    order_by     = 'updated_at'
) }}
```
- Partitions by specified column
- Keeps latest record based on `order_by` column
- Excludes row number column from output via `SELECT * EXCEPT(rn)`

---

**`incremental_filter()`** — Standard incremental filter pattern
```sql
{{ incremental_filter('created_at') }}
```
- Only processes new records on incremental runs
- Falls back to `1900-01-01` on first run
- No-op on full refresh runs

---

## Key Features

**Pre-configured structure**
- Layered model organization
- Production-ready configuration
- Environment-based target separation (dev / qa / prod)
- Per-user dev dataset routing — no engineer overwrites another


**Reusable templates**
- `stg_your_source__your_table.sql` — staging template
- `int_your_entity__your_transformation.sql` — intermediate template
- `fct_your_entity.sql` — fact table template
- `dim_your_entity.sql` — dimension table template
- `snapshot_sql_example.sql` — SCD Type 2 snapshot template
- `sample_test.sql` — singular test template

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
## Source Freshness Tiers

| Tier | Warn after | Error after | Example sources |
|---|---|---|---|
| Critical | 2 hours | 6 hours | Payments, transactions, fraud |
| High | 12 hours | 24 hours | Customers, inventory, CRM |
| Medium | 24 hours | 48 hours | Products, pricing, marketing |
| Low | 48 hours | 7 days | Reference data, lookup tables |
| None | — | — | Seeds, manually managed tables |

Run freshness checks:
```bash
dbt source freshness
dbt source freshness --select source:shopify    # specific source only
```

---

## Branching Strategy

| Branch | Purpose | Merges into |
|---|---|---|
| `feature/*` | New work | `dev` via PR |
| `dev` | Integration testing | `main` via PR |
| `main` | Production | — |
```bash
# start new work
git checkout dev
git pull
git checkout -b feature/your-change

# push and open PR into dev
git push origin feature/your-change

# after PR approved → merge to dev
# open second PR → dev into main
# full prod build triggers automatically
```

Rules:
- Never commit directly to `dev` or `main`
- Always branch from `dev`, not `main`
- CI must pass before any PR is merged

---

## CI/CD Pipeline
All checks are automatically enforced on pull requests:

- SQL linting (SQLFluff)
- Governance validation (dbt Project Evaluator)
- Source freshness checks
- Slim CI (only modified models)

On merge to main:
- Full dbt build runs on production
- Manifest is updated for future Slim CI runs
### On every Pull Request → `dev`
Lint SQL (SQLFluff)
↓
dbt deps
↓
dbt Project Evaluator    ← governance checks
↓
dbt source freshness
↓
Slim CI: dbt build --select source_status:fresher+ state:modified+
--defer --state target/
↓
Cleanup CI dataset

### On merge to `main`
dbt source freshness
↓
dbt build --select source_status:fresher+ (full prod build)
↓
Upload manifest.json to GCS    ← powers next slim CI run

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `DBT_KEYFILE_JSON` | Full service account JSON content |
| `DBT_GCP_PROJECT_QA` | GCP project ID for QA |
| `DBT_GCP_PROJECT_PROD` | GCP project ID for prod |
| `DBT_MANIFEST_BUCKET` | GCS bucket storing `manifest.json` |

---

## SQL Linting (SQLFluff)

SQL style is enforced automatically in CI via SQLFluff.

Run locally before pushing:
```bash
# lint all models
sqlfluff lint models/

# lint a specific file
sqlfluff lint models/staging/stg_shopify__customers.sql

# auto-fix violations
sqlfluff fix models/
```

Rules enforced (configured in `.sqlfluff`):
- `L036` — no `SELECT *`
- `L010` — consistent keyword casing (uppercase)
- `L014` — snake_case column names

---

## Governance (dbt Project Evaluator)

Automated governance checks run in CI on every PR:
```bash
# run locally
dbt build --select package:dbt_project_evaluator

# check specific rule
dbt test --select package:dbt_project_evaluator
```

Checks enforced:
- Every model has `unique + not_null` on primary key
- Every model has a description in `.yml`
- All mart columns are documented
- Staging models are in `staging/` folder
- No model is missing a `.yml` entry


## Creating a New Model

1. Copy the appropriate template from the layer folder
2. Remove `{{ config(enabled=false) }}`
3. Rename using naming conventions above
4. Replace `ref()` or `source()` with actual model names
5. Select only required columns
6. Add model to `schema.yml` with description and tests
7. Run `sqlfluff lint` before committing


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