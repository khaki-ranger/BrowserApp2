//
//  ViewController.swift
//  BrowserApp2
//
//  Created by 寺島 洋平 on 2019/02/13.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var browserWebView: UIWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var browserActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.browserWebView.delegate = self
        self.urlTextField.delegate = self
        self.browserActivityIndicatorView.hidesWhenStopped = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // テキストフィールドにフォーカスしてリターンキーが押された時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != self.urlTextField {
            return true
        }
        if let urlString = textField.text {
            self.loadUrl(urlString: urlString)
        }
        return true
    }
    
    // テキストフィールドがタップされた時の処理
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != self.urlTextField {
            return
        }
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    // サイトのロード中の処理
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.browserActivityIndicatorView.startAnimating()
    }
    
    // サイトのロードが完了した後の処理
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let urlString = self.browserWebView.request?.url?.absoluteString {
            self.urlTextField.text = urlString
        }
        self.browserActivityIndicatorView.stopAnimating()
        self.backButton.isEnabled = self.browserWebView.canGoBack
        self.forwardButton.isEnabled = self.browserWebView.canGoForward
    }
    
    // View が表示された後の処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString = "https://dotinstall.com"
//        let urlString = ""
        self.loadUrl(urlString: urlString)
        self.addBoader()
    }
    
    // webView の上に線を表示
    func addBoader() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.browserWebView.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        self.browserWebView.layer.addSublayer(topBorder)
    }
    
    // アラートを表示
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // urlString が正しい値かどうかチェック
    func getValidatedUrl(urlString: String) -> URL? {
        if URL(string: urlString) == nil {
            showAlert("Invalid URL")
            return nil
        }
        return URL(string: appendScheme(urlString))
    }
    
    // http などのスキームが入力されているかどうかチェックする
    func appendScheme(_ urlString: String) -> String {
        if URL(string: urlString)?.scheme == nil {
            return "http://" + urlString
        }
        return urlString
    }
    
    // webView にサイトを表示
    func loadUrl(urlString: String) {
        if let url = self.getValidatedUrl(urlString: urlString) {
            let urlRequest = URLRequest(url: url)
            self.browserWebView.loadRequest(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(_ sender: Any) {
        self.browserWebView.goBack()
    }
    @IBAction func goForward(_ sender: Any) {
        self.browserWebView.goForward()
    }
    @IBAction func reload(_ sender: Any) {
        self.browserWebView.reload()
    }
    
}

