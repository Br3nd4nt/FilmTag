import sqlite3

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
                description TEXT,
                posterUrl TEXT
            )
        ''')

        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS reviews (
                id INTEGER PRIMARY KEY,
                userId INTEGER,
                filmId INTEGER,
                starsCount INTEGER,
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
    
    def add_film(self, film_json):
        

        self.conn = sqlite3.connect('database.db')
        self.cursor = self.conn.cursor()
        self.cursor.execute('''
            INSERT INTO films (title, description, posterUrl) VALUES (?, ?, ?)
        ''', (film_json['Title'], film_json['Plot'], film_json['Poster']))
        self.conn.commit()
        self.conn.close()
    
    def _film_response_to_json(self, response):
        return {
            'id': response[0],
            'title': response[1],
            'description': response[2],
            'posterUrl': response[3]
        }

if __name__ == '__main__':
    db = Database()
    print(db.get_film_by_title('The Matrix'))
