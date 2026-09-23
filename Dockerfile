FROM python:3.11-alpine3.24

WORKDIR /usr/local/app

# Create non-root user
RUN adduser -S -D appuser

# Install dependencies
COPY requirements.txt .

RUN python -m pip install --no-cache-dir --upgrade setuptools wheel && \
    python -m pip install --no-cache-dir -r requirements.txt

# Copy application files with correct ownership
COPY --chown=appuser:appuser . .

# Run as non-root
USER appuser

EXPOSE 8080

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8080", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]
