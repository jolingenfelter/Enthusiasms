//
//  FullScreenImageViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/27/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    var content: Content?
    var image = UIImage()
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    
    // Timer Variables
    var rewardTime = 0
    var remainingRewardTime = 0
    var timer = Timer()
    var addTimeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
    let addTimePasswordCheck = AddTimePasswordCheckViewController()
    let addTimeViewController = AddTimeViewController()
    var minutes: Int {
        return rewardTime / 60
    }
    var seconds: Int {
        return rewardTime % 60
    }
    var timeDisplay: String {
        if seconds == 0 {
            return "\(minutes):00"
        } else if seconds >= 1 && seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
    
    // Constraints
    var imageViewLeadingConstraint = NSLayoutConstraint()
    var imageViewTrailingConstraint = NSLayoutConstraint()
    var imageViewTopConstraint = NSLayoutConstraint()
    var imageViewBottomConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    
        view.addSubview(scrollView)
        self.view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        imageView.center = view.center
        imageView.image = image
        
        // ImageView setup
        
        imageView.contentMode = .scaleAspectFit
        
        // ScrollView setup
        
        scrollView.addSubview(imageView)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
         viewSetup()
        
        // Timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTimer()
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(updateRewardTime), name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addTimePasswordCheckComplete), name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
    }
    
    func navBarSetup() {
        
        navigationController?.hidesBarsOnTap = true
        
        self.title = content?.title
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
        if rewardTime > 0 {
            addTimeButton.addTarget(self, action: #selector(addTimePressed), for: .touchUpInside)
            addTimeButton.setTitleColor(.black, for: .normal)
            let addTimeBarButton = UIBarButtonItem.init(customView: addTimeButton)
            self.navigationItem.leftBarButtonItem = addTimeBarButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         navBarSetup()
    }
    
    func viewSetup() {
        
        // Scroll View
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollViewLeadingConstraint = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let scrollViewTrailingConstraint = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([scrollViewLeadingConstraint, scrollViewTrailingConstraint, scrollViewTopConstraint, scrollViewBottomConstraint])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTimePressed() {
        remainingRewardTime = rewardTime
        addTimePasswordCheck.modalPresentationStyle = .formSheet
        
        self.present(addTimePasswordCheck, animated: true, completion: nil)
    }
    
    func donePressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rewardTime = rewardTime
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Timer
    
    func updateTimer() {
        
        rewardTime -= 1
        addTimeButton.setTitle(timeDisplay, for: .normal)
        let enterPasswordVC = EnterPasswordViewController()
        
        if rewardTime == 0 {
            
            timer.invalidate()
            
            self.present(enterPasswordVC, animated: true, completion: nil)
            
        }
        
    }
    
    func addTimePasswordCheckComplete() {
        addTimeViewController.rewardTime = rewardTime
        addTimeViewController.modalPresentationStyle = .formSheet
        self.present(addTimeViewController, animated: true, completion: nil)
    }
    
    func updateRewardTime() {
        rewardTime = addTimeViewController.updatedTime
    }
    
    // MARK: ScrollView Delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
