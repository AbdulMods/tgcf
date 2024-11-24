FROM python:3.10-slim

# Environment variables
ENV VENV_PATH="/venv"
ENV PATH="$VENV_PATH/bin:$PATH"

# Set working directory
WORKDIR /app

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils ffmpeg tesseract-ocr && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --upgrade poetry

# Set up Python virtual environment
RUN python -m venv $VENV_PATH

# Copy application files
COPY . .

# Build and install the app
RUN poetry build && \
    $VENV_PATH/bin/pip install --upgrade pip wheel setuptools && \
    $VENV_PATH/bin/pip install dist/*.whl

# Expose port
EXPOSE 8501

# Start the application
CMD ["tgcf-web"]
