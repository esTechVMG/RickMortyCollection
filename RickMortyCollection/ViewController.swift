//
//  ViewController.swift
//  RickMortyCollection
//
//  Created by esTechVMG on 11/1/21.
//

import UIKit
class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UISearchResultsUpdating {
    
    //Init
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            
        }
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        print("Searched: \(searchString)")
        if searchString.isEmpty{
            _characterListTemp = _characterListReal!.results
        }else{
            _characterListTemp = _characterListReal!.results.filter({
                (item:RequestResponse.CharacterListResponseResult) -> Bool in
                return item.name.contains(searchString);
            })
        }
        collection.reloadData()
        return //Stub
    }
    
    @IBOutlet weak var collection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _characterListTemp.count
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharCell", for: indexPath) as! CharacterCell
        cell.nameLabel.text = _characterListTemp[indexPath.row].name
        cell.speciesLabel.text = _characterListTemp[indexPath.row].species
        cell.image.image = UIImage(data: _characterListTemp[indexPath.row].imageData!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(identifier: "CharacterStoryboard") as? CharacterInfoViewController else {return}
        let character:RequestResponse.CharacterListResponseResult = _characterListTemp[indexPath.row] as RequestResponse.CharacterListResponseResult
        viewController.characterInfo = character
        //viewController.imageSource = UIImage.init(data: imageDataList[indexPath.row])
        viewController.imageSource = UIImage.init(data: _characterListTemp[indexPath.row].imageData!)
        present(viewController, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    var isSearchBarEmpty:Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering : Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    //var imageDataList:[Data]=Array()
    var baseUrl:String = "https://rickandmortyapi.com/api/"
    let searchController = UISearchController(searchResultsController: nil)
    var _characterListReal:RequestResponse.CharacterListResponse?
    var _characterListTemp:[RequestResponse.CharacterListResponseResult] = Array()
    /*var characterListToShow:RequestResponse.CharacterListResponse{
        get{
            
            return _characterListTemp
        }
    }
    var characterListMutable:RequestResponse.CharacterListResponse?*/
    override func viewWillAppear(_ animated: Bool) {
        searchInit()
        collection.delegate = self
        collection.dataSource = self
        getDataFromCharacters()
    }
    func getDataFromCharacters() {
        let Url = String(format: baseUrl + "character")
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        //let bodyData = "user=\(userTxtField.text!)&pass=\(passTxtField.text!)"
        //request.httpBody = bodyData.data(using: String.Encoding.utf8);
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let data = data {
                let response: RequestResponse.CharacterListResponse = try! JSONDecoder().decode(RequestResponse.CharacterListResponse.self, from: data)
                _characterListReal = response
                for i in 0...response.results.count-1{
                    getData(from: URL(string: response.results[i].image)!, completion: {(dataReceived:Data?,_,_) in
                        self._characterListReal!.results[i].imageData = dataReceived
                        _characterListTemp = _characterListReal!.results
                        DispatchQueue.main.async {
                            self.collection.reloadData()
                        }
                    })
                }
                
                
            }
        }.resume()
    }
    func searchInit(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar personaje"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

