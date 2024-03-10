from flask import Flask
from TMDBAPI import TMDBAPI
from database import Database
import json

app = Flask(__name__)
api = TMDBAPI()
db = Database()

@app.route('/')
def hello():
    return 'Hello, World!'

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

@app.route('/get/<title>')
def get(title):
    res = db.get_film_by_title(title)
    if res:
        return res
    else:
        film = api.search_by_title(title)
        db.add_film(film)
        return film

@app.route('/search/<title>')
def search(title):
    res = api.search_by_title(title)
    #add films to database
    for film in res:
        db.add_film(film)
    return json.dumps(res, default=lambda o: o.__dict__)

@app.route('/review/<username>/<filmTitle>/<reviewText>/<reviewValue>')
def review(username, filmTitle, reviewText, reviewValue):
    film = db.get_film_by_title(filmTitle)
    if film:
        db.add_review(username, film['id'], reviewText, reviewValue)
        return json.dumps(film, default=lambda o: o.__dict__)
    else:
        return json.dumps({'error': 'Film not found'}, default=lambda o: o.__dict__)

@app.route('/get_reviews/<username>')
def get_reviews(username):
    return json.dumps(db.get_user_reviews(username), default=lambda o: o.__dict__)

if __name__ == '__main__':
    app.run(port=8080, host="192.168.1.9")