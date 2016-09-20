//
//  ViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var studentButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func teacherPressed(_ sender: AnyObject) {
        
        let studentListNavController = self.storyboard?.instantiateViewController(withIdentifier: "studentListNavController") as! UINavigationController
        
        self.present(studentListNavController, animated: true, completion: nil)
    }

    @IBAction func studentPressed(_ sender: AnyObject) {
        let studentList = StudentListPopover(nibName: nil, bundle: nil)
        studentList.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = studentList.popoverPresentationController! as UIPopoverPresentationController
        popover.sourceView = self.studentButton
        self.present(studentList, animated: true, completion: nil)
    }
}

