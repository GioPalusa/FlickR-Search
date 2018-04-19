//
//  GlobalFunctions.swift
//  FlickR Search
//
//  Created by Giovanni Palusa on 2018-04-19.
//  Copyright © 2018 Giovanni Palusa. All rights reserved.
//

import UIKit

func showPopup(message: String, code: Int, sender: UIViewController) {
    
    var popupTitle = ""
    
    if code == 0 {
        popupTitle = NSLocalizedString("Error", comment: "Error title")
    } else if code == 999 {
        popupTitle = NSLocalizedString("Info", comment: "Info title")
    } else {
        popupTitle = String(code)
    }
    
    
    
    let alertController = UIAlertController(title: popupTitle, message:
        message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Button"), style: UIAlertActionStyle.default,handler: nil))
    
    DispatchQueue.main.async {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        sender.present(alertController, animated: true, completion: nil)
    }
}
