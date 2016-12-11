//
//  SetTimerViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class SetTimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var student: Student?
    let timePicker = UIPickerView()
    let startButton = UIButton()
    var rewardTime: Int = 0
    let minutesArray = [Int](1...60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        if let student = student {
            if let studentName = student.name {
                self.title = "Set reward time for \(studentName)"
            }
        }
        
        // TimePicker setup
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.backgroundColor = UIColor.white
        view.addSubview(timePicker)
        
        // Button
        startButton.setTitle("Start!", for: .normal)
        startButton.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        startButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        startButton.layer.cornerRadius = 5
        startButton.layer.masksToBounds = true
        view.addSubview(startButton)
    }
    
    override func viewDidLayoutSubviews() {
        datePickerConstraints()
        buttonConstraints()
    }
    
    func datePickerConstraints() {
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let verticalConstraint = timePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        let heightConstraint = timePicker.heightAnchor.constraint(equalToConstant: 400)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, verticalConstraint, heightConstraint])
    }
    
    func buttonConstraints() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = startButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        let heightConstraint = startButton.heightAnchor.constraint(equalToConstant: 50)
        let widthConstraint = startButton.widthAnchor.constraint(equalToConstant: 300)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
    }
    
    func startPressed() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let studentCollectionView = StudentCollectionViewController(collectionViewLayout: flowLayout)
        studentCollectionView.navigationItem.hidesBackButton = true
        studentCollectionView.student = student
        studentCollectionView.rewardTime = rewardTime
        self.navigationController?.pushViewController(studentCollectionView, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: PickerView DataSource and Delegate
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutesArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(minutesArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rewardTime = minutesArray[row] * 60
    }

}
