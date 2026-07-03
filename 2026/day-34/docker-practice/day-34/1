from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return {
            "message": "Hello from Docker Compose Day 34 - Rebuilt Successfully ",
            "status": "running"
            }
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
