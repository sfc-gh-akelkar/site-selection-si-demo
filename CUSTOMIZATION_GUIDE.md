# Notebook Customization Guide

This guide walks you through the specific customizations needed to adapt `ML_E2E_PRODUCTION_DEMO.ipynb` for your use case.

## 🎯 Quick Start Checklist

Before running the notebook, complete these steps:

- [ ] Update configuration variables (DB, SCHEMA, WAREHOUSE)
- [ ] Upload your CSV data file to Snowflake stage
- [ ] Update data file path in COPY INTO command
- [ ] Customize feature engineering logic
- [ ] Define your entity (what you're predicting about)
- [ ] Specify your target variable
- [ ] Update column names throughout
- [ ] Customize feature descriptions
- [ ] Adjust model hyperparameters (optional)

## 📝 Step-by-Step Customization

### 1. Configuration Section (Cell 4)

**Location:** Early in the notebook

**What to change:**
```python
# BEFORE (example values)
DB = "YOUR_DATABASE"
SCHEMA = "YOUR_SCHEMA"
COMPUTE_WAREHOUSE = "YOUR_WAREHOUSE"

# AFTER (your actual values)
DB = "SALES_DB"
SCHEMA = "ML_MODELS"
COMPUTE_WAREHOUSE = "COMPUTE_WH"
```

**Why:** These variables are used throughout the notebook to connect to your Snowflake environment.

---

### 2. Data File Path (Cells 9, 11)

**Location:** Data ingestion section

**Cell 9 - Table creation:**
```sql
-- BEFORE
LOCATION => '@{{DB}}.{{SCHEMA}}.ML_DEMO_STAGE/YOUR_DATA_FILE.csv'

-- AFTER
LOCATION => '@SALES_DB.ML_MODELS.ML_DEMO_STAGE/customer_churn_data.csv'
```

**Cell 11 - Data loading:**
```sql
-- BEFORE
FROM @{{DB}}.{{SCHEMA}}.ML_DEMO_STAGE/YOUR_DATA_FILE.csv

-- AFTER
FROM @SALES_DB.ML_MODELS.ML_DEMO_STAGE/customer_churn_data.csv
```

**Why:** These paths tell Snowflake where to find your data.

---

### 3. Feature Engineering (Cell 18)

**Location:** Feature engineering section

**This is the most important customization!** Replace the example feature engineering logic with your own.

#### Example: Customer Churn Features

```python
feature_eng_dict = dict()

# Temporal features (if you have a signup/event date)
feature_eng_dict["ACCOUNT_AGE_DAYS"] = dayofyear(current_date()) - dayofyear("SIGNUP_DATE")
feature_eng_dict["SIGNUP_MONTH"] = month("SIGNUP_DATE")

# Engagement features
feature_eng_dict["LOGINS_PER_DAY"] = col("TOTAL_LOGINS") / col("ACCOUNT_AGE_DAYS")
feature_eng_dict["AVG_SESSION_DURATION"] = col("TOTAL_SESSION_TIME") / col("TOTAL_SESSIONS")

# Monetary features
feature_eng_dict["TOTAL_SPEND"] = col("MONTHLY_SPEND") * col("MONTHS_ACTIVE")
feature_eng_dict["SPEND_TREND"] = col("RECENT_3MO_SPEND") / col("PREVIOUS_3MO_SPEND")

# Comparative features (vs. cohort average)
cohort_window = Window.partition_by("CUSTOMER_SEGMENT")
feature_eng_dict["AVG_SEGMENT_SPEND"] = avg("MONTHLY_SPEND").over(cohort_window)
feature_eng_dict["ABOVE_AVG_SPENDER"] = (col("MONTHLY_SPEND") > col("AVG_SEGMENT_SPEND")).astype(IntegerType())

# Apply all transformations
df = df.with_columns(feature_eng_dict.keys(), feature_eng_dict.values())
```

#### Feature Engineering Patterns

**Temporal Features:**
```python
feature_eng_dict["MONTH"] = month("TIMESTAMP_COL")
feature_eng_dict["DAY_OF_WEEK"] = dayofweek("TIMESTAMP_COL")
feature_eng_dict["DAYS_SINCE_EVENT"] = datediff(current_date(), "EVENT_DATE")
```

**Derived Ratios:**
```python
feature_eng_dict["CONVERSION_RATE"] = col("CONVERSIONS") / col("VISITS")
feature_eng_dict["PRICE_PER_UNIT"] = col("TOTAL_PRICE") / col("QUANTITY")
```

**Window Aggregations:**
```python
window_spec = Window.partition_by("GROUP_COL").orderBy("TIME_COL")
feature_eng_dict["ROLLING_AVG"] = avg("VALUE_COL").over(window_spec.rowsBetween(-7, 0))
```

**Flags/Indicators:**
```python
feature_eng_dict["HIGH_VALUE_FLAG"] = (col("VALUE") > 1000).astype(IntegerType())
feature_eng_dict["IS_WEEKEND"] = col("DAY_OF_WEEK").isin([6, 7]).astype(IntegerType())
```

---

### 4. Entity Definition (Cell 25)

**Location:** Feature Store section

**What to change:**
```python
# BEFORE
ENTITY_NAME = "YOUR_ENTITY"
JOIN_KEY = "YOUR_ID_COLUMN"
ENTITY_DESC = "Features defined on a per [entity] level"

# AFTER (Customer Churn example)
ENTITY_NAME = "CUSTOMER"
JOIN_KEY = "CUSTOMER_ID"
ENTITY_DESC = "Features defined on a per customer level for churn prediction"

# AFTER (Fraud Detection example)
ENTITY_NAME = "TRANSACTION"
JOIN_KEY = "TRANSACTION_ID"
ENTITY_DESC = "Features defined on a per transaction level for fraud detection"
```

**Why:** The entity represents what your model makes predictions about.

---

### 5. Feature DataFrame Selection (Cell 27)

**Location:** Feature Store section

**What to change:**
```python
# BEFORE (commented out)
# feature_df = df.select([JOIN_KEY] + list(feature_eng_dict.keys()))

# AFTER
feature_df = df.select(["CUSTOMER_ID"] + list(feature_eng_dict.keys()))
feature_df.show(5)
```

**Why:** This creates the DataFrame that will be registered in the Feature Store.

---

### 6. Feature View Configuration (Cell 29)

**Location:** Feature Store section

**What to change:**
```python
# BEFORE
FEATURE_VIEW_NAME = "YOUR_FEATURE_VIEW_NAME"
TIMESTAMP_COL = "YOUR_TIMESTAMP_COLUMN"

# AFTER
FEATURE_VIEW_NAME = "CUSTOMER_CHURN_FEATURES"
TIMESTAMP_COL = "LAST_ACTIVITY_DATE"

# Define feature view
ml_fv = FeatureView(
    name=FEATURE_VIEW_NAME,
    entities=[ml_entity],
    feature_df=feature_df,
    timestamp_col=TIMESTAMP_COL,
    refresh_freq="1 day"
)

# Add feature descriptions
ml_fv = ml_fv.attach_feature_desc({
    "ACCOUNT_AGE_DAYS": "Number of days since customer signed up",
    "LOGINS_PER_DAY": "Average daily login frequency",
    "TOTAL_SPEND": "Lifetime customer spend",
    "ABOVE_AVG_SPENDER": "Binary flag: 1 if above segment average spend",
    # Add all your features here
})

# Register
ml_fv = fs.register_feature_view(ml_fv, version=VERSION_NUM, overwrite=True)
```

**Why:** This registers your features with descriptive metadata for team collaboration.

---

### 7. Dataset Generation (Cell 34)

**Location:** Feature Store section

**What to change:**
```python
# BEFORE
DATASET_NAME = f"ML_DATASET_{VERSION_NUM}"
TARGET_COLUMN = "YOUR_TARGET_COLUMN"

# AFTER
DATASET_NAME = f"CHURN_PREDICTION_DATASET_{VERSION_NUM}"
TARGET_COLUMN = "CHURNED"  # Binary: 1 = churned, 0 = active

ds = fs.generate_dataset(
    name=DATASET_NAME,
    spine_df=df.select(JOIN_KEY, TIMESTAMP_COL, TARGET_COLUMN),
    features=[ml_fv],
    spine_timestamp_col=TIMESTAMP_COL,
    spine_label_cols=[TARGET_COLUMN]
)
```

**Why:** This creates the final ML-ready dataset with features + target.

---

### 8. Train/Test Split Columns (Cell 48)

**Location:** Model training section

**What to change:**
```python
# BEFORE (example)
# X_train_pd = train_pd.drop([TIMESTAMP_COL, JOIN_KEY, TARGET_COLUMN], axis=1)
# y_train_pd = train_pd[TARGET_COLUMN]

# AFTER (use your actual column names)
X_train_pd = train_pd.drop(["LAST_ACTIVITY_DATE", "CUSTOMER_ID", "CHURNED"], axis=1)
y_train_pd = train_pd["CHURNED"]

xgb_base.fit(X_train_pd, y_train_pd)
```

**Why:** Ensures only features (not ID/timestamp/target) are used for training.

---

### 9. Model Name (Cell 53)

**Location:** Model Registry section

**What to change:**
```python
# BEFORE
MODEL_NAME = f"YOUR_MODEL_NAME_{VERSION_NUM}"

# AFTER
MODEL_NAME = f"CUSTOMER_CHURN_PREDICTOR_{VERSION_NUM}"
```

**Why:** Gives your model a descriptive name in the Model Registry.

---

### 10. Model Monitoring Segment Columns (Cell 114)

**Location:** Model monitoring section

**Optional but recommended:** Add segment columns to monitor different cohorts separately.

**Example:**
```sql
-- If you have a customer segment column
ALTER TABLE ML_TEST_{{VERSION_NUM}}
ADD COLUMN IF NOT EXISTS CUSTOMER_SEGMENT VARCHAR(50);

-- Then in the Model Monitor creation:
CREATE OR REPLACE MODEL MONITOR BASE_MODEL_MONITOR
WITH
    MODEL={{MODEL_NAME}}
    VERSION={{BASE_VERSION_NAME}}
    FUNCTION=predict
    SOURCE=ML_TEST_{{VERSION_NUM}}
    BASELINE=ML_TRAIN_{{VERSION_NUM}}
    TIMESTAMP_COLUMN={{TIMESTAMP_COL}}
    PREDICTION_CLASS_COLUMNS=(BASELINE_PREDICTION)
    ACTUAL_CLASS_COLUMNS=({{TARGET_COLUMN}})
    ID_COLUMNS=({{JOIN_KEY}})
    SEGMENT_COLUMNS=('CUSTOMER_SEGMENT')  -- Add this line
    WAREHOUSE={{COMPUTE_WAREHOUSE}}
    REFRESH_INTERVAL='12 hours'
    AGGREGATION_WINDOW='1 day';
```

**Why:** Allows you to monitor model performance separately for different groups (e.g., enterprise vs. SMB customers).

---

## 🔄 Common Use Case Adaptations

### Customer Churn Prediction

```python
# Entity
ENTITY_NAME = "CUSTOMER"
JOIN_KEY = "CUSTOMER_ID"

# Target
TARGET_COLUMN = "CHURNED"  # 1 = churned, 0 = retained

# Example features
feature_eng_dict["MONTHS_SINCE_SIGNUP"] = months_between(current_date(), "SIGNUP_DATE")
feature_eng_dict["SUPPORT_TICKETS_PER_MONTH"] = col("TOTAL_TICKETS") / col("MONTHS_SINCE_SIGNUP")
feature_eng_dict["PAYMENT_FAILURES"] = col("FAILED_PAYMENTS").cast(IntegerType())
```

### Fraud Detection

```python
# Entity
ENTITY_NAME = "TRANSACTION"
JOIN_KEY = "TRANSACTION_ID"

# Target
TARGET_COLUMN = "IS_FRAUD"  # 1 = fraudulent, 0 = legitimate

# Example features
feature_eng_dict["TRANSACTION_HOUR"] = hour("TRANSACTION_TIMESTAMP")
feature_eng_dict["AMOUNT_VS_AVG_USER"] = col("AMOUNT") / col("USER_AVG_AMOUNT")
feature_eng_dict["TIME_SINCE_LAST_TRANSACTION"] = datediff("TRANSACTION_TIMESTAMP", "PREV_TRANSACTION_TIME")
```

### Sales Forecasting (Regression)

```python
# Entity
ENTITY_NAME = "PRODUCT"
JOIN_KEY = "PRODUCT_ID"

# Target
TARGET_COLUMN = "NEXT_MONTH_SALES"  # Continuous value

# Model change
from xgboost import XGBRegressor  # Instead of XGBClassifier
xgb_base = XGBRegressor(...)  # Use regressor

# Metrics change
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
rmse = np.sqrt(mean_squared_error(y_true, y_pred))
mae = mean_absolute_error(y_true, y_pred)
r2 = r2_score(y_true, y_pred)
```

---

## 🧪 Testing Your Customizations

Before running the full notebook:

1. **Test data loading:**
   - Run cells 1-11 to ensure your data loads correctly
   - Check the inferred schema with `desc table ML_DEMO_DATA`

2. **Test feature engineering:**
   - Run your feature engineering cell
   - Execute `df.show(10)` to preview results
   - Check for null values: `df.select([col for col in df.columns]).summary().show()`

3. **Test Feature Store:**
   - Verify entity registration: `fs.list_entities()`
   - Verify feature view: `fs.list_feature_views()`

4. **Test small sample first:**
   - Limit your data: `df = df.limit(1000)` for initial testing
   - Reduce HPO trials: `num_trials=2` instead of 8

---

## ⚠️ Common Pitfalls

1. **Mismatched column names:** Ensure column names match throughout (case-sensitive!)

2. **Missing columns in drop statements:** If you get "column not found" errors, check your drop statements match your data

3. **Incorrect data types:** Ensure your target is binary (0/1) for classification

4. **Timestamp format issues:** Snowflake is flexible, but use `to_timestamp()` if needed

5. **Feature Store errors:** Ensure `TIMESTAMP_COL` exists in your `feature_df`

---

## 📚 Additional Tips

- **Start with a subset:** Use `.limit(10000)` on your DataFrame for faster iteration
- **Version your experiments:** Increment `VERSION_NUM` for each major change
- **Document as you go:** Update feature descriptions in the Feature Store
- **Compare incrementally:** Add one feature at a time and measure impact
- **Monitor from day one:** Set up Model Monitors even for experimental models

---

## 🆘 Getting Help

If you're stuck:

1. Check the error message carefully - it often tells you exactly what's wrong
2. Use `df.printSchema()` to see your DataFrame structure
3. Test each transformation individually before combining
4. Consult [Snowflake ML documentation](https://docs.snowflake.com/en/developer-guide/snowpark-ml/index)
5. Search [Snowflake Community](https://community.snowflake.com/)

---

**Good luck with your customization!** 🚀

