//
//  ViewController.swift
//  RickMortyCollection
//
//  Created by esTechVMG on 11/1/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let Url = String(format: "https://qastusoft.com.es/apis/login2.php")
                    guard let serviceUrl = URL(string: Url) else { return }
                    var request = URLRequest(url: serviceUrl)
                    request.httpMethod = "POST"
                    request.setValue("Application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    //let bodyData = "user=\(userTxtField.text!)&pass=\(passTxtField.text!)"
                    request.httpBody = bodyData.data(using: String.Encoding.utf8);
                    let session = URLSession.shared
                    session.dataTask(with: request) { (data, response, error) in
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                if let dictionary = json as? [String: Any] {
                                    if let code = dictionary["code"] as? Int {
                                        var alertMessage:String?
                                        switch code {
                                        case 1:
                                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                            DispatchQueue.main.async {
                                                //let viewController:SuccessLoginController = storyboard.instantiateViewController(identifier: "LoginSuccesStoryboard")
                                                //viewController.self.welcomeTxt = "Welcome \(self.userTxtField.text ?? "")"
                                                //self.present(viewController, animated: true, completion: nil)
                                            }
                                            break
                                        case -1:
                                            alertMessage="Faltan datos"
                                            break
                                        case -2:
                                            alertMessage="Credenciales no válidas"
                                            break
                                        case -3:
                                            alertMessage="Ciclo no valido"
                                            break
                                        default:
                                            alertMessage="Ha habido un error inesperado. Vuelva a intentarlo mas tarde"
                                        }
                                        
                                        if ((alertMessage?.isEmpty) != nil) {
                                            let alertController = UIAlertController.init(title: "Error", message: alertMessage, preferredStyle: .actionSheet)
                                            let ok = UIAlertAction.init(title: "OK", style: .default, handler:nil)
                                            alertController.addAction(ok)
                                            DispatchQueue.main.async {
                                                self.present(alertController, animated: true, completion:nil)
                                            }
                                                
                                            
                                            
                                        }
                                            
                                        
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }.resume()
        // Do any additional setup after loading the view.
    }


}

