from flask import Flask
from TMDBAPI import TMDBAPI
from database import Database
import json
import logging

app = Flask(__name__)
api = TMDBAPI()
db = Database()

logger = logging.getLogger('werkzeug')
handler = logging.FileHandler('server.log')
logger.addHandler(handler)

@app.route('/users/register/<username>/<passwordHash>')
def register(username, passwordHash):
    result = db.register_user(username, passwordHash)
    if result:
        response = {"login": username, "passwordHash": passwordHash}
        logger.info(f"User {username} registered")
        return response
    else:
        response = {"login": "", "passwordHash": ""}
        logger.info(f"User {username} failed registration")
        return response

@app.route('/users/login/<username>/<passwordHash>')
def login(username, passwordHash):
    user = db.check_user(username, passwordHash)
    if user:
        logger.info(f"User {username} logged in")
        response = {"login": username, "passwordHash": passwordHash}
        return response
    else:
        response = {"login": "", "passwordHash": ""}
        logger.info(f"User {username} failed login")
        return response

@app.route('/users/change_password/<username>/<oldPasswordHash>/<newPasswordHash>')
def change_password(username, oldPasswordHash, newPasswordHash):
    result = db.change_password(username, oldPasswordHash, newPasswordHash)
    if result:
        response = {"login": username, "passwordHash": newPasswordHash}
        logger.info(f"User {username} changed password")
        return response
    else:
        response = {"login": "", "passwordHash": ""}
        logger.info(f"User {username} failed to change password")
        return response

@app.route('/users/change_username/<oldUsername>/<newUsername>/<passwordHash>')
def change_username(oldUsername, newUsername, passwordHash):
    result = db.change_username(oldUsername, newUsername, passwordHash)
    if result:
        response = {"login": newUsername, "passwordHash": passwordHash}
        logger.info(f"User {oldUsername} changed username to {newUsername}")
        return response
    else:
        response = {"login": "", "passwordHash": ""}
        logger.info(f"User {oldUsername} failed to change username to {newUsername}")
        return response

@app.route('/get/<title>')
def get(title):
    res = db.get_film_by_title(title)
    if res:
        logger.info(str(res))
        return res
    else:
        film = api.search_by_title(title)
        db.add_film(film)
        return film

@app.route('/search/<title>')
def search(title):
    res = api.search_by_title(title)
    logger.info("seached films: ")
    for film in res:
        db.add_film(film)
        logger.info(str(film))
    
    return json.dumps(res, default=lambda o: o.__dict__)

@app.route('/review/<username>/<filmTitle>/<reviewText>/<reviewValue>')
def review(username, filmTitle, reviewText, reviewValue):
    film = db.get_film_by_title(filmTitle)
    if film:
        db.add_review(username, film['id'], reviewText, reviewValue)
        logger.info(f"User {username} reviewed {filmTitle} with {reviewValue} stars and the text: {reviewText}")
        return json.dumps(film, default=lambda o: o.__dict__)
    else:
        logger.info(f"User {username} failed to review {filmTitle} with {reviewValue} stars and the text: {reviewText}")
        return json.dumps({'error': 'Film not found'}, default=lambda o: o.__dict__)

@app.route('/get_reviews/<username>')
def get_reviews(username):
    logger.info(f"Getting reviews for {username}")
    return json.dumps(db.get_user_reviews(username), default=lambda o: o.__dict__)

@app.route('/get_similar/<filmTitle>') 
def get_similar(filmTitle):
    film = db.get_film_by_title(filmTitle)
    if film:
        res = api.get_simmilar_films(film['id'])
        logger.info(f"Getting similar films to {filmTitle}")
        return json.dumps(res, default=lambda o: o.__dict__)
    else:
        logger.info(f"Failed to get similar films to {filmTitle}")
        return json.dumps({'error': 'Film not found'}, default=lambda o: o.__dict__)

if __name__ == '__main__':
    app.run(port=8080, host="79.137.203.25")