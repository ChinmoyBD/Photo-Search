//
//  ViewController.swift
//  PhotoSearch
//
//  Created by Chinmoy Biswas on 8/9/21.
//

import UIKit

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let regular: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    var results: [Result] = []
    
    let searchbar = UISearchBar()
    
    private var collectionView: UICollectionView?
    
    // MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    
    /// Setup Search Bar
    func setupSearchBar() {
        searchbar.delegate = self
        view.addSubview(searchbar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        if let text = searchbar.text {
            results = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }
    
    /// Setup Collection View
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    /// API Call
    func fetchPhotos(query: String) {
        let urlString = "https://api.unsplash.com/search/photos?page=2&per_page=50&query=\(query)&client_id=PsVtIqTBY0yT4uUjZdRheGCQxNB1YZD66Hqmnwv3DIc"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    /// Collection View Cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLSting = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.identifier,
                for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLSting)
        return cell
    }


}

