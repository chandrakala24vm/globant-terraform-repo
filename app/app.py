# app/main.py
from flask import Flask, jsonify

app = Flask(_name_)

@app.route("/")
def health_check():
    return jsonify({"status": "UP"}), 200

@app.route("/hello")
def hello():
    return jsonify({"message": "Hello from a production-grade Docker image!"})

if _name_ == "_main_":
    app.run(host="0.0.0.0", port=5000)