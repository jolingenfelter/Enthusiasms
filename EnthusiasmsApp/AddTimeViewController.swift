//
//  AddTimeViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/10/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddTimeViewController: UIViewController {
    
    var rewardTime = 0
    var additionalTime = 0
    var updatedTime = 0
    let minutesArray = [Int](1...60)
    let navigationBar = UINavigationBar()
    
    lazy var timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        self.view.addSubview(picker)
        return picker
    }()
    
    lazy var updateTimeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        button.setTitle("Update Time", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(updateTime), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        
        navBarSetup()
        
        // Set additional time
        additionalTime = minutesArray[self.timePicker.selectedRow(inComponent: 0)] * 60

    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        // NavBar Constraints
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        // TimePicker Constraints
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timePicker.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            timePicker.heightAnchor.constraint(equalToConstant: 200)
            ])
        
        // Button Constraints
        
        updateTimeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            updateTimeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateTimeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            updateTimeButton.heightAnchor.constraint(equalToConstant: 50),
            updateTimeButton.widthAnchor.constraint(equalToConstant: 200),
            ])
    }
    
    func navBarSetup() {
        
        view.addSubview(navigationBar)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelButton
        navigationBar.items = [navItem]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateTime() {
        
        if rewardTime + additionalTime >= 3600 {
            updatedTime = 3600
        } else {
            updatedTime = rewardTime + additionalTime
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: PickerView DataSource and Delegate

extension AddTimeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
