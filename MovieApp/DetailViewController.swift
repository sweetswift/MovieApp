//
//  DetailViewController.swift
//  MovieApp
//
//  Created by chungwoolee on 2023/01/05.
//

import UIKit
import AVKit

class DetailViewController: UIViewController {
    
    var movieResult: MovieResult?
    
    @IBOutlet weak var movieContainer: UIView!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movieResult?.trackName
        descriptionLabel.text = movieResult?.longDescription
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let hasURL = movieResult?.previewUrl {
            makePlayerAndPlay(urlString: hasURL)
        }
    }
    
    func makePlayerAndPlay(urlString: String) {
        if let hasUrl = URL(string: urlString) {
            let player = AVPlayer(url: hasUrl)
            let playerLayer = AVPlayerLayer(player: player)
            
            movieContainer.layer.addSublayer(playerLayer)
            playerLayer.frame = movieContainer.bounds
            player.play()
            
        }
        
        
    }
    
}
