//
//  ViewController.swift
//  MovieApp
//
//  Created by chungwoolee on 2023/01/03.
//

import UIKit

class ViewController: UIViewController {
    
    var movieModel: MovieModel?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    var networkLayer = NetworkLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
        
        requestMovieAPI()
    }
    
    private func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        networkLayer.request(type: .justURL(urlString: urlString)) { data, response, error in
            if let hasData = data {
                completion(UIImage(data: hasData))
                return
             
            }
            completion(nil)
        }
        
    }
    
    //    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
    //        let sessionConfig = URLSessionConfiguration.default
    //        let session = URLSession(configuration: sessionConfig)
    //
    //        if let hasURL = URL(string: urlString) {
    //            var request = URLRequest(url: hasURL)
    //            request.httpMethod = "GET"
    //
    //            session.dataTask(with: request) { data, response, error in
    //                print((response as! HTTPURLResponse).statusCode)
    //
    //                if let hasData = data {
    //                    UIImage(data: hasData)
    //                    completion(UIImage(data: hasData))
    //                    return
    //                }
    //            }.resume()
    //            session.finishTasksAndInvalidate()
    //        }
    //
    //        completion(nil)
    //    }
    
    // network
    func requestMovieAPI() {
        
        let term = URLQueryItem(name: "term", value: "marvel")
        let media = URLQueryItem(name: "media", value: "movie")
        let querys = [term, media]
        
        networkLayer.request(type: .searchMovie(querys: querys)) { data, response, error in
            
            if let hasData = data {
                do {
                    self.movieModel = try JSONDecoder().decode(MovieModel.self, from: hasData)
                    print(self.movieModel ?? "no data")
                    
                    DispatchQueue.main.async {
                        self.movieTableView.reloadData()
                    }
                    
                    
                }catch{
                    print(error)
                }
                
            }
            
        }
    }
    
//    func requestMovieAPI() {
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//        
//        var componets = URLComponents(string: "https://itunes.apple.com/search")
//        let term = URLQueryItem(name: "term", value: "marvel")
//        let media = URLQueryItem(name: "media", value: "movie")
//        
//        componets?.queryItems = [term, media]
//        
//        guard let url = componets?.url else { return}
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        let task = session.dataTask(with: request) { data, response, error in
//            print((response as! HTTPURLResponse).statusCode)
//            
//            if let hasData = data {
//                do {
//                    self.movieModel = try JSONDecoder().decode(MovieModel.self, from: hasData)
//                    print(self.movieModel ?? "no data")
//                    
//                    DispatchQueue.main.async {
//                        self.movieTableView.reloadData()
//                    }
//                    
//                    
//                }catch{
//                    print(error)
//                }
//                
//            }
//            
//        }
//        
//        task.resume()
//        session.finishTasksAndInvalidate()
//    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.movieModel?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        detailVC.movieResult = self.movieModel?.results[indexPath.row]
        //detailVC.modalPresentationStyle = .fullScreen
        
        self.present(detailVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.titleLabel.text = movieModel?.results[indexPath.row].trackName
        cell.descriptionLabel.text = movieModel?.results[indexPath.row].shortDescription
        
        let currency = self.movieModel?.results[indexPath.row].currency ?? ""
        let price = self.movieModel?.results[indexPath.row].trackPrice?.description ?? ""
        cell.priceLabel.text = currency + price
        
        if let hasURL = self.movieModel?.results[indexPath.row].image {
            self.loadImage(urlString: hasURL) { image in
                DispatchQueue.main.async {
                    cell.movieImageView.image = image
                }
                
            }
        }
        
        if let dateString =  self.movieModel?.results[indexPath.row].releaseDate {
            let formatter = ISO8601DateFormatter()
            if let isoDate = formatter.date(from: dateString) {
                
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = myFormatter.string(from: isoDate)
                
                cell.dateLabel.text = dateString
            }
            
            
        }
        
        
        
        return cell
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
