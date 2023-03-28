//
//  ViewController.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit
//import WebKit

class ViewController: UIViewController {
    
    @IBOutlet var imgSignUp: UIImageView!
    let backgroundImageView = UIImageView()
    
    
    // handle touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchPoint: CGPoint = touch.location(in: self.view!)
        
        let subscribeFrame: CGRect = imgSignUp.frame
        
        if subscribeFrame.contains(touchPoint) {
            performSegue(withIdentifier: "HomeToSignUpSegue", sender: self)
        }
    }
    
    
    @IBAction func unwindToSplash(sender : UIStoryboardSegue) {
        // unwind segues to here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
    
    /* Set background as ImageView control in Storyboard but it kept overlapping
     the other elements, so set it here instead in the interest of time */
    func setBackground() {
        
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -150).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        backgroundImageView.image = UIImage(named: "gate")
        
        view.sendSubviewToBack(backgroundImageView)
    }
}

