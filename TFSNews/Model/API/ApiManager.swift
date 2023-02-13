//
//  ApiManager.swift
//  TFSNews
//
//  Created by SHREDDING on 04.02.2023.
//

import Foundation
import UIKit

public class ApiManager{
    private var q = "Apple"
    private var page = 1
    private var apiKey = "336af83fb4984d00a08dae40fcca7ab0"
    private var  urlString = ""
    
    var imageCache = NSCache<NSString,UIImage>()
    var keysImages:[String] = []
    
    public let userDefaults = UserDefaults.standard
    
    func getNews(q:String,isNextPage:Bool, completion: @escaping (News?,Error?) -> Void){
        if isNextPage{
            self.page+=1
        }
        setQ(q: q)
        setUrlString()
        
        let url = URL(string: urlString)
        if url == nil{
            let error = Error(status: "ErorrWrongAlphabetStatus".localize(tableName: "Localize"), code: "ErorrWrongAlphabetCode".localize(tableName: "Localize"), message: "ErorrWrongAlphabetMsg".localize(tableName: "Localize"))
            completion(nil,error)
            return
        }
        let request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200{
                    do {
                        let error = try JSONDecoder().decode(Error.self, from: data)
                        completion(nil,error)
                        return
                        
                        
                    }catch let error{
                        print("ERROR: \(error)")
                    }
                }
            }
            
            do{
                let news = try JSONDecoder().decode(News.self, from: data)
                completion(news,nil)
            } catch let error{
                print("ERROR: \(error)")
            }

            
        }
        task.resume()
            
    }
    
    init() {
        setUrlString()
    }
    
    
    func loadImg(urlStringInput:String?, completion: @escaping (UIImage) -> Void){
        
        
        guard let urlString = urlStringInput, let url = URL(string:(urlString))  else { return }
        if let cachedImg = imageCache.object(forKey: url.absoluteString as NSString){
            completion(cachedImg)
        }else{
            
            URLSession.shared.dataTask(with: url) { [self] data, _, error in
                guard let data = data, error == nil, let img = UIImage(data: data) else{ return }
                
                
                self.imageCache.setObject(img, forKey: url.absoluteString as NSString)
                keysImages.append(url.absoluteString)
                
                
                completion(img)
                
            }.resume()
            
        }
    }
    
    
    func setNumberOfvisit(keyUrl:String,value:Int){
        
        userDefaults.set(value, forKey: keyUrl)
        
    }
    func getNumberOfVisit(keyUrl:String)->Int{
        if let number = userDefaults.object(forKey: keyUrl) as? Int{
            return number
        }
        return 0
    }
    
    private func setUrlString(){
        urlString = "https://newsapi.org/v2/everything?q='\(q)'&pageSize=20&page=\(page)&apiKey=\(apiKey)"
    }
    
    private func setQ(q:String){
        self.q = q.replacingOccurrences(of: " ", with: "+")
        if q == ""{
            self.q = "Apple"
        }
    }
}

