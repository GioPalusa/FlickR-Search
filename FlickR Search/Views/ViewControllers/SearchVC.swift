//
//  ViewController.swift
//  FlickR Search
//
//  Created by Giovanni Palusa on 2018-04-18.
//  Copyright © 2018 Giovanni Palusa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchfield: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchfield.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        searchBtn.isHidden = false
        spinner.isHidden = true
        searchfield.text = ""
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        
        if searchfield.text == "" {
            showPopup(message: "You need to enter a text to search for", code: 0, sender: self)
        } else {
            searchBtn.isHidden = true
            spinner.isHidden = false
            spinner.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            // Send search string to Flickr and wait for response
            DataManager.getPhotosFromFlickr(keywords: searchfield.text!) { (photos, error) in
                
                if let error = error {
                    guard let messageText: String = error.userInfo["message"] as? String else { return }
                    showPopup(message: messageText, code: error.code, sender: self)
                } else if photos?.count == 0 {
                    DispatchQueue.main.async {
                        self.searchBtn.isHidden = false
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.searchfield.text = ""
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    showPopup(message: "We couldn't find anything - try again", code: 0, sender: self)
                } else {
                    // Go to main thread to reach UI elements
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.navigationController?.isNavigationBarHidden = false
                        self.spinner.stopAnimating()
                        self.performSegue(withIdentifier: "searchResult", sender: photos)
                    }
                }
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResult"{
            let vc = segue.destination as! SearchResultVC
            guard let photos = sender as? [Photos] else { return }
            vc.photos = photos
        }
    }
    
    //MARK: - Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBtnPressed(self)
        textField.resignFirstResponder()
        return true
    }
    
}

