FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Install system deps required by some python packages (keep minimal)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app

# Install python deps
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Make scripts executable
RUN chmod +x /app/scripts/start_raft_nodes.sh

# Default command is overridden by docker-compose for each service
CMD ["sleep", "infinity"]