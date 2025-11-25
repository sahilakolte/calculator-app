FROM python:3.12-slim

WORKDIR /app

# Copy only your calculator file
COPY calc.py .

RUN pip install pytest

CMD ["python", "calc.py"]
