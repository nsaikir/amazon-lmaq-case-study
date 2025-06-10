FROM python:3.10

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root"]
