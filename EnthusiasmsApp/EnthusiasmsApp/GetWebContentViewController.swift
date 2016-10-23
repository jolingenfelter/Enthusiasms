//
//  GetWebContentViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/22/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import WebKit

class GetWebContentViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    
    var webView = WKWebView()
    let navBar = UINavigationBar()
    let urlTextField = UITextField()
    let barView = UIView()
    
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(webView)
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WebView Setup
        let url = URL(string: "http://www.google.com")
        let request = URLRequest(url: url!)
        self.webView.load(request)
        
        // NavBar Setup
        navBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 60)
        view.addSubview(navBar)
        
        // barView Setup
        barView.backgroundColor = UIColor.white
        
        // TextField Setup
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .go
        urlTextField.autocorrectionType = .no
        urlTextField.clearButtonMode = .whileEditing
        urlTextField.delegate = self
        view.addSubview(urlTextField)
        urlTextField.backgroundColor = UIColor.white
        urlTextField.layer.cornerRadius = 5
        urlTextField.layer.masksToBounds = true
        urlTextField.text = "http://www.google.com"
        let inset = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: urlTextField.frame.height))
        urlTextField.leftView = inset
        urlTextField.leftViewMode = .always
        urlTextField.autocapitalizationType = .none
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        navBar.frame = CGRect(x: 0, y: 0, width: size.width, height: 60)
    }
    
    override func viewDidLayoutSubviews() {
        textFieldConstraints()
        webViewConstraints()
    }
    
    // MARK: View Setup
    
    func textFieldConstraints() {
        
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
        let trailingConstraint = urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        let topConstraint = urlTextField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 5)
        let heightConstraint = urlTextField.heightAnchor.constraint(equalToConstant: 30)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, heightConstraint])
    }
    
    func webViewConstraints() {
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = webView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topConstraint = webView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 5)
        let bottomConstraint = webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    // MARK: TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        if var url = urlTextField.text {
            if url.contains("http://") == false {
                let website = url
                url = "http://\(website)"
            }
            
            urlTextField.text = url
            webView.load(URLRequest(url: URL(string: url)!))
        }
        
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
