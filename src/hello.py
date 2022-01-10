from flask import Flask
import flask
app = Flask(__name__)

@app.route('/')
def hello():
    return flask.jsonify({'message': 'Hello, World!'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')