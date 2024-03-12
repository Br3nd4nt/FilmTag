//
//  FilmAPIController.swift
//  FilmTag
//
//  Created by br3nd4nt on 09.03.2024.
//

import Foundation
import UIKit

class FilmAPIController {
    private static let defaults = UserDefaults.standard
    
    static func searchForFilm(_ filmName: String, completion: @escaping ([Film?], Error?) -> Void) {
        let urlString: String = "http://" + Constraints.serverIP + "/search/" + filmName;
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {return;};
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion([nil], error);
                return;
            }
            do {
                if (data == nil) {
                    completion([nil], nil);
                } else {
                    let dataUnwrapped = data!;
                    
                    let decoder = JSONDecoder();
                    let decodedData = try decoder.decode([Film].self, from: dataUnwrapped);
                    completion(decodedData, nil);
                }
            } catch {
                completion([nil], nil);
            }
        }
        task.resume();
    }

    static func leaveReview(film: FilmForDisplay, reviewNumber: Double, reviewText: String) {
        print("started")
        let login: String = defaults.string(forKey: Constraints.loginKey)!
        var urlString: String = "http://" + Constraints.serverIP + "/review/"
        urlString +=  login + "/" + film.title + "/" + reviewText + "/" + String(reviewNumber)
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {return;};
        print("url created")
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("There was an error while posting review: ", error)
                return;
            }
        }
        task.resume();
    }
    
    static func getUserReviews(username: String, completion: @escaping ([Review?], Error?) -> Void) {
        print("url created")
        let urlString: String = "http://" + Constraints.serverIP + "/get_reviews/" + username;
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {return;};
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        print("requestcreated")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("error while getting reviews: ", error)
                completion([nil], error);
                return;
            }
            do {
                if (data == nil) {
                    completion([nil], nil);
                } else {
                    let dataUnwrapped = data!;
                    
                    let decoder = JSONDecoder();
                    let decodedData = try decoder.decode([Review].self, from: dataUnwrapped);
                    print("every thing is okay")
                    completion(decodedData, nil);
                    
                }
            } catch {
                completion([nil], nil);
            }
        }
        task.resume();
    }
}

struct Film: Codable, Hashable {
    let title: String
    let api_id: Int
    let overview: String
    let poster_path: String
    let review_average: Float
    
}

struct FilmForDisplay {
    let title: String
    let api_id: Int
    let overview: String
    let poster: UIImage
    let review_average: Float
}

struct Review: Codable, Hashable {
    let username: String
    let title: String
    let stars: Double
    let text: String
    let poster_path: String
}

struct ReviewForDisplay {
    let username: String
    let title: String
    let stars: Double
    let text: String
    let poster: UIImage
}
