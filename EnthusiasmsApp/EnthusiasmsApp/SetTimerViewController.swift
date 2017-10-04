//
//  SetTimerViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class SetTimerViewController: UIViewController {
    
    var student: Student?
    var rewardTime: Int = 0
    let minutesArray = [Int](1...60)
    
    lazy var timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        self.view.addSubview(picker)
        return picker
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start!", for: .normal)
        button.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        self.view.addSubview(button)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        if let student = student {
            
            if let studentName = student.name {
                self.title = "Set reward time for \(studentName)"
            }
        }
        
        // RewardTime
        rewardTime = minutesArray[self.timePicker.selectedRow(inComponent: 0)] * 60
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rewardTime = rewardTime

    }
    
    override func viewDidLayoutSubviews() {
        pickerSetup()
        buttonConstraints()
    }
    
    func pickerSetup() {
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            timePicker.heightAnchor.constraint(equalToConstant: 400)
            ])
    }
    
    func buttonConstraints() {
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 300)
            ])
    }
    
    @objc func startPressed() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let studentCollectionView = StudentCollectionViewController(student: student!, collectionViewLayout: flowLayout)
        studentCollectionView.navigationItem.hidesBackButton = true
        
        self.navigationController?.pushViewController(studentCollectionView, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

 // MARK: PickerView DataSource and Delegate

extension SetTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        rewardTime = minutesArray[row] * 60
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rewardTime = rewardTime
    }

    
}
