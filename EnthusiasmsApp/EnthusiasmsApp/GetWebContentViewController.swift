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
    let toolbar = UIToolbar()
    var backButton = UIBarButtonItem()
    var forwardButton = UIBarButtonItem()
    var refreshButton = UIBarButtonItem()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(webView)
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // NavBar Setup
        navBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 60)
        view.addSubview(navBar)
        let navItem = UINavigationItem()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        navItem.rightBarButtonItem = cancelButton
        navBar.items = [navItem]
        
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
        
        // WebView Setup
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        let url = URL(string: "http://www.google.com")
        let request = URLRequest(url: url!)
        self.webView.load(request)
        
        // Toolbar Setup
        view.addSubview(toolbar)
        backButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backPressed))
        forwardButton = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(forwardPressed))
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPressed))
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpaceItem.width = 10
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([backButton, fixedSpaceItem, forwardButton, flexibleSpace, refreshButton], animated: true)
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        navBar.frame = CGRect(x: 0, y: 0, width: size.width, height: 60)
    }
    
    override func viewDidLayoutSubviews() {
        textFieldConstraints()
        webViewConstraints()
        toolbarConstraints()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "loading", context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let bottomConstraint = webView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    func toolbarConstraints() {
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topConstraint = toolbar.topAnchor.constraint(equalTo: webView.bottomAnchor)
        let bottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
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
    
    // MARK: BarButtonItem Actions
    
    func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func backPressed() {
        webView.goBack()
    }
    
    func forwardPressed() {
        webView.goForward()
    }
    
    func refreshPressed() {
        webView.reload()
    }
}
