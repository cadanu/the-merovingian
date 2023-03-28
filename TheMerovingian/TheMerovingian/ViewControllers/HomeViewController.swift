//
//  HomeViewController.swift
//  TheMerovingian
//
//  Created by GDJ on 2023-03-26.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let backgroundImageView = UIImageView()
    let avatarImageView = UIImageView()
    
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.userArray.count
    }
    
    //
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: .default, reuseIdentifier: "cell")
        
        tableCell.primaryLabel.text = mainDelegate.userArray[indexPath.row].name
        tableCell.secondaryLabel.text = mainDelegate.userArray[indexPath.row].email
        tableCell.myImageView.image = UIImage(named: mainDelegate.userArray[indexPath.row].city!)
        
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
        
    }
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        // unwind segues here
    }
    
    
    // viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let randomInt = Int.random(in: 0...2)
        setAvatar(fileName: mainDelegate.avatarArray[randomInt])
        setBackground(fileName: "gate")
    }
    
    
    // sets the background programmatically
    func setBackground(fileName: String) {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -150).isActive = true
        //        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: ).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundImageView.alpha = 0.9
        backgroundImageView.image = UIImage(named: "gate")
        
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
    // sets the avatar programmatically
    func setAvatar(fileName: String) {
        let avatarImage = UIImage(named: fileName)
        
        view.addSubview(avatarImageView)
        avatarImageView.image = resizeImage(avatarImage!, 320)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant: 70).isActive = true
        avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        avatarImageView.alpha = 0.95
        view.addSubview(avatarImageView)
    }
    
    
    // resizes images by shortest defined (sizeFactor) - maintain aspect ratio
    func resizeImage(_ image: UIImage, _ sizeFactor: Float) -> UIImage? {
        let newHeight: CGFloat
        let newWidth: CGFloat
        let size = image.size
        let floatArg = CGFloat(sizeFactor)
        
        if (size.height > size.width) {
            newHeight = (size.height * floatArg) / size.width
            newWidth = floatArg
        }
        else {
            newHeight = floatArg
            newWidth = (size.width * floatArg) / size.height
        }
        let newSize = CGSize(width: newWidth, height: newHeight)
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
