//
//  ViewController.swift
//  Nasa
//
//  Created by Johnne Lemand on 26/12/23.
//

import UIKit

final class ViewController: UIViewController {

    private var ListPhotosLiked: [Photo] = [] {
        didSet {
            tableNasaPhotos.reloadData()
        }
    }
    
    private var nasaManager = NasaManager()
    
    private var nasaMostrar: Photo?
    
    @IBOutlet private weak var tableNasaPhotos: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setUpBindings()
    }
    
    private func setUpBindings() {
        nasaManager.delegate = self
        nasaManager.obtainListNasa { result in
            switch result {
            case .success(let photos):
                self.ListPhotosLiked = photos
            case .failure(_):
                break
            }
        }
    }
    
    private func setTableView() {
        tableNasaPhotos.delegate = self
        tableNasaPhotos.dataSource = self
    }

}

extension ViewController: NasaManagerDelegate {
    func showPhotos(with photos: [Photo]) {
        self.ListPhotosLiked = photos
        DispatchQueue.main.async {
            self.tableNasaPhotos.reloadData()
        }
    }
    
    func showError(with error: String) {
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListPhotosLiked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = ListPhotosLiked[indexPath.row].earthDate.description
        return cell
    }
}

