//
//  NewsPageViewController.swift
//  TFSNews
//
//  Created by SHREDDING on 04.02.2023.
//

import UIKit

class NewsPageViewController: UIViewController {
    public var article:Article?
    public var numberOfVisit:Int?
    public var doAfterClose:((Int)->Void)?
    
    
    lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.frame = view.bounds
        scroll.contentSize = CGSize(width: view.frame.width, height: 100)
        
        
        return scroll
    }()
    
    var viewInsideScrollView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleArticle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30,weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let imageArticle:UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var descriptionArticle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    var dateOfPublish:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    
    var stackSourceAuthor:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .top
        return stack
    }()
    
    var sourceArticle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    var authorArticle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    var buttonShowArticle:UIButton = {
        
        let button = UIButton()
        button.setTitle("WatchCompletelyButton".localize(tableName: "Localize"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        
        return button
    }()
    
    let activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .darkGray
        indicator.startAnimating()
        return indicator
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationView()
        setViews()
        setConstraints()
        setImg()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        doAfterClose?(numberOfVisit!)
    }
    
    
    private func configurationView(){
        self.view.backgroundColor = UIColor(named: "Backround View")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:article!.publishedAt)!
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: date)
        let finaldate = calendar.date(from: components)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateText = dateFormatter.string(from: finaldate!)

        
        self.titleArticle.text = article?.title
        
        let boldTextDescription = "\("DescriptionLabel".localize(tableName: "Localize")): "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedString = NSMutableAttributedString(string:boldTextDescription, attributes:attrs)
        
        
        
        let normalText = article?.description ?? "NonePhraze".localize(tableName: "Localize")
        let normalString = NSMutableAttributedString(string:normalText)
        attributedString.append(normalString)
        
        self.descriptionArticle.attributedText = attributedString

        
        
        
        
        
        self.dateOfPublish.text = dateText
        self.sourceArticle.text = "\("SourceLabel".localize(tableName: "Localize")): \(article?.source.name ?? "NonePhraze".localize(tableName: "Localize"))"
        self.authorArticle.text = "\("AuthorLabel".localize(tableName: "Localize")): \(article?.author ?? "NonePhraze".localize(tableName: "Localize"))"
        
        self.buttonShowArticle.addTarget(self, action: #selector(tapShowArticle), for: .touchUpInside)
        
        
        AppDelegate.apiManager.setNumberOfvisit(keyUrl: article!.url, value: numberOfVisit! + 1)
        numberOfVisit! += 1
        
        
    }
    private func setViews(){
        
        self.view.addSubview(scrollView)
        
        self.view.addSubview(titleArticle)
        self.scrollView.addSubview(viewInsideScrollView)
        
        self.viewInsideScrollView.addSubview(imageArticle)
        
        
        self.viewInsideScrollView.addSubview(stackSourceAuthor)
        self.stackSourceAuthor.addSubview(sourceArticle)
        self.stackSourceAuthor.addSubview(authorArticle)
        
        self.viewInsideScrollView.addSubview(descriptionArticle)
        
        
        self.view.addSubview(dateOfPublish)
        self.view.addSubview(buttonShowArticle)
        self.imageArticle.addSubview(activityIndicator)
        
    }
    private func setConstraints(){
        
        
        // scroll view
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.dateOfPublish.bottomAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: self.buttonShowArticle.topAnchor, constant: -10),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            viewInsideScrollView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0),
            viewInsideScrollView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0),
            viewInsideScrollView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0),
            viewInsideScrollView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
            viewInsideScrollView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1)
        ])
        
        
        // Label
        NSLayoutConstraint.activate([
            titleArticle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleArticle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleArticle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
        
        // img
        NSLayoutConstraint.activate([
            imageArticle.topAnchor.constraint(equalTo: self.viewInsideScrollView.topAnchor, constant: 0),
            imageArticle.leadingAnchor.constraint(equalTo: self.viewInsideScrollView.leadingAnchor, constant: 10),
            imageArticle.trailingAnchor.constraint(equalTo: self.viewInsideScrollView.trailingAnchor, constant: -10),
            imageArticle.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        
        NSLayoutConstraint.activate([
            stackSourceAuthor.topAnchor.constraint(equalTo: self.imageArticle.bottomAnchor, constant: 5),
            stackSourceAuthor.leadingAnchor.constraint(equalTo: self.viewInsideScrollView.leadingAnchor, constant: 10),
            stackSourceAuthor.trailingAnchor.constraint(equalTo: self.viewInsideScrollView.trailingAnchor, constant: -10)
            
        ])
        
        
        NSLayoutConstraint.activate([
            sourceArticle.topAnchor.constraint(equalTo: self.stackSourceAuthor.topAnchor, constant: 0),
            sourceArticle.leadingAnchor.constraint(equalTo: self.stackSourceAuthor.leadingAnchor, constant: 0),
            sourceArticle.bottomAnchor.constraint(lessThanOrEqualTo: self.stackSourceAuthor.bottomAnchor, constant: 0),
            sourceArticle.widthAnchor.constraint(lessThanOrEqualTo: self.stackSourceAuthor.widthAnchor, multiplier: 0.49),
        ])

        NSLayoutConstraint.activate([
            authorArticle.topAnchor.constraint(equalTo: self.stackSourceAuthor.topAnchor, constant: 0),
            authorArticle.trailingAnchor.constraint(equalTo: self.stackSourceAuthor.trailingAnchor, constant: 0),
            authorArticle.bottomAnchor.constraint(lessThanOrEqualTo: self.stackSourceAuthor.bottomAnchor, constant: 0),
            authorArticle.widthAnchor.constraint(lessThanOrEqualTo: self.stackSourceAuthor.widthAnchor, multiplier: 0.49)

        ])
        
        NSLayoutConstraint.activate([
            descriptionArticle.topAnchor.constraint(equalTo: self.stackSourceAuthor.bottomAnchor, constant: 30),
            descriptionArticle.bottomAnchor.constraint(equalTo: self.viewInsideScrollView.bottomAnchor, constant: 0),
            descriptionArticle.leadingAnchor.constraint(equalTo: self.viewInsideScrollView.leadingAnchor, constant: 10),
            descriptionArticle.trailingAnchor.constraint(equalTo: self.viewInsideScrollView.trailingAnchor, constant: -10),
            
        ])
        
        NSLayoutConstraint.activate([
            dateOfPublish.topAnchor.constraint(equalTo: self.titleArticle.bottomAnchor, constant: 10),
            dateOfPublish.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
        ])
        
        
        
        NSLayoutConstraint.activate([
            buttonShowArticle.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            buttonShowArticle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            buttonShowArticle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.imageArticle.centerXAnchor, constant: 0),
            activityIndicator.centerYAnchor.constraint(equalTo: self.imageArticle.centerYAnchor, constant: 0)
        ])
    }
    private func setImg(){
        
        guard let urlString = article?.urlToImage  else {
            self.imageArticle.image = UIImage(named: "NEWS")
            self.activityIndicator.isHidden = true
            return }
        
        AppDelegate.apiManager.loadImg(urlStringInput: urlString) { UIImage in
            DispatchQueue.main.async {
                self.imageArticle.image = UIImage
                self.activityIndicator.isHidden = true
            }
        }
        
    }
    
    @objc func tapShowArticle(){
        
        let webVC = WebPresentationViewController()
        webVC.article = article
        webVC.modalPresentationStyle = .overCurrentContext
        self.present(webVC, animated: true)
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
