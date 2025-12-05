Norfolk Dog Adoption Analysis

A Statistical Examination of Intake, Outcome, and Adoption Dynamics at the Norfolk Animal Care & Adoption Center*

---

Overview

This project presents a quantitative analysis of dog intake and adoption outcomes at the **Norfolk Animal Care & Adoption Center (NACC)** using a dataset of ~17,000 records.
The objective is to understand temporal patterns in shelter operations, evaluate adoption performance metrics, and identify demographic and behavioral factors that influence outcomes.

All analysis was conducted using SAS, leveraging data-cleaning procedures, date-time manipulation, PROC SQL aggregation, and statistical visualization techniques.

This project situates animal shelter operations within a data-driven decision-making framework, demonstrating how statistical analysis can inform real-world policy, resource allocation, and operational planning 
---

Research Aims

This analysis addresses four guiding research questions:

1. How do monthly intake and adoption patterns fluctuate over time?
2. What is the distribution of length of stay (LOS), and how does it vary by month and outcome type?
3. To what extent does age influence adoption likelihood?
4. Can adoption rate (adoption ÷ intake) serve as a reliable performance metric for shelter operations?

Each question is investigated through summary statistics, temporal aggregations, and visual analyses.

---

Repository Structure

```
norfolk-dog-adoption-analysis/
│
├── norfolk_dog_project.sas        # Full SAS analysis script
├── Norfolk_Animal_Care_and_Adoption_Center__NACC_.csv   # Raw dataset
├── plots/                         # Exported graphs (recommended)
│   ├── adoption_rate_over_time.png
│   ├── intakes_vs_adoptions.png
│   ├── avg_los_by_month.png
│   ├── los_distribution.png
│   └── adoption_rate_by_age.png
└── README.md
```

---

Dataset Description

The dataset was sourced from the Norfolk Animal Care & Adoption Center (NACC) and consists of approximately 17,000 observations of animal intake and outcome records.
Variables include:

* Demographic attributes: breed, color, sex, age (years & months)
* Operational attributes: intake date, intake type, outcome date, outcome type
* Derived attributes: length of stay (LOS), adoption indicator, age in years
* Temporal attributes: intake and outcome day of the week

This study focuses exclusively on dogs, isolating and analyzing canine-specific dynamics within the shelter system.

---

Methodology

1. Data Preparation

Using SAS, the dataset was prepared through:

* Filtering to include only dogs
* Parsing numeric SAS date formats
* Constructing length of stay as:
 LOS = Outcome Date - Income Date
* Deriving age in years from year/month fields
* Creating binary adoption indicators
* Defining categorical age groups (puppy, young, adult, senior)

2. Monthly Aggregation Using PROC SQL

Monthly operational statistics were computed:

* Total intakes
* Total adoptions
* Average LOS
* Adoption rate:
  Adoption Rate = Adoptions/Intakes

3. Visualization Techniques

Plots were generated using PROC SGPLOT to illustrate:

* Time-series adoption rates
* Intakes vs adoptions
* Length of stay trends
* Age distributions
* Adoption probability across age groups

These visualizations highlight patterns relevant to both operational decision-makers and policy analysts.

---

Key Findings

1. Monthly Adoption Trends

Adoption and intake patterns show clear temporal structure, suggesting a seasonal component to shelter demand and adoption success.

2. Length of Stay Variability

Length of stay exhibits high variance, indicating heterogeneous intake categories and outcome pathways.
Senior dogs and dogs with medical or behavioral designations experienced longer stays.

3. Age as a Predictor of Adoption

Age group analysis reveals:

* Puppies (<1 year): highest adoption probability
* Young dogs (1–3): consistently high adoption rate
* Adult dogs (3–7): moderate adoption rate
* Senior dogs (7+): lowest adoption rate, highest LOS

This suggests age is a strong predictor of outcome type and waiting time.

4. Adoption Rate as a Performance Metric

Adoption rate proves to be a meaningful operational measure, capturing both demand-side (adopter interest) and supply-side (intake volume) variation.
Shelters can leverage this metric for staffing, funding allocation, and program evaluation.

---

Key Visualizations:

- Monthly Intakes vs Adoptions
- Length of Stay Distribution
- Age Distribution of Dogs
- Adoption Rate by Age Group

---

Relevance to Academic Work

This project demonstrates the application of statistical reasoning, data cleaning, aggregation logic, and visualization in a real-world municipal dataset.

It aligns strongly with:

* Quantitative work in social systems
* Applied data research in public policy and community welfare

The project illustrates the ability to:

* Handle complex real-world data
* Apply statistical techniques to practical problems
* Communicate results clearly and academically
* Integrate computational tools with domain knowledge

---

Author

Katherine Len
- Statistics Major — Florida State University
- Data Analytics Minor
- Volunteer at local animal rescue organizations
- Interests: applied statistics, data science, computational social science, animal welfare analytics

