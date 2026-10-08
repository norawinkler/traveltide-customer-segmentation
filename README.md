# TravelTide Reward Program Analysis

## Project Description

TravelTide is an online travel company aiming to improve customer retention through a personalized rewards program.

This project analyzes customer search, booking, and travel behavior to identify meaningful customer segments. Based on these segments, suitable rewards, personalized communication strategies, and an experimental validation plan are recommended.

## Project Summary

The final analysis covers 5,752 adult customers from a cohort of users with more than seven sessions since January 4, 2023. Customer-level features were developed from user, session, flight, and hotel data.

A hybrid segmentation approach was applied:

1. customers with clearly interpretable behavioral patterns were assigned to rule-based segments,
2. the remaining customers were segmented using K-Means,
3. DBSCAN was evaluated as an alternative clustering method,
4. PCA was used to examine and visualize the resulting cluster structure.

### Key Points and Insights

- Twelve final customer segments were identified.
- 2,935 customers were assigned through behavioral rules.
- 2,817 customers were assigned through K-Means clustering.
- Discount usage, booking conversion, package-booking behavior, baggage usage, hotel-stay duration, cancellations, travel-party size, flexibility, and historical customer value were important characteristics for differentiating customer groups.
- DBSCAN was examined but was not selected for the final segmentation because it did not produce sufficiently useful and interpretable customer groups.
- Nine operational perk families were developed and assigned to the segments with segment-specific configurations.
- Each segment received a primary recommended perk and an alternative test variant.
- Segment-specific communication messages, calls-to-action, success KPIs, and cost or risk guardrails were developed.
- The recommendations are behavioral hypotheses and should be validated through randomized campaign tests.

### Final Customer Segments

- Family Travelers
- Long-Stay Hotel Guests
- Baggage-Intensive Flyers
- Discount-Responsive Travelers
- Cancellation-Experienced Travelers
- High-Value Bookers
- Low-Conversion Browsers
- Extended-Stay Hotel Guests
- Multi-Person Travelers
- Flexible One-Way Flyers
- Active Longer-Stay Hotel Guests
- Premium Short-Stay Package Travelers

### Recommended Perk Families

- Family Travel Credit
- Group Booking Credit
- Free Additional Checked Bag
- Complimentary Flight Rebooking
- Flexible Cancellation Protection
- Personalized Travel Discount
- First Booking Credit
- Long-Stay Benefit
- Premium Travel Upgrade

### Recommendations

TravelTide should use the customer segments as the basis for personalized rewards communication. The perk families should be configured differently depending on the needs of each segment and should not be rolled out permanently without testing their incremental impact.

A randomized campaign design is recommended, comparing:

- a control group without an additional perk,
- a group receiving the recommended primary perk,
- a group receiving an alternative test perk.

Booking conversion, repeat bookings, additional revenue, and perk redemption should be measured together with perk costs, contribution margins, and cancellation behavior.

## Links to Files

- [Data Preparation](notebooks/01_data_preparation.ipynb)
- [Exploratory Data Analysis](notebooks/02_exploratory_data_analysis.ipynb)
- [Customer Segmentation](notebooks/03_customer_segmentation.ipynb)
- [Perk Assignment](notebooks/04_perk_assignment.ipynb)
- [Presentation](presentation\Travel-Tide-Mastery-Project.pdf)

## Repository Structure

```text
traveltide-customer-segmentation/
├── data/
│   ├── raw/          # Locally extracted source data; not tracked by Git
│   ├── processed/    # Intermediate outputs; not tracked by Git
│   └── finalized/    # Final analytical tables; not tracked by Git
├── notebooks/
│   ├── 01_data_preparation.ipynb
│   ├── 02_exploratory_data_analysis.ipynb
│   ├── 03_customer_segmentation.ipynb
│   └── 04_perk_assignment.ipynb
├── requirements.txt
└── README.md
```

## Installation

Clone the repository and install the required dependencies:

```bash
git clone https://github.com/norawinkler/traveltide-customer-segmentation.git
cd traveltide-customer-segmentation
python -m venv .venv
```

Activate the virtual environment:

```bash
# Windows PowerShell
.venv\Scripts\Activate.ps1

# macOS or Linux
source .venv/bin/activate
```

Install the dependencies:

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

## Data Access and Security

The source data is stored in a PostgreSQL database hosted by Neon. The database endpoint is:

```text
ep-noisy-flower-846766.us-east-2.aws.neon.tech
```

The database name is:

```text
TravelTide
```

Use the following connection-string format:

```text
postgresql://<USERNAME>:<PASSWORD>@ep-noisy-flower-846766.us-east-2.aws.neon.tech/TravelTide?sslmode=require
```

Database credentials are intentionally not included in this public repository. Obtain authorized credentials from the project or course administrator and store the full connection string locally, for example as an environment variable:

```bash
# Windows PowerShell
$env:TRAVELTIDE_DATABASE_URL = "postgresql://<USERNAME>:<PASSWORD>@ep-noisy-flower-846766.us-east-2.aws.neon.tech/TravelTide?sslmode=require"

# macOS or Linux
export TRAVELTIDE_DATABASE_URL="postgresql://<USERNAME>:<PASSWORD>@ep-noisy-flower-846766.us-east-2.aws.neon.tech/TravelTide?sslmode=require"
```

