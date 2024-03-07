from flask import Flask
from OMDbAPI import OMDbAPI
from database import Database
import json
app = Flask(__name__)
api = OMDbAPI()
db = Database()

@app.route('/')
def hello():
    return 'Hello, World!'

@app.route('/search/<title>')
def search(title):
    res = db.get_film_by_title(title)
    if res:
        return res
    else:
        film = api.search_by_title(title)
        db.add_film(film)
        return film

@app.route('/users/register/<username>/<passwordHash>')
def register(username, passwordHash):
    result = db.register_user(username, passwordHash)
    print(result)
    if result:
        # return json value of user login and passwordHash
        response = {"login": username, "passwordHash": passwordHash}
        print(response)
        return response
    else:
        response = {"login": "", "passwordHash": ""}
        print(response)
        return response

@app.route('/users/login/<username>/<passwordHash>')
def login(username, passwordHash):
    user = db.check_user(username, passwordHash)
    if user:
        # return json value of user login and passwordHash
        response = {"login": username, "passwordHash": passwordHash}
        print(response)
        return response
    else:
        response = {"login": "", "passwordHash": ""}
        print(response)
        return response


if __name__ == '__main__':
    app.run(port=8080, host="192.168.1.9")