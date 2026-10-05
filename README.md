# TravelTide Reward Program Analysis

## Project Description

TravelTide is an online travel company aiming to improve customer retention through a personalized rewards program.

This project analyzes customer search, booking and travel behavior to identify meaningful customer segments. Based on these segments, suitable rewards and personalized communication strategies are recommended.

## Project Summary

The analysis covers 5,752 customers with more than seven sessions since January 4, 2023. Customer-level features were developed from user, session, flight and hotel data.

A hybrid segmentation approach was applied:

1. customers with clearly interpretable behavioral patterns were assigned to rule-based segments,
2. the remaining customers were segmented using K-Means,
3. DBSCAN was evaluated as an alternative clustering method,
4. PCA was used to examine and visualize the resulting cluster structure.

### Key Points and Insights

- Ten final customer segments were identified.
- 2,935 customers were assigned through behavioral rules.
- 2,817 customers were assigned through K-Means clustering.
- The largest segment is `Regular Package Travelers`, representing approximately 28% of all customers.
- Discount usage, package-booking behavior, baggage usage, hotel-stay duration, cancellations and historical customer value were important characteristics for differentiating customer groups.
- DBSCAN was examined but was not selected for the final segmentation because it did not produce sufficiently useful and interpretable customer groups.
- Each segment received a primary recommended perk and an alternative test variant.
- Segment-specific communication messages, calls-to-action, success KPIs and cost or risk guardrails were developed.
- The recommendations are behavioral hypotheses and should be validated through randomized campaign tests.

### Final Customer Segments

- Regular Package Travelers
- Discount-Responsive Travelers
- Baggage-Intensive Flyers
- Low-Conversion Browsers
- Long-Stay Hotel Guests
- Hotel Deal Travelers
- Cancellation-Experienced Travelers
- Flight Deal Travelers
- High-Value Bookers
- Family & Group Travelers

### Recommendations

TravelTide should use the customer segments as the basis for personalized rewards communication. Perks should not be rolled out permanently without testing their incremental impact.

A randomized campaign design is recommended, comparing:

- a control group without an additional perk,
- a group receiving the recommended primary perk,
- a group receiving an alternative test perk.

Booking conversion, repeat bookings, additional revenue and perk redemption should be measured together with perk costs, contribution margins and cancellation behavior.

## Links to Files

- [Data Preparation](notebooks/01_data_preparation.ipynb)
- [Exploratory Data Analysis](notebooks/02_exploratory_data_analysis.ipynb)
- [Customer Segmentation](notebooks/03_customer_segmentation.ipynb)
- [Perk Assignment](notebooks/04_perk_assignment.ipynb)
- [Executive Summary](LINK-TO-BE-ADDED)
- [Presentation](LINK-TO-BE-ADDED)

## Installation

Clone the repository and install the required dependencies:

```bash
git clone https://github.com/norawinkler/traveltide-customer-segmentation.git
cd traveltide-customer-segmentation
pip install -r requirements.txt
```

## Dependencies
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- Jupyter Notebook
- SQL
- Visual Studio Code

## Data

The project uses four relational datasets containing:
- customer information,
- browsing sessions,
- flight bookings,
- hotel bookings.

The selected cohort consists of users with more than seven sessions since January 4, 2023.

The raw and customer-level data may not be included in the public repository because they contain individual-level records. The notebooks document all relevant preparation and analysis steps.

## Limitations

- The analysis is based on historical customer behavior.
- The perk recommendations do not demonstrate causal effects.
- Customer acquisition costs were not available.
- Historical customer value should not be interpreted as predicted customer lifetime value.
- Complete information about the actual costs of individual perks was not available.
- The final recommendations require validation through controlled campaign experiments.

## Author

Nora Winkler