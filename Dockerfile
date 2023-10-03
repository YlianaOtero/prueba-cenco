FROM python:3.8-slim

WORKDIR /hello-app

COPY dependencies.txt .

RUN pip install --no-cache-dir -r dependencies.txt

COPY . .

EXPOSE 5000

CMD ["python", "greetings.py"]