//
//  WebMoreInfoViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

// Imports
import UIKit
import WebKit

class WebMoreInfoViewController: UIViewController, WKUIDelegate {

    @IBOutlet var mWebView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeb()
    }
    
    // Set up and load web request
    func setupWeb() {
        let pageURL = URL(string: "https://www.cancer.ca/en/cancer-information/diagnosis-and-treatment/managing-side-effects/anemia/?region=on") // Create URL
        let requestObj = URLRequest(url: pageURL!) // Create Request to fetch page
        mWebView.load(requestObj) // Load into WebView
    }
    
    // Customize or configure web view appearance
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        mWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        mWebView.uiDelegate = self
        view = mWebView
    }
}
