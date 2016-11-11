//
//  GetWebContentViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/22/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import WebKit

class GetWebContentViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var webView = UIWebView()
    let navBar = UINavigationBar()
    let urlTextField = UITextField()
    let toolbar = UIToolbar()
    var backButton = UIBarButtonItem()
    var forwardButton = UIBarButtonItem()
    var refreshButton = UIBarButtonItem()
    let progressView = UIProgressView()
    var userURL = URL(string: "")
    var webViewIsLoaded = false
    var loadTimer = Timer()
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    var selectedImageURL = String()
    
    let javaScript = "function GetImgSourceAtPoint(x,y) { var msg = ''; var e = document.elementFromPoint(x,y); while (e) { if (e.tagName == 'IMG') { msg += e.src; break; } e = e.parentNode; } return msg; }"
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(progressView)
        self.view.addSubview(webView)
        webView.delegate = self
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
        urlTextField.layer.borderColor = UIColor.lightGray.cgColor
        urlTextField.layer.borderWidth = 0.5
        
        // WebView Setup
        webView.scalesPageToFit = true
        let url = URL(string: "http://www.google.com")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
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
        
        // Long Press
        longPressGestureRecognizer.addTarget(self, action: #selector(longPressAction))
        longPressGestureRecognizer.delegate = self
        webView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        navBar.frame = CGRect(x: 0, y: 0, width: size.width, height: 60)
    }
    
    override func viewDidLayoutSubviews() {
        textFieldConstraints()
        progressViewConstraints()
        webViewConstraints()
        toolbarConstraints()
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
    
    func progressViewConstraints() {
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topConstraint = progressView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint])
    }
    
    
    func webViewConstraints() {
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = webView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topConstraint = webView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5)
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
    
    // MARK: WebView Delegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        progressView.isHidden = false
        progressView.progress = 0.0
        webViewIsLoaded = false
        loadTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
        updateButtons()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.urlTextField.text = webView.request?.url?.absoluteString
        webViewIsLoaded = true
        progressView.isHidden = true
        updateButtons()
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewIsLoaded = true
        progressView.isHidden = true
        updateButtons()
    }
    
    // MARK: Timer
    
    func timerCallBack() {
        if webViewIsLoaded == true {
            if progressView.progress >= 1 {
                loadTimer.invalidate()
            } else {
                progressView.progress += 0.1
            }
        } else {
            progressView.progress += 0.05
            if progressView.progress >= 0.95 {
                progressView.progress = 0.95
            }
        }
    }
    
    // MARK: TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        
        if var urlString = urlTextField.text {
            
            if urlString.contains(" ") {
                let searchString = urlString.replacingOccurrences(of: " ", with: "+")
                urlString = "google.com/search?q=\(searchString)"
            }
            
            let characterSet = "-0123456789."
            
            if !isAnyCharacter(from: characterSet, containedIn: urlString) {
                let searchString = urlString
                urlString = "google.com/search?q=\(searchString)"
            }
            
            let url = URL(string: urlString)
            
            if var url = url {
                
                if (url.scheme == nil) {
                    url = URL(string: "http://\(url)")!
                    userURL = url
                } else {
                    userURL = url
                }
                
                let request = URLRequest(url: userURL!)
                webView.loadRequest(request)
            }
        }
        
        return false
    }
    
    func isAnyCharacter(from characterSetString: String, containedIn string: String) -> Bool {
        return Set(characterSetString.characters).isDisjoint(with: Set(string.characters)) == false
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
    
    func updateButtons() {
        if webView.canGoBack {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
        
        if webView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
    }
    
    // Save Content
    
    func longPressAction(sender: UILongPressGestureRecognizer) {
        
        webView.stringByEvaluatingJavaScript(from: javaScript)
        
        if sender.state == UIGestureRecognizerState.recognized {
            let pressPosition = sender.location(in: webView)
            let src = webView.stringByEvaluatingJavaScript(from: "GetImgSourceAtPoint(\(pressPosition.x),\(pressPosition.y));")
            
            if src != "" {
                let saveContentVC = SaveContentViewController()
                saveContentVC.modalPresentationStyle = .formSheet
                self.present(saveContentVC, animated: true, completion: nil)
                
                print(src!)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
