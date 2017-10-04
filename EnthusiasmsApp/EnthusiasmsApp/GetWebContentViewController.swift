//
//  GetWebContentViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/22/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import YouTubePlayer
import CoreData

enum ContentType: Int16 {
    case Image = 1
    case Video = 2
}

class GetWebContentViewController: UIViewController, DownloadableImage {
    
    var webView = UIWebView()
    let progressView = UIProgressView()
    var webViewIsLoaded = false
    var loadTimer = Timer()
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    var student: Student?
    var contentType: ContentType?
    var contentURL: URL?
    
    lazy var saveContentViewController: SaveContentViewController = {
        let saveContentVC = SaveContentViewController(student: self.student)
        saveContentVC.delegate = self
        saveContentVC.modalPresentationStyle = .formSheet
        return saveContentVC
    }()
    
    lazy var imageGetter: ImageGetter = {
        return ImageGetter()
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
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(alertForImageError(notification:)), name: NSNotification.Name(rawValue: "ErrorSavingImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alertForImageError(notification:)), name: NSNotification.Name(rawValue: "ErrorDownloadingImage"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ErrorSavingImage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ErrorDownloadingImage"), object: nil)
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
    
    // MARK: Gesture
    
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        
        webView.stringByEvaluatingJavaScript(from: getImageJavaScript)
        
        if sender.state == UIGestureRecognizerState.recognized {
            
            if let urlRequest = webView.request, let contentURL = urlRequest.url {
                
                if let _ = videoIDFromYouTubeURL(contentURL) {
                    
                    self.contentURL = contentURL
                    contentType = ContentType.Video
                    present(saveContentViewController, animated: true, completion: nil)
                    
                } else {
                    
                    let point = sender.location(in: webView)
                    let imageSRC = webView.stringByEvaluatingJavaScript(from: "GetImgSourceAtPoint(\(point.x),\(point.y));")
        
                    if imageSRC != "" {
                        self.contentURL = URL(string: imageSRC!)
                        contentType = ContentType.Image
                        present(saveContentViewController, animated: true, completion: nil)
                    }
                    
                }
            }
            
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

// MARK: - SaveContentViewControllerDelegate

extension GetWebContentViewController: saveContentViewControllerDelegate {
    
    func saveContent() {
        
        guard let newContent = NSEntityDescription.insertNewObject(forEntityName: "Content", into: DataController.sharedInstance.managedObjectContext) as? Content, let contentType = contentType, let contentURL = contentURL else {
            presentAlert(withTitle: "Whoops!", andMessage: "Something went wrong.", dismissSelf: false)
            return
        }
        
        let contentURLString = contentURL.absoluteString
        
        newContent.title = saveContentViewController.contentTitle
        newContent.url = contentURLString
        newContent.type = contentType.rawValue
        newContent.dateAdded = NSDate()
        
        if let student = student {
            newContent.addToStudentContent(student)
        }
        
        DataController.sharedInstance.saveContext()
        
        // Download ContentImage
        
        if contentType == .Image {
            saveImageFrom(url: contentURL, forContent: newContent)
        }
        
        if contentType == .Video {
           
            guard let videoID = videoIDFromYouTubeURL(contentURL) else {
                presentAlert(withTitle: "Oops", andMessage: "There was an error saving the video", dismissSelf: false)
                return
            }
            
            let thumbnailString = thumbnailURLString(videoID: videoID)
            
            guard let thumbnailURL = URL(string: thumbnailString) else {
                return
            }
            
            newContent.thumbnailURL = thumbnailString
            saveImageFrom(url: thumbnailURL, forContent: newContent)
        }
        
        // Reset contentType and urlString for next content
        self.contentType = nil
        self.contentURL = nil
    }
    
    @objc func alertForImageError(notification: NSNotification) {
        if let userInfo = notification.userInfo, let message = userInfo["message"] as?  String {
            presentAlert(withTitle: "Uh oh!", andMessage: message, dismissSelf: false)
        }
    }
}
