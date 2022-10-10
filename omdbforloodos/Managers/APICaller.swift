//
//  APICaller.swift
//  omdbforloodos
//
//  Created by tayfun on 8.10.2022.
//

import Foundation

struct Constants{
    //    posterbaseurl didn't use because api(not free) didn't return posterpath. it returns full url of amazon.
    //    static let posterBaseURL = "http://img.omdbapi.com"

    static let API_KEY = "92c6da5e"
    static let baseURL = "http://www.omdbapi.com"
    static let YoutubeAPI_KEY = "AIzaSyCCdz79zwHudtWs8Dx-gmxbp3r0VjuodDY"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    
    //    MARK: - SEARCH MOVIES
    func searchMovies(with query: String,completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/?apikey=\(Constants.API_KEY)&s=\(query)") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(MovieResult.self, from: data)
                completion(.success(results.Search))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
//    Using YoutubeAPI, I accessed the trailer videos of the movies with the title information I got from OMDB.

    func getMovieTrailer(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
