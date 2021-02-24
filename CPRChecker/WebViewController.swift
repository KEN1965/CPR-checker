//
//  WebViewController.swift
//  CPR checker
//
//  Created by KEN on 2019/12/07.
//  Copyright © 2019 KEN. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    
    
    var topPadding:CGFloat = 0
    
//    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
//    let urlString = "https://apps.apple.com/jp/developer/kenichi-takahama/id1131089042"
//    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        // iPhone X , X以外は0となる
        if #available(iOS 11.0, *) {
            // 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            topPadding = window!.safeAreaInsets.top
        }
     
     // Webページの大きさを画面に合わせる
             let rect = CGRect(x: 0,
                               y: topPadding,
                               width: screenWidth,
                               height: screenHeight - topPadding)
             
             let webConfiguration = WKWebViewConfiguration()
             webView = WKWebView(frame: rect, configuration: webConfiguration)

             let webUrl = URL(string: "https://letstriage.jimdo.com")!
             let myRequest = URLRequest(url: webUrl)
             webView.load(myRequest)
        

             // インスタンスをビューに追加する
             self.view.addSubview(webView)
//        setIndicater()
//
//        webView.navigationDelegate = self
//
//        guard let url = URL(string: urlString) else { return }
//
//        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 100)
//
//        webView.load(urlRequest)
//        indicator.stopAnimating()
    }
    

//    func setIndicater() {
//
//         let indicator =  UIActivityIndicatorView()
//
//        indicator.hidesWhenStopped = true
//
//        indicator.style = .large
//        indicator.color = .black
//        indicator.startAnimating()
//
//        webView.addSubview(indicator)
//
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//
//        //インジケーターを回す
//        indicator.startAnimating()
//
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//
//        //インジケーターを止める
//        indicator.stopAnimating()
//        indicator.isHidden = true
////        indicator.hidesWhenStopped = false
//
//
//    }

}
