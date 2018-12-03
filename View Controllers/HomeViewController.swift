//
//  HomeViewController.swift
//  Companies
//
//  Created by Osman Balci on 1/9/18.
//  Copyright © 2018 Osman Balci. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Number of images in the slide show
    let numberOfImages = 9
    
    // List of object references of the UIButton objects created in the storyboard
    var listOfImageButtons: [UIButton] = [UIButton]()
    
    // Define the empty and full circle images
    let circleEmptyImage: UIImage = UIImage(named: "CircleEmpty.png")!
    let circleFullImage: UIImage = UIImage(named: "CircleFull.png")!
    
    // Initializations
    var previousImageButtonTapped: UIButton? = nil
    var previousImageNumber: Int = 0
    
    // Instance variable holding the object reference of the UIImageView object created in the storyboard
    @IBOutlet var imageView: UIImageView!
    
    // Instance variables holding the object references of the UIButton objects created in the storyboard
    @IBOutlet var imageButton1: UIButton!
    @IBOutlet var imageButton2: UIButton!
    @IBOutlet var imageButton3: UIButton!
    @IBOutlet var imageButton4: UIButton!
    @IBOutlet var imageButton5: UIButton!
    @IBOutlet var imageButton6: UIButton!
    @IBOutlet var imageButton7: UIButton!
    @IBOutlet var imageButton8: UIButton!
    @IBOutlet var imageButton9: UIButton!
    
    // A timer that invokes a method after a certain time interval has elapsed
    var timer = Timer()
    
    /*
     -----------------------------------
     MARK: - Invoked from the Storyboard
     -----------------------------------
     */
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        
        let currentImageButtonTapped = sender
        
        // The tag numbers are given in the storyboard for the UIButton objects
        let currentImageNumber = sender.tag
        
        // Set the image of the UIImageView object, which is our image slider
        imageView.image = UIImage(named: "photo\(currentImageNumber).png")!
        
        // Change the button images
        currentImageButtonTapped.setImage(circleFullImage, for: .normal)
        previousImageButtonTapped?.setImage(circleEmptyImage, for: .normal)
        
        previousImageButtonTapped = currentImageButtonTapped
        
        previousImageNumber = currentImageNumber
        
        // Stop the current timer
        timer.invalidate()
        
        // Create a new timer
        startTimer()
    }
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         listOfImageButtons contains the object references of the UIButton objects created
         in the storyboard. Its index goes from 0 to numberOfImages - 1 = 8.
         */
        listOfImageButtons = [imageButton1, imageButton2, imageButton3, imageButton4, imageButton5,
                              imageButton6, imageButton7, imageButton8, imageButton9]
        
        // Initializations
        previousImageButtonTapped = imageButton1
        previousImageNumber = 1
        
        // Create a new timer
        startTimer()
    }
    
    /*
     -------------------------------
     MARK: - Creation of a New Timer
     -------------------------------
     */
    func startTimer() {
        /*
         Schedule a timer to invoke the changeImage() method given below
         after 3 seconds in a loop that repeats itself until it is stopped.
         */
        timer = Timer.scheduledTimer(timeInterval: 3,
                                     target: self,
                                     selector: (#selector(HomeViewController.changeImage)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    /*
     ----------------------------------
     MARK: - Change Image in the Slider
     ----------------------------------
     */
    @objc func changeImage() {
        
        if previousImageNumber == numberOfImages {
            
            // End of list is reached
            
            // Set the image of the last button in the list to show an empty circle
            listOfImageButtons[numberOfImages - 1].setImage(circleEmptyImage, for: .normal)
            
            // Make initializations to start the slide show again with image 1
            previousImageNumber = 1
            imageView.image = UIImage(named: "photo1.png")!
            imageButton1.setImage(circleFullImage, for: .normal)
            previousImageButtonTapped = imageButton1
            
        } else {
            // Set the image of the previous button to show an empty circle
            listOfImageButtons[previousImageNumber - 1].setImage(circleEmptyImage, for: .normal)
            
            // Set the previousImageNumber to be the next image number by incrementing by 1
            previousImageNumber += 1
            
            // Set the image of the next button to show a full circle
            listOfImageButtons[previousImageNumber - 1].setImage(circleFullImage, for: .normal)
            
            // Set the slider (UIImageView) to show the next image
            imageView.image = UIImage(named: "photo\(previousImageNumber).png")!
            
            // Set the previousImageButtonTapped to be the current button
            previousImageButtonTapped = listOfImageButtons[previousImageNumber - 1]
        }
    }
    
}


