# FilmTag
###### Final project for iOS development class by Belov Vladislav (group BSE 225)

## Targets
I wanted to create an app to tracking films you've watched, your thoughts and reviews about them, and also to get recomended new films based on movies you've previously watched

## Development
### Mobile app
For mobile app i used swift (*obviously*), UIKit, and some of packages: 
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI)

 	For easy downloading images asynchronically

 - [Cosmos](https://github.com/evgenyneu/Cosmos)

   For creating easy and good-looking 5-star reviews

### Server

Whole project became possible and was created aroud [TMDB](https://developer.themoviedb.org/docs/) - the movie database 

Prvate server was written in Python using libraries:

- [Flask](https://flask.palletsprojects.com/en/3.0.x/)

  	Whole server was written in Flask, its used for dealing with all the URL requests created in mobile app

- [sqlite3](https://docs.python.org/3/library/sqlite3.html)

  Used to create and manage local database

- [requests](https://requests.readthedocs.io/en/latest/)

  Used for creating requests to TMDB API

## Usage

### Mobile app

To run iOS app download the Xcode project:
```bash
git clone -b main https://github.com/br3nd4nt/filmtag
```

Then open it, for example like this:
```bash
cd filmtag
open FilmTag.xcodeproj
```

__Open Constrains enum located in Views/LoginViewController.swift and change serverIP to IP and chosen of your server__

and run it in your Xcode for preferable device

### Server
To run server on your own, firsly go to <https://developer.themoviedb.org/docs/getting-started> and get yourself an API key

save it as an enviroment variable for name *TMDBAPIKey* (or another preferable name and change it in the /server/TMDBAPI.py)

you can do it different ways, for example: 
```bash
echo "export TMDBAPIKey=YOUR_API_KEY_HERE" >> /etc/profile
```

or if you are using zsh as i do:
```bash
echo "export TMDBAPIKey=YOUR_API_KEY_HERE" >> ~/.zshrc
```

Then you download server part of the project:

```bash
git clone -b server https://github.com/br3nd4nt/filmtag
```

Open it and install all required libraries:

```bash
cd filmtag/server
pip install -r requirements.txt
```

Open *server.py* file and put ip in it:

```python
YOUR_IP = "YOUR_IP_HERE"
```

Also if you want you can change what port to use in the botton of the same file here:

```python
app.run(port=8080, host=YOUR_IP)
```

And after all of this you can simply start up your server:

```bash
python server.py
```
