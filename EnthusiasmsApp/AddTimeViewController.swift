//
//  AddTimeViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/10/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let timePicker = UIPickerView()
    var rewardTime = 0
    var additionalTime = 0
    var updatedTime = 0
    let updateTimeButton = UIButton()
    let minutesArray = [Int](1...60)
    let navigationBar = UINavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        
        // NavBar Setup
        view.addSubview(navigationBar)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelButton
        navigationBar.items = [navItem]
        
        // Time Picker Setup
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.backgroundColor = UIColor.white
        additionalTime = minutesArray[self.timePicker.selectedRow(inComponent: 0)] * 60
        view.addSubview(timePicker)
        
        // Button Setup
        updateTimeButton.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        updateTimeButton.setTitle("Update Time", for: .normal)
        updateTimeButton.setTitleColor(.white, for: .normal)
        updateTimeButton.layer.cornerRadius = 5
        updateTimeButton.layer.masksToBounds = true
        updateTimeButton.addTarget(self, action: #selector(updateTime), for: .touchUpInside)
        view.addSubview(updateTimeButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        // NavBar Constraints
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navBarLeadingConstraint = navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let navBarTrailingConstraint = navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let navBarTopConstraint = navigationBar.topAnchor.constraint(equalTo: view.topAnchor)
        let navBarHeightConstraint = navigationBar.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([navBarLeadingConstraint, navBarTrailingConstraint, navBarTopConstraint, navBarHeightConstraint])
        
        // TimePicker Constraints
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let timePickerLeadingConstraint = timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let timePickerTrailingConstraint = timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let timePickerTopConstraint = timePicker.topAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        let timePickerHeightConstraint = timePicker.heightAnchor.constraint(equalToConstant: 250)
        
        NSLayoutConstraint.activate([timePickerLeadingConstraint, timePickerTrailingConstraint, timePickerTopConstraint, timePickerHeightConstraint])
        
        // Button Constraints
        
        updateTimeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let updateTimeHorizontalConstraint = updateTimeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let updateTimeTopConstraint = updateTimeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        let updateTimeHeightConstraint = updateTimeButton.heightAnchor.constraint(equalToConstant: 50)
        let updateTimeWidthConstraint = updateTimeButton.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([updateTimeHorizontalConstraint, updateTimeTopConstraint, updateTimeHeightConstraint, updateTimeWidthConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        
        if rewardTime + additionalTime >= 3600 {
            updatedTime = 3600
        } else {
            updatedTime = rewardTime + additionalTime
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: PickerView DataSource and Delegate
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutesArray.count
        } else {
            return 1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(minutesArray[row])
        } else {
            return "min"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 50
        } else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        additionalTime = minutesArray[row] * 60
    }

}
