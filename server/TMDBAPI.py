from os import environ
import requests
from film import Film

class TMDBAPI:
    def __init__(self):
        self.apiKey = environ.get('TMDBAPIKey')

    def search_by_title(self, title, count=10):
        url = ("https://api.themoviedb.org/3/search/movie?include_adult=false&&language=en-US&page=1&query=" + title + "&api_key=" + self.apiKey).replace(" ", "%20")
        response = requests.get(url).json()['results']
        results = []
        i = 0
        while i < len(response) and len(results) < count:
            id = response[i]['id']
            try:
                poster_path = "https://image.tmdb.org/t/p/original" + response[i]['poster_path']
            except TypeError:
                i += 1
                continue
            f = Film(response[i]['title'], id, response[i]['overview'], poster_path)
            results.append(f)
            i += 1
        return results
        
    def get_simmilar_films(self, film_id, count=10):


        url = f"https://api.themoviedb.org/3/movie/{film_id}/recommendations?api_key={self.apiKey}"
        response = requests.get(url).json()['results']
        results = []
        i = 0
        while i < len(response) and len(results) < count:
            id = response[i]['id']
            try:
                poster_path = "https://image.tmdb.org/t/p/original" + response[i]['poster_path']
            except TypeError:
                i += 1
                continue
            f = Film(response[i]['title'], id, response[i]['overview'], poster_path)
            results.append(f)
            i += 1
        return results



if __name__ == '__main__':
    api = TMDBAPI()
    id = api.search_by_title(input())
    print(len(id))
