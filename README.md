# Amazon LMAQ Maps - Last Mile Analytics

This project simulates the role of a Business Analyst on Amazon’s Last Mile Analytics & Quality (LMAQ) Maps Team.
It showcases how Python is used for ETL, data analysis, predictive modeling, and dashboard prep to enhance driver
experience and optimize delivery logistics.

## 🔧 Features
- Process and clean large-scale navigation and routing datasets
- Perform data validation and quality checks
- Predict delivery success/failures
- Visualize delivery KPIs
- Containerized for AWS batch or Lambda deployments

## 📂 Structure
- `notebooks/` - Main analysis notebook
- `src/etl.py` - ETL pipeline for S3/Redshift
- `src/model.py` - ML model for delay prediction
- `src/viz.py` - Visualization helper scripts
- `Dockerfile` - Run everything in a container

## 🚀 Usage
```bash
# Install dependencies
pip install -r requirements.txt

# Run ETL
python src/etl.py

# Train model
python src/model.py

# Visualize
python src/viz.py
```

## 📊 Notebook Preview
Check out the main Jupyter notebook for interactive analysis in `notebooks/lmaq_analysis.ipynb`

## 🐳 Docker
Build and run:
```bash
docker build -t lmaq-analysis .
docker run -it lmaq-analysis
```

## 📘 License
MIT
"""
