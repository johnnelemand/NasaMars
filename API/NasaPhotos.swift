//
//  NasaPhotos.swift
//  Nasa
//
//  Created by Johnne Lemand on 26/12/23.
//



import Foundation

/// Delegate that we can send to the view the information from the service.
protocol NasaManagerDelegate: AnyObject {
    
    /// Function to send to the view all the photos that we received from the service.
    ///
    /// - Parameter photos: An array that contains all the photos that we received from the service.
    func showPhotos(with photos: [Photo])
    
    /// Function to send an error to the view when we have some failures in the service.
    ///
    /// - Parameter error: An string that contains the error from the service.
    func showError(with error: String)
    
}

final class NasaManager {
    public weak var delegate: NasaManagerDelegate?
    
    private let session = URLSession(configuration: .default)
    
    var nasaURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=ebIStTbKmXzyVhtxkCOpqLeNX616o5Ry9lcthjQx&sol=2000&page=1"
    
    public func obtainListNasa(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = URL(string: nasaURL) else {
            delegate?.showError(with: "Hubo un error con la url")
            return
        }
        
        let dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.delegate?.showError(with: "error al decodificar \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    self?.parsingData(with: data, completion: completion)
                }
            }
        }
        dataTask.resume()
    }
    
    private func parsingData(with data: Data?, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let data = data else {return}
        do{
            let nasaPhotos = try
            JSONDecoder().decode(NasaData.self, from: data)
            delegate?.showPhotos(with: nasaPhotos.photos)
            completion(.success(nasaPhotos.photos))
        }catch{
            delegate?.showError(with: "error al decodificar \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
