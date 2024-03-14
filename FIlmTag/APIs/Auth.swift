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
    
    static func changeLogin(oldLogin: String, newLogin: String, password: String, completion: @escaping (ServerResponse?, Error?) -> Void) {
        let passwordWithSalt: String = password + saltForPassword;
        let passwordHash: String = sha256Hash(data: passwordWithSalt);
        let urlString = "http://" + Constraints.serverIP + "/users/change_username/" + oldLogin + "/" + newLogin + "/" + passwordHash;
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
    
    static func changePassword(login: String, oldPassword: String, newPassword: String, completion: @escaping (ServerResponse?, Error?) -> Void) {
        let oldPasswordWithSalt: String = oldPassword + saltForPassword;
        let oldPasswordHash: String = sha256Hash(data: oldPasswordWithSalt);
        let newPasswordWithSalt: String = newPassword + saltForPassword;
        let newPasswordHash: String = sha256Hash(data: newPasswordWithSalt);
        let urlString = "http://" + Constraints.serverIP + "/users/change_password/" + login + "/" + oldPasswordHash + "/" + newPasswordHash;
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
