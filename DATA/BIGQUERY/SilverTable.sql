--Step 1: Create the customers Table in the Silver Layer
CREATE TABLE IF NOT EXISTS `pivotal-bolt-473013-k5.silver_dataset.customers` (
  customer_id INT64,
  name STRING,
  email STRING,
  updated_at STRING,
  is_quarantined BOOL,
  effective_start_date TIMESTAMP,
  effective_end_date TIMESTAMP,
  is_active BOOL
);

--Step 2: Update Existing Active Records if There Are Changes
MERGE INTO `pivotal-bolt-473013-k5.silver_dataset.customers` target
USING (
  SELECT DISTINCT
    *,
    CASE
      WHEN customer_id IS NULL OR email IS NULL OR name IS NULL THEN TRUE
      ELSE FALSE
    END AS is_quarantined,
    CURRENT_TIMESTAMP() AS effective_start_date,
    CURRENT_TIMESTAMP() AS effective_end_date,
    True As is_active
  FROM `pivotal-bolt-473013-k5.bronze_dataset.customers` ) source
ON target.customer_id = source.customer_id AND target.is_active = True
WHEN MATCHED AND 
                
