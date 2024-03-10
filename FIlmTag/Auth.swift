//
//  Auth.swift
//  FilmTag
//
//  Created by br3nd4nt on 08.03.2024.
//
import UIKit
import CryptoKit

final class Auth {
    private static let saltForPassword: String = "TheQuickBrownFoxJumpsOverTheLazyDog";
    
    private static func sha256Hash(data: String) -> String {
      let inputData = Data(data.utf8)
      let hashedData = SHA256.hash(data: inputData)
      return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    static func login(login: String, password: String, completion: @escaping (ServerResponse?, Error?) -> Void) {
        let passwordWithSalt: String = password + saltForPassword;
        let passwordHash: String = sha256Hash(data: passwordWithSalt);
        let urlString = "http://" + Constraints.serverIP + "/users/login/" + login + "/" + passwordHash;
        guard let url = URL(string: urlString) else {return;};
        
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(nil, error);
                return;
            }
            
            do {
                if (data == nil) {
                    completion(nil, nil);
                } else {
                    let dataUnwrapped = data!;
                    
                    let decoder = JSONDecoder();
                    let decodedData = try decoder.decode(ServerResponse.self, from: dataUnwrapped);
                    
                    completion(decodedData, nil);
                }
            } catch {
                completion(nil, nil);
            }
        }
        
        task.resume();
    }
    
    static func loginWithHash(login: String, passwordHash: String, completion: @escaping (ServerResponse?, Error?) -> Void) {
        let urlString = "http://" + Constraints.serverIP + "/users/login/" + login + "/" + passwordHash;
        guard let url = URL(string: urlString) else {return;};
        
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(nil, error);
                return;
            }
            
            do {
                if (data == nil) {
                    completion(nil, nil);
                } else {
                    let dataUnwrapped = data!;
                    
                    let decoder = JSONDecoder();
                    let decodedData = try decoder.decode(ServerResponse.self, from: dataUnwrapped);
                    
                    completion(decodedData, nil);
                }
            } catch {
                completion(nil, nil);
            }
        }
        
        task.resume();
    }

    static func register(login: String, password: String, completion: @escaping (ServerResponse?, Error?) -> Void) {
        let passwordWithSalt: String = password + saltForPassword;
        let passwordHash: String = sha256Hash(data: passwordWithSalt);
        let urlString = "http://" + Constraints.serverIP + "/users/register/" + login + "/" + passwordHash;
        guard let url = URL(string: urlString) else {return;};
        
        var urlRequest = URLRequest(url: url);
        urlRequest.httpMethod = "GET";
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(nil, error);
                return;
            }
            
            do {
                if (data == nil) {
                    completion(nil, nil);
                } else {
                    let dataUnwrapped = data!;
                    
                    let decoder = JSONDecoder();
                    let decodedData = try decoder.decode(ServerResponse.self, from: dataUnwrapped);
                    
                    completion(decodedData, nil);
                }
            } catch {
                completion(nil, nil);
            }
        }
        
        task.resume();
    }
    
}



struct ServerResponse : Codable, Hashable {
    let login: String
    let passwordHash: String
}
