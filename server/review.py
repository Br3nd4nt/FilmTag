class Review:
    def __init__(self, username: str, film_title: str, stars: float, text: str, poster_path: str):
        self.username = username
        self.title = film_title
        self.stars = stars
        self.text = text
        self.poster_path = poster_path

    def to_json(self):
        return {
            "username": self.username,
            "title": self.title,
            "stars": self.stars,
            "text": self.text,
            "poster_path": self.poster_path
        }