Do not commit credentials, `.env` files, or database exports to GitHub.

## Reproducing the Analysis

### 1. Create the local data directories

From the repository root, create the directories expected by the notebooks:

```bash
mkdir -p data/raw data/processed data/finalized
```

On Windows, these folders can also be created manually in Visual Studio Code.

### 2. Connect to the TravelTide database

Connect to PostgreSQL using an SQL client such as Beekeeper Studio, DBeaver, or `psql`. Use the authorized connection string described above.

The analytical cohort consists of users with more than seven distinct sessions on or after January 4, 2023. Run the following queries and export each result as a CSV file with the exact filename shown.

#### `data/raw/users.csv`

```sql
WITH cohort_users AS (
    SELECT user_id
    FROM sessions
    WHERE session_start >= DATE '2023-01-04'
    GROUP BY user_id
    HAVING COUNT(DISTINCT session_id) > 7
)
SELECT u.*
FROM users AS u
INNER JOIN cohort_users AS c
    ON u.user_id = c.user_id;
```

#### `data/raw/sessions.csv`

```sql
WITH cohort_users AS (
    SELECT user_id
    FROM sessions
    WHERE session_start >= DATE '2023-01-04'
    GROUP BY user_id
    HAVING COUNT(DISTINCT session_id) > 7
)
SELECT s.*
FROM sessions AS s
INNER JOIN cohort_users AS c
    ON s.user_id = c.user_id
WHERE s.session_start >= DATE '2023-01-04';
```

#### `data/raw/flights.csv`

```sql
WITH cohort_users AS (
    SELECT user_id
    FROM sessions
    WHERE session_start >= DATE '2023-01-04'
    GROUP BY user_id
    HAVING COUNT(DISTINCT session_id) > 7
),
cohort_trips AS (
    SELECT DISTINCT s.trip_id
    FROM sessions AS s
    INNER JOIN cohort_users AS c
        ON s.user_id = c.user_id
    WHERE s.session_start >= DATE '2023-01-04'
      AND s.trip_id IS NOT NULL
)
SELECT f.*
FROM flights AS f
INNER JOIN cohort_trips AS t
    ON f.trip_id = t.trip_id;
```

#### `data/raw/hotels.csv`

```sql
WITH cohort_users AS (
    SELECT user_id
    FROM sessions
    WHERE session_start >= DATE '2023-01-04'
    GROUP BY user_id
    HAVING COUNT(DISTINCT session_id) > 7
),
cohort_trips AS (
    SELECT DISTINCT s.trip_id
    FROM sessions AS s
    INNER JOIN cohort_users AS c
        ON s.user_id = c.user_id
    WHERE s.session_start >= DATE '2023-01-04'
      AND s.trip_id IS NOT NULL
)
SELECT h.*
FROM hotels AS h
INNER JOIN cohort_trips AS t
    ON h.trip_id = t.trip_id;
```

When exporting the query results, keep the column headers and save the files as UTF-8 CSV files. The first notebook performs the adult-customer filter and all subsequent cleaning and feature-engineering steps.

### 3. Run the notebooks in order

Open the repository in Visual Studio Code or start Jupyter Notebook, select the project virtual environment as the kernel, and run all cells in the following order:

1. `notebooks/01_data_preparation.ipynb`
2. `notebooks/02_exploratory_data_analysis.ipynb`
3. `notebooks/03_customer_segmentation.ipynb`
4. `notebooks/04_perk_assignment.ipynb`

The notebooks use relative paths. Preserve the repository structure shown above and do not rename the generated files between notebook runs.

### 4. Expected outputs

The notebooks create the cleaned detail tables, customer-level feature tables, final segment assignments, perk recommendations, communication strategies, and test-plan outputs required by the following notebooks. All generated CSV files remain local and are excluded from the public repository.

After successful execution, the final analysis should contain:

- 5,752 adult customers,
- twelve final customer segments,
- one primary perk recommendation per customer,
- one alternative test perk per customer,
- segment-specific communication and success-measurement fields.

## Notebook Language

The README and repository documentation are written in English. The notebook headings, explanations, and code comments are written in German because the analysis was completed as part of a German-language training program. Python variable names and the underlying analytical workflow remain interpretable independently of the documentation language.

## Dependencies

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- Jupyter Notebook
- PostgreSQL-compatible SQL client
- Visual Studio Code or another Jupyter environment

## Data Policy

Raw data, intermediate CSV files, and final customer-level exports are not included in this repository. They contain individual-level records and can be reproduced from the authorized source database by following the instructions above.

The repository should exclude at least the following paths and file types through `.gitignore`:

```gitignore
.env
.venv/
data/raw/
data/processed/
data/finalized/
*.csv
```

## Limitations

- The analysis is based on historical customer behavior.
- The perk recommendations do not demonstrate causal effects.
- Customer acquisition costs were not available.
- Historical customer value should not be interpreted as predicted customer lifetime value.
- Complete information about contribution margins and the actual costs of individual perks was not available.
- The final recommendations require validation through controlled campaign experiments.

## Author

Nora Winkler
