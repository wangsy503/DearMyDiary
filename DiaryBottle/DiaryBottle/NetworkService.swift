//
//  NetworkService.swift
//  DiaryBottle
//
//  Created by Shuyue on 2/17/24.
//

import Foundation

struct NetworkService {
    static func summarizeNote(content: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/summarize-note") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["content": content]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode content")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network request failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let summarizedContent = jsonResponse["summarizedContent"] as? String {
                        DispatchQueue.main.async {
                            completion(summarizedContent)
                        }
                    } else {
                        print("Invalid response format")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                } catch {
                    print("Failed to parse response")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                print("Server returned an error")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
