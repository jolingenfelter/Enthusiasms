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
    var student: Student?
    var contentType: ContentType?
    
    let getImageJavaScript = "function GetImgSourceAtPoint(x,y) { var msg = ''; var e = document.elementFromPoint(x,y); while (e) { if (e.tagName == 'IMG') { msg += e.src; break; } e = e.parentNode; } return msg; }"
    
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
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        navItem.rightBarButtonItem = cancelButton
        let helpButton = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(helpPressed))
        navItem.leftBarButtonItem = helpButton
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
        
        // Context Menu
        let saveVideoURLMenuItem = UIMenuItem(title: "Save Video URL", action: #selector(saveVideoURL))
        UIMenuController.shared.menuItems = [saveVideoURLMenuItem]
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIMenuController.shared.menuItems = nil
    }
    
    // MARK: View Setup

    func textFieldConstraints() {
        
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func helpPressed() {
        let helpViewController = WebViewHelpViewController()
        helpViewController.modalPresentationStyle = .formSheet
        self.present(helpViewController, animated: true, completion: nil)
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
    
    // MARK: Save Content
    
    // Save Image
    
    func longPressAction(sender: UILongPressGestureRecognizer) {
        
        webView.stringByEvaluatingJavaScript(from: getImageJavaScript)
        
        if sender.state == UIGestureRecognizerState.recognized {
            let pressPosition = sender.location(in: webView)
            let imageSRC = webView.stringByEvaluatingJavaScript(from: "GetImgSourceAtPoint(\(pressPosition.x),\(pressPosition.y));")
            
            if imageSRC != "" {
                let saveContentVC = SaveContentViewController()
                saveContentVC.modalPresentationStyle = .formSheet
                saveContentVC.student = student
                saveContentVC.contentURL = imageSRC
                saveContentVC.contentType = ContentType.Image
                self.present(saveContentVC, animated: true, completion: nil)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Save Video URL
    
    func saveVideoURL() {
        let saveContentVC = SaveContentViewController()
        saveContentVC.modalPresentationStyle = .formSheet
        saveContentVC.student = student
        
        guard let urlRequest = webView.request, let contentURL = urlRequest.url else {
            return
        }
        
        let contentURLString = contentURL.absoluteString
    
        saveContentVC.contentURL = contentURLString
        saveContentVC.contentType = ContentType.Video
        
        let videoID = videoIDFromYouTubeURL(contentURL)
        saveContentVC.youtubeVideoID = videoID
        
        self.present(saveContentVC, animated: true, completion: nil)
    }
}
