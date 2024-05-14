//
//  Post.swift
//  EvilNewsCorp
//
//  Created by Rihab Mehboob on 13/05/2024.
//

import Foundation

// Latest articles
func postRequest(completion: @escaping (EvilDataNamespace.EvilData?, Error?) -> Void) {
    
    let url = URL(string: "https://scheck.swipeandtap.co.uk/api/articles/latest?auth_token=LKjXmLlBmcMGdDOC")!
    
    //create the session object
    let session = URLSession.shared
    
    //now create the Request object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = "POST" //set http method as POST
    
    //HTTP Header
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request, completionHandler: { data, response, error in
        
        guard error == nil else {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let EvilData = try decoder.decode(EvilDataNamespace.EvilData.self, from: data)
            print("Decoded EvilData object:", EvilData)
            completion(EvilData, nil)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
    })
    
    task.resume()
}

// Specific article
func postRequest(id: Int, completion: @escaping (EvilArticleDataNamespace.EvilArticleData?, Error?) -> Void) {
    
    let url = URL(string: "https://scheck.swipeandtap.co.uk/api/articles/\(id)?auth_token=LKjXmLlBmcMGdDOC")!
    
    //create the session object
    let session = URLSession.shared
    
    //now create the Request object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = "POST" //set http method as POST
    
    //HTTP Header
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request, completionHandler: { data, response, error in
        
        guard error == nil else {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let EvilData = try decoder.decode(EvilArticleDataNamespace.EvilArticleData.self, from: data)
            print("Decoded EvilData object:", EvilData)
            completion(EvilData, nil)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
    })
    
    task.resume()
}
