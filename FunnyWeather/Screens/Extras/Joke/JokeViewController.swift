//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

protocol JokeContainerProtocol {
    var JokeContainerIsExpanded:Bool { get set }
    func SetJokeContainerIsExpanded(_ trueFalse:Bool)
    func SetJokeContainerHeight(constant:Int)
}

class JokeViewController: UIViewController {
    
    var viewModel = JokeViewModel()
    
    let sizeWhenExpanded = 200
    let sizeWhenNotExpanded = 60
    
    let data = ["Joke 1", "Joke 2", "Joke 3", "Joke 4", "Joke 5"]
    @IBOutlet weak var JokeLabel: UILabel!
    
    @IBOutlet var JokeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheJokePanel()
        configureGestures()
        loadNewJoke()
    }
    
    func configureTheJokePanel() {
        self.view.backgroundColor = UIColor.appJokeBackground
    }
    
    func configureGestures() {
        // Swipe Up
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedByUser(_:)))
        upSwipeGesture.direction = .up
        self.view.addGestureRecognizer(upSwipeGesture)
        
        // Swipe Down
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedByUser(_:)))
        downSwipeGesture.direction = .down
        self.view.addGestureRecognizer(downSwipeGesture)
        
        // Tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedByUser(sender:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func swipedByUser(_ gesture:UISwipeGestureRecognizer) {
        if let parent = self.parent as? JokeContainerProtocol {
            if parent.JokeContainerIsExpanded == true && gesture.direction == .down {
                // Swiped Down
                parent.SetJokeContainerHeight(constant: sizeWhenNotExpanded)
                parent.SetJokeContainerIsExpanded(false)
            }
            if parent.JokeContainerIsExpanded == false && gesture.direction == .up {
                // Swiped Up
                parent.SetJokeContainerHeight(constant: sizeWhenExpanded)
                parent.SetJokeContainerIsExpanded(true)
            }
        }
    }
    @objc func tappedByUser(sender: UITapGestureRecognizer) {
        if let parent = self.parent as? JokeContainerProtocol {
            if parent.JokeContainerIsExpanded {
                loadNewJoke()
            } else {
                parent.SetJokeContainerHeight(constant: sizeWhenExpanded)
                parent.SetJokeContainerIsExpanded(true)
            }
        }
    }
    
    func loadNewJoke() {
        self.JokeLabel.text = viewModel.getJoke()
    }
}
