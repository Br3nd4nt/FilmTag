from os import environ
import requests
import json

class OMDbAPI:
    def __init__(self):
        self.apiKey = environ.get('OMDbAPIKey')

    def search_by_title(self, title):
        url = f"http://www.omdbapi.com/?apikey={self.apiKey}&t={title}"
        response = requests.get(url)

        return response.json()



if __name__ == '__main__':
    api = OMDbAPI()
    print(api.search("The Matrix"))
    print(api.search("The Matrix")['Poster'])
