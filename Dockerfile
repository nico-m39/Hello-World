FROM python:3.12-slim
 
WORKDIR /app
 
COPY requirements.txt .
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r requirements.txt
 
COPY app.py .
 
EXPOSE 8000
 
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1
 
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]