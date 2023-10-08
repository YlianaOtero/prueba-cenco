from flask import Flask, jsonify

app = Flask(__name__)

message = "Hello Cencommerce!"

@app.route("/")
def greetings():
    jsonMessage = jsonify(message)

    return jsonMessage

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0')
