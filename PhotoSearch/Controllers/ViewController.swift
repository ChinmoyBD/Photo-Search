//
//  ViewController.swift
//  PhotoSearch
//
//  Created by Chinmoy Biswas on 8/9/21.
//

import UIKit

class ViewController: UIViewController {
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&query=office&client_id=PsVtIqTBY0yT4uUjZdRheGCQxNB1YZD66Hqmnwv3DIc"
    
    // MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            print("Got data!")
        }
        
        task.resume()
    }


}

