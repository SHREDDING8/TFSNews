//
//  WebPresentationViewController.swift
//  TFSNews
//
//  Created by SHREDDING on 05.02.2023.
//

import UIKit
import WebKit

class WebPresentationViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    public var article:Article?
    
    let toolBar:UIToolbar = {
        let bar = UIToolbar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        
        return bar
    }()
    
    
    let webKit:WKWebView = {
        let webUi = WKWebView()
        webUi.backgroundColor = UIColor(named: "Backround View")
        
        webUi.translatesAutoresizingMaskIntoConstraints = false
        return webUi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setViews()
        setConstraints()
        startSession()
        // Do any additional setup after loading the view.
    }
    
    private func configureView(){
        self.view.backgroundColor = UIColor(named: "Backround View")
        webKit.uiDelegate = self
        
        
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        
        let flexFix = UIBarButtonItem(systemItem: .fixedSpace)
        flexFix.width = 10
        
        let flex = UIBarButtonItem(systemItem: .flexibleSpace)
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back))
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: self, action: #selector(forward))
        
        reloadButton.tintColor = .systemGray
        back.tintColor = .systemGray
        forward.tintColor = .systemGray
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        toolBar.setItems([reloadButton,flexFix,back,flexFix,forward,flex,close], animated: true)
    }
    
    private func setViews(){
        self.view.addSubview(webKit)
        self.view.addSubview(toolBar)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            webKit.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webKit.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            webKit.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            toolBar.topAnchor.constraint(equalTo: self.webKit.bottomAnchor, constant: 0),
            toolBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            toolBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            toolBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
    }
    
    private func startSession(){
        guard let urlString = article?.url, let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        
        webKit.load(request)
        
        
        
        
    }
    
    
    @objc func close(){
        self.dismiss(animated: true)
    }
    @objc func reload(){
        self.webKit.reload()
    }
    @objc func forward(){
        self.webKit.goForward()
    }
    @objc func back(){
        self.webKit.goBack()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
