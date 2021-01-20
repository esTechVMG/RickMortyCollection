//
//  CharacterInfo.swift
//  RickMortyCollection
//
//  Created by esTechVMG on 11/1/21.
//

import UIKit
class CharacterInfoViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var race: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var location: UILabel!
    var characterInfo:RequestResponse.CharacterListResponseResult!
    var imageSource:UIImage!
    override func viewDidLoad() {
        name.text = characterInfo.name
        race.text = "Race: " + characterInfo.species
        status.text = "Status: " + characterInfo.status
        gender.text = "Gender: " + characterInfo.gender
        origin.text = "Origin: " + characterInfo.origin.name
        location.text = "Location: " + characterInfo.location.name
        image.image = imageSource
    }
}
