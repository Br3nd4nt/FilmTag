from os import environ
import requests
import json
from film import Film

class TMDBAPI:
    def __init__(self):
        self.apiKey = environ.get('TMDBAPIKey')

    def search_by_title(self, title, count=10):
        url = "https://api.themoviedb.org/3/search/movie?include_adult=false&&language=en-US&page=1&query=" + title + "&api_key=" + self.apiKey
        response = requests.get(url).json()
        count = min(count, response['total_results'])
        resluts = []
        for i in range(count):
            id = response['results'][i]['id']
            poster_path = "https://image.tmdb.org/t/p/original" + response['results'][i]['poster_path']
            f = Film(response['results'][i]['title'], id, response['results'][i]['overview'], poster_path)
            resluts.append(f)
        return resluts
        



if __name__ == '__main__':
    api = TMDBAPI()
    # print(api.search_by_title("The Dark Knight"))
    res = api.search_by_title("The Dark Knight")
    #convert to json
    res = json.dumps(res, default=lambda o: o.__dict__)
    print(res)

