import sqlite3
from film import Film
from review import Review

class Database():
    def __init__(self) -> None:
        self.create_tables()
            
    def create_tables(self):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY,
                login TEXT,
                hashedPassword TEXT
            )
        ''')

        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS films (
                id INTEGER PRIMARY KEY,
                title TEXT,
                apiId INTEGER,
                description TEXT,
                posterUrl TEXT,
                reviewAverage REAL
            )
        ''')

        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS reviews (
                id INTEGER PRIMARY KEY,
                userId INTEGER,
                filmId INTEGER,
                starsCount REAL,
                reviewText TEXT,
                FOREIGN KEY (userId) REFERENCES users(id),
                FOREIGN KEY (filmId) REFERENCES films(id)
            )
        ''')

        self.conn.commit()
        self.conn.close()
    
    def register_user(self, login, hashedPassword):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        #check if user with login exists
        self.cursor.execute('''
            SELECT * FROM users WHERE login = ?
        ''', (login,))
        user = self.cursor.fetchone()
        if user:
            return False
        self.cursor.execute('''
            INSERT INTO users (login, hashedPassword) VALUES (?, ?)
        ''', (login, hashedPassword))
        self.conn.commit()
        self.conn.close()
        return True

    def check_user(self, login, hashedPassword):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            SELECT * FROM users WHERE login = ? AND hashedPassword = ?
        ''', (login, hashedPassword))
        user = self.cursor.fetchone()
        self.conn.close()
        return user


    def get_film_by_title(self, title):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            SELECT * FROM films WHERE title = ?
        ''', (title,))
        film = self.cursor.fetchone()
        print(film)
        self.conn.close()
        return self._film_response_to_json(film) if film else None
    
    def add_film(self, film: Film):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            SELECT * FROM films WHERE apiId = ?
        ''', (film.api_id,))
        if self.cursor.fetchone():
            return 
        self.cursor.execute('''
            INSERT INTO films (title, apiId, description, posterUrl, reviewAverage) VALUES (?, ?, ?, ?, ?)
        ''', (film.title, film.api_id, film.overview, film.poster_path, film.review_average))
        self.conn.commit()
        self.conn.close()
    
    def _film_response_to_json(self, response):
        return {
            "id": response[0],
            "title": response[1],
            "apiId": response[2],
            "description": response[3],
            "posterUrl": response[4],
            "reviewAverage": response[5]
        }

    def add_review(self, username, filmId, reviewText, reviewValue):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            SELECT id FROM users WHERE login = ?
        ''', (username,))
        userId = self.cursor.fetchone()[0]
        self.cursor.execute('''
            INSERT INTO reviews (userId, filmId, starsCount, reviewText) VALUES (?, ?, ?, ?)
        ''', (userId, filmId, reviewValue, reviewText))
        self.conn.commit()
        self.conn.close()
        return True
    
    def get_reviews(self, filmId):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            SELECT * FROM reviews WHERE filmId = ?
        ''', (filmId,))
        reviews = self.cursor.fetchall()
        self.conn.close()
        return reviews
    
    def get_user_reviews(self, username):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            SELECT id FROM users WHERE login = ?
        ''', (username,))
        userId = self.cursor.fetchone()[0]
        self.cursor.execute('''
            SELECT * FROM reviews WHERE userId = ?
        ''', (userId,))
        reviews = self.cursor.fetchall()
        self.conn.close()
        #convert to reviews class type
        print(reviews)
        res = []
        for review in reviews:
            film = self.get_film_by_id(review[2])
            res.append(Review(username, film['title'], review[3], review[4], film['posterUrl']))
        res = [r.to_json() for r in res]
        print(res)
        return res
    
    def get_film_by_id(self, id):
        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            SELECT * FROM films WHERE id = ?
        ''', (id,))
        film = self.cursor.fetchone()
        self.conn.close()
        return self._film_response_to_json(film) if film else None

    def get_film_reviews(self, title):
        film = self.get_film_by_title(title)
        if film:
            return self.get_reviews(film['id'])
        return None
    