//
//  WebMoreInfoViewController.swift
//  Fe
//
//  Created by Jayce Merinchuk on 2021-02-25.
//

//MARK: Imports
import UIKit
import WebKit

/*------------------------------------------------------------------------
 //MARK: WebMoreInfoViewController : UIViewController, WKUIDelegate
 - Description: Showss the Web Page for Canadian Cancer Society
 -----------------------------------------------------------------------*/
class WebMoreInfoViewController: UIViewController, WKUIDelegate {
    
    // UI Variables
    @IBOutlet var mWebView: WKWebView!
    
    /*--------------------------------------------------------------------
     //MARK: viewDidLoad()
     - Description: Set up screen before showing it
     -------------------------------------------------------------------*/
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeb()
    }
    
    /*--------------------------------------------------------------------
     //MARK: setupWeb()
     - Description: Setup and load web request
     -------------------------------------------------------------------*/
    func setupWeb() {
        let pageURL = URL(string: "https://www.cancer.ca/en/cancer-information/diagnosis-and-treatment/managing-side-effects/anemia/?region=on") // Create URL
        let requestObj = URLRequest(url: pageURL!) // Create Request to fetch page
        mWebView.load(requestObj) // Load into WebView
    }
    
    /*--------------------------------------------------------------------
     //MARK: loadView()
     - Description: Customize and configure web view appearance
     -------------------------------------------------------------------*/
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        mWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        mWebView.uiDelegate = self
        view = mWebView
    }
}
