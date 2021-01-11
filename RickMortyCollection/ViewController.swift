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
        
        return //Stub
    }
    
    @IBOutlet weak var collection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterList?.results.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharCell", for: indexPath) as! CharacterCell
        if characterList != nil {
            cell.nameLabel.text = characterList?.results[indexPath.row].name
            cell.speciesLabel.text = characterList?.results[indexPath.row].species
            if let url = URL(string: (characterList?.results[indexPath.row].image)!) {
                do {
                    
                    let data:Data = try Data(contentsOf: url)
                    cell.image.image = UIImage(data: data)
                } catch  {
                    //Cant create
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    struct CharacterListResponse:Decodable {
        let info:CharacterListResponseInfo
        let results:[CharacterListResponseResult]
    }
    struct  CharacterListResponseInfo:Decodable{
        let count:Int
        let pages:Int
        let next:String?
        let prev:String?
    }
    struct  CharacterListResponseResult:Decodable {
        let id:Int
        let name:String
        let status:String
        let species:String
        let type:String
        let gender:String
        let origin:InfoReference
        let location:InfoReference
        let image:String
        let episode:[String]
        let url:String
        let created:String
    }
    struct InfoReference:Decodable {
        let name:String
        let url:String?
    }
    var baseUrl:String = "https://rickandmortyapi.com/api/"
    let searchController = UISearchController(searchResultsController: nil)
    public var characterList:CharacterListResponse?
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
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let response: CharacterListResponse = try! JSONDecoder().decode(CharacterListResponse.self, from: data)
                self.characterList = response
                /*for e in characterList?.results{
                    
                }*/
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
                
            }
        }.resume()
    }
    func searchInit(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Busque una ciudad"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

