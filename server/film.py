class Film:
    def __init__(self, title, id, overview, poster_path):
        self.title = title
        self.api_id = id
        self.overview = overview
        self.poster_path = poster_path
        self.review_average = 0

    def __str__(self):
        return f"{self.title} - {self.overview} - {self.poster_path} - {self.review_average}"