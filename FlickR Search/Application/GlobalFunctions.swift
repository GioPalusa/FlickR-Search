//
//  GlobalFunctions.swift
//  FlickR Search
//
//  Created by Giovanni Palusa on 2018-04-19.
//  Copyright © 2018 Giovanni Palusa. All rights reserved.
//

import UIKit
import SystemConfiguration

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

public func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}
