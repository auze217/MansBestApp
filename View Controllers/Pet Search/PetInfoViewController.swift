//
//  PetInfoViewController.swift
//  MansBestApp
//
//  Created by Austin Connor Zensen on 11/27/18.
//  Copyright © 2018 Conner Caprio. All rights reserved.
//

import UIKit

class PetInfoViewController: UIViewController {

    var petInfoToPass = [String]()
    //let petInfoToPass = [name, sex, age, breed, imageString, description]
    /*
     [0] name
     [1] sex
     [2] age
     [3] breed
     [4] image
     [5] description
     [6] Contact Info
     */
    @IBOutlet var petImageView: UIImageView!
    @IBOutlet var petBreedLabel: UILabel!
    @IBOutlet var petAgeLabel: UILabel!
    @IBOutlet var petSexLabel: UILabel!
    @IBOutlet var petDescriptionLabel: UITextView!
    @IBOutlet var contactTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setting title to pets name
        let navigationBarWidth = self.navigationController?.navigationBar.frame.width
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let labelRect = CGRect(x: 0, y: 0, width: navigationBarWidth!, height: navigationBarHeight!)
        let titleLabel = UILabel(frame: labelRect)
        
        titleLabel.text = petInfoToPass[0]
        
        titleLabel.font = titleLabel.font.withSize(14)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
        
        //pet image
        let imageUrl = URL(string: petInfoToPass[4])
        let imageData: Data?
        do {
            imageData = try Data(contentsOf: imageUrl!)
            petImageView.image = UIImage(data: imageData!)
        } catch {
            petImageView.image = UIImage(named: "ben.jpg")
        }
        //setting the text for pet info
        petSexLabel.text = petInfoToPass[1]
        petAgeLabel.text = petInfoToPass[2]
        petBreedLabel.text = petInfoToPass[3]
        petDescriptionLabel.text = petInfoToPass[5]
        petDescriptionLabel.scrollRangeToVisible(NSMakeRange(0, 0))
        contactTextView.text = petInfoToPass[6]
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
