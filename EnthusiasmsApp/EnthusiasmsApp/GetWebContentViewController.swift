//
//  GetWebContentViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/22/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import YouTubePlayer

enum ContentType: Int16 {
    case Image = 1
    case Video = 2
}

class GetWebContentViewController: UIViewController {
    
    var webView = UIWebView()
    let progressView = UIProgressView()
    var webViewIsLoaded = false
    var loadTimer = Timer()
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    var student: Student?
    var contentType: ContentType?
    
    lazy var saveContentViewController: SaveContentViewController = {
        return SaveContentViewController(student: self.student)
    }()
    
    lazy var urlTextField: UITextField = {
        
        let indentedTextField = IndentedTextField(placeHolder: nil, isSecureEntry: false, tag: nil)
        let textField = indentedTextField.textField
        textField.keyboardType = .URL
        textField.returnKeyType = .go
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        self.view.addSubview(textField)
        textField.text = "http://www.google.com"
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        
        return textField
        
    }()
    
    
    lazy var backButton : UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backPressed))
        return button
        
    }()
    
    lazy var forwardButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(forwardPressed))
        return button
        
    }()
    
    lazy var refreshButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPressed))
        return button
        
    }()
    
    lazy var toolbar: UIToolbar = {
        
        let bar = UIToolbar()
        self.view.addSubview(bar)
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpaceItem.width = 10
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([self.backButton, fixedSpaceItem, self.forwardButton, flexibleSpace, self.refreshButton], animated: true)
        self.backButton.isEnabled = false
        self.forwardButton.isEnabled = false
        return bar
        
    }()
    
    let getImageJavaScript = "function GetImgSourceAtPoint(x,y) { var msg = ''; var e = document.elementFromPoint(x,y); while (e) { if (e.tagName == 'IMG') { msg += e.src; break; } e = e.parentNode; } return msg; }"
    
    convenience init(student: Student?) {
        self.init(nibName: nil, bundle: nil)
        self.student = student
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(progressView)
        self.view.addSubview(webView)
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    
        navBarSetup()

        // WebView Setup
        webView.scalesPageToFit = true
        let url = URL(string: "http://www.google.com")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        // Long Press
        longPressGestureRecognizer.addTarget(self, action: #selector(longPressAction))
        longPressGestureRecognizer.delegate = self
        webView.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    func navBarSetup() {
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        navigationItem.rightBarButtonItem = cancelButton
        let helpButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(helpPressed))
        navigationItem.leftBarButtonItem = helpButton

        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        textFieldConstraints()
        progressViewConstraints()
        webViewConstraints()
        toolbarConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        UIMenuController.shared.menuItems = nil
        webView.loadHTMLString("", baseURL: nil)
    }
    
    // MARK: View Setup

    func textFieldConstraints() {
        
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        
        NSLayoutConstraint.activate([
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            urlTextField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 5),
            urlTextField.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    func progressViewConstraints() {
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor)
            ])
    }
    
    
    func webViewConstraints() {
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5),
            webView.bottomAnchor.constraint(equalTo: toolbar.topAnchor)
            ])
    }
    
    func toolbarConstraints() {
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: webView.bottomAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    // MARK: Timer
    
    @objc func timerCallBack() {
        
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
    
    // MARK: BarButtonItem Actions
    
    @objc func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func helpPressed() {
        let helpViewController = WebViewHelpViewController()
        helpViewController.modalPresentationStyle = .formSheet
        self.present(helpViewController, animated: true, completion: nil)
    }
    
    @objc func backPressed() {
        webView.goBack()
    }
    
    @objc func forwardPressed() {
        webView.goForward()
    }
    
    @objc func refreshPressed() {
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
    
    // MARK: Save Content
    
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        
        webView.stringByEvaluatingJavaScript(from: getImageJavaScript)
        
        if sender.state == UIGestureRecognizerState.recognized {
            
        }
    }
}

// MARK: UIWebViewDelegate

extension GetWebContentViewController: UIWebViewDelegate {
    
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
        
        // Disable user text selection
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        webViewIsLoaded = true
        progressView.isHidden = true
        updateButtons()
        
    }
    
}

 // MARK: TextField Delegate

extension GetWebContentViewController: UITextFieldDelegate {
    
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
            
            var userURL = URL(string: "")
            let url = URL(string: urlString)
            
            if var url = url {
                
                if (url.scheme == nil) {
                    
                    url = URL(string: "https://\(url)")!
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

}

// MARK: - GestureRecognizerDelegate

extension GetWebContentViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
