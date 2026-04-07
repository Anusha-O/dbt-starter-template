SELECT
  id,
  name
FROM {{ ref('sample_seed') }}
