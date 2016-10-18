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
    let timePicker = UIDatePicker()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        if let student = student {
            if let studentName = student.name {
                self.title = "Set reward time for \(studentName)"
            }
        }
        
        // NavBar
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homePressed))
        self.navigationItem.leftBarButtonItem = homeButton
        
        // TimePicker setup
        timePicker.datePickerMode = .countDownTimer
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
        let verticalConstraint = timePicker.topAnchor.constraint(equalTo: (self.navigationController?.navigationBar.bottomAnchor)!)
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
        let studentCollectionView = StudentCollectionViewController(collectionViewLayout: .init())
        studentCollectionView.navigationItem.hidesBackButton = true
        studentCollectionView.student = student
        self.navigationController?.pushViewController(studentCollectionView, animated: true)
    }
    
    func homePressed() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
