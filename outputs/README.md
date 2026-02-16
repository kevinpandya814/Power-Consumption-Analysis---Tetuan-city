# Outputs — Analytical Results & Business Insights

This folder contains the key analytical outputs from the power consumption study.  
The analysis evaluates how environmental factors (temperature, humidity, wind speed) influence demand across Zones 1, 2, and 3 during winter months.

---

## 1. Correlation Analysis  
**File:** `correlation_plot.png`
Assess relationships between environmental variables and power consumption before formal modeling.
### Insight
Temperature shows a strong positive association with consumption across zones, while humidity and wind speed demonstrate negative relationships during winter periods.

This step supports model design and reduces reliance on assumption-driven analysis.

---

## 2. Distribution & Density Analysis  
**File:** `data_distribution.png`
Understand consumption behavior and variability across zones.
### Analyst Insight
Zones exhibit different levels of dispersion, indicating varying demand stability. Higher variability may signal operational sensitivity or infrastructure strain.

This analysis supports data quality validation and regression assumption checks.

---

## 3. Regression Modeling — Zone-Level Analysis  
**Files:**  
- `regression_zone_1.png`  
- `regression_zone_2.png`  
- `regression_zone_3.png`
Quantify the impact of environmental variables on power consumption using multiple linear regression.
### Model Inputs
- Wind Speed
- Humidity
- Temperature

### Insights
- Temperature is a strong, statistically significant driver of consumption.
- Wind speed and humidity show consistent negative effects.
- Zone 2 exhibits slightly higher explanatory strength, suggesting greater sensitivity to environmental conditions.
- Residual diagnostics confirm acceptable model behavior with minor tail deviations.

---

## Key Takeaways

- Environmental factors materially influence power demand.
- Winter seasonality significantly increases consumption levels.
- Certain zones demonstrate higher variability, making them candidates for enhanced monitoring.
- Statistical validation replaces assumption-based planning with measurable insights.

---

For full methodology and stakeholder narrative, refer to:
- `docs/Milestone_Project.pdf`