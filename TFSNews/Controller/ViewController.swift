//
//  ViewController.swift
//  TFSNews
//
//  Created by SHREDDING on 04.02.2023.
//

import UIKit
import Network

class ViewController: UIViewController {
    var news:News?
    var q:String?
    
    var articles:[Article]?
    
    var articlesStringLabel:String?
    var articlesStringLabel2:String?
    
    
    
    // MARK: - View elements
    
    let tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let textField:UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "keywoardsPlaceholder".localize(tableName: "Localize")
        return textField
    }()
    
    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26)
        label.numberOfLines = 0
        return label
    }()
    
    let activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .darkGray
        indicator.startAnimating()
        return indicator
    }()
    
    let buttonMore:UIButton = {
        let button = UIButton()
        button.setTitle("LoadMoreButton".localize(tableName: "Localize"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    let buttonClear:UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let refreshControll:UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setViews()
        configurationView()
        setConstraints()
        
        setValuesTableView(q: "Apple",isNextPage: false)
    }
    
    private func setValuesTableView(q:String,isNextPage:Bool){        
        AppDelegate.apiManager.getNews(q:q,isNextPage: isNextPage) { [weak self] news, err  in
            
            if err != nil{
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "\(err!.status): \(err!.code)", message: err?.message, preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "Ok", style: .default)
                    alertController.addAction(alertAction)
                    self!.present(alertController, animated: true)
                }
                return
            }
            
            DispatchQueue.main.async { [self] in
                guard let self else { return }
                
                self.news = news
                if isNextPage{
                    self.articles?.append(contentsOf: news!.articles)
                }else{
                    self.articles = news?.articles
                }

                self.tableView.reloadData()
                self.setLabel(text: q, totalResults: self.news!.totalResults)
                
                self.activityIndicator.isHidden = true
                
                if let count = self.articles?.count {
                    if count >= news!.totalResults{
                        self.buttonMore.isHidden = true
                    }else{
                        self.buttonMore.isHidden = false
                    }
                }
            }
        }
       
    }
    
    private func configurationView(){
        self.view.backgroundColor = UIColor(named: "Backround View")
        self.title = "NewsTitle".localize(tableName: "Localize")
        self.q = "Apple"
        tableView.delegate = self
        tableView.dataSource = self
        refreshControll.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        tableView.refreshControl = refreshControll
        
        textField.delegate = self
        if let count = articles?.count {
            if count >= news!.totalResults{
                buttonMore.isHidden = true
            }
        }else{
            buttonMore.isHidden = false
        }
        buttonMore.addTarget(self, action: #selector(tapShowMore), for: .touchUpInside)
        
        buttonClear.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
    }
    
    private func setViews(){
        self.view.addSubview(tableView)
        self.view.addSubview(textField)
        self.view.addSubview(label)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(buttonMore)
        self.view.addSubview(buttonClear)
        
    }
    
    private func setConstraints(){
        // table View constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10),
             tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
             tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
             
            ])
        
        // textField constrains
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: self.buttonClear.leadingAnchor, constant: 0),
        ])
        NSLayoutConstraint.activate([
            buttonClear.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            buttonClear.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
        // сколько стаей показано
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
        
        // activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            buttonMore.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20),
            buttonMore.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            buttonMore.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            buttonMore.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    
    @objc func tapShowMore(){
        setValuesTableView(q: self.q! ,isNextPage: true)
    }
    
    @objc func refreshArticles(){
        setValuesTableView(q: self.q! , isNextPage: false)
        refreshControll.endRefreshing()
    }
    @objc func clearTextField(){
        textField.text = ""
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (articles?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nib = UINib(nibName: "PreviewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PreviewTableViewCell")
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewTableViewCell", for: indexPath) as! PreviewTableViewCell
        cell.titleOutlet.text = articles?[indexPath.row].title
        
        getImg(indexPath: indexPath)
        if (articles?[indexPath.row].urlToImage) == nil{
            cell.imageOutlet.image = UIImage(named: "NEWS Preview")
        }
        
        cell.imageOutlet.layer.cornerRadius = 50
        
        cell.numberOfVisit.text = "\("VisitsLabel".localize(tableName: "Localize")): \(String(AppDelegate.apiManager.getNumberOfVisit(keyUrl:(articles?[indexPath.row].url)!)))"
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newsPageVC = NewsPageViewController()
        newsPageVC.article = articles![indexPath.row]
        newsPageVC.numberOfVisit = AppDelegate.apiManager.getNumberOfVisit(keyUrl:(articles?[indexPath.row].url)!)
        
        newsPageVC.doAfterClose = { numberOfVisit in
            (tableView.cellForRow(at: indexPath) as! PreviewTableViewCell).numberOfVisit.text = "\("VisitsLabel".localize(tableName: "Localize")): \(numberOfVisit)"
        }
        
        textField.resignFirstResponder()
        
        self.navigationController?.pushViewController(newsPageVC, animated: true)
    }
    
    private func getImg(indexPath:IndexPath){
        
        guard let urlString = articles?[indexPath.row].urlToImage else { return }
        
        AppDelegate.apiManager.loadImg(urlStringInput: urlString) { UIImage in
            DispatchQueue.main.async {
                if let cell = self.tableView.cellForRow(at: indexPath){
                    (cell as! PreviewTableViewCell).imageOutlet.image = UIImage
                }
            }
        }
        
    }
}

extension ViewController:UITextFieldDelegate{
    
    
    fileprivate func getLastNumberTotalResult(_ totalResults: Int) {
        let lastNumber:Int = totalResults % 10
        
        switch lastNumber{
        case 0:
            self.articlesStringLabel = "cтатей"
            self.articlesStringLabel2 = "найдено"
        case 1:
            self.articlesStringLabel = "cтатья"
            self.articlesStringLabel2 = "найдена"
        case 2...4:
            self.articlesStringLabel = "cтатьи"
            self.articlesStringLabel2 = "найдены"
        case 5...9:
            self.articlesStringLabel = "cтатей"
            self.articlesStringLabel2 = "найдено"
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != ""{
            self.q = textField.text
            setValuesTableView(q: self.q! ,isNextPage: false)
            let totalResults = self.news!.totalResults
            
            getLastNumberTotalResult(totalResults)
        }else{
            
            let alertController = UIAlertController(title: "EmptyRequestTitle".localize(tableName: "Localize"), message: "EmptyRequestMsg".localize(tableName: "Localize"), preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true)
        }
        
        return true
    }
    
    
    private func setLabel(text:String,totalResults:Int){
        getLastNumberTotalResult(totalResults)
        UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve) {
            
            let locale = NSLocale.preferredLanguages.first
            if locale!.hasPrefix("ru"){
                self.label.text = "По запросу '\(text)' \(self.articlesStringLabel2!) \(totalResults) \(self.articlesStringLabel!)"
            }else{
                self.label.text = "\(totalResults) articles were found on the request '\(text)'"
                        }
            }
    }
}

