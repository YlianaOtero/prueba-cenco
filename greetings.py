from flask import Flask, jsonify

app = Flask(__name__)

message = "Hello Cencommerce!"

@app.route("/")
def greetings():
    jsonMessage = jsonify(message)

    return jsonMessage
