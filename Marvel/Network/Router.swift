//
//  Router.swift
//  Marvel
//
//  Created by prog_zidane on 12/2/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ResourceType{
    case comics(id:Int)
    case stories(id:Int)
    case series(id:Int)
    case events(id:Int)
}
class Router{
    
    //MARK:- singltone shered instance
    static let shared = Router()
    private init(){
        
    }
    //MARK:- network request variable
    var request:DataRequest?
    
    //MARK:- Fetch search result from the API
    func fetchCharacters(name:String = "",offset:Int = 0, _ completion:@escaping(_ status:Bool, _ charactersData:CharactersData?)->()){
        /* 1 - API method arguments */
        let paramters = Commons.refactoringParamtersAndUrls(name: name, page: offset, resourceType: nil )
        /* 2 - API request */
        request = Alamofire.SessionManager.default.request(paramters.1, method: .get,parameters: paramters.0, encoding: URLEncoding.default)
            .responseJSON { (response) in
                
                
                switch response.result{
                case  .failure(let error):
                    print("loadc",error.localizedDescription)
                    completion(false,nil)
                case .success:
                    let decoder = JSONDecoder()
                    do {
                        //decode json with codable protocol
                        let responseModel = try decoder.decode(MarvelCharctersModel.self, from: response.data!)
                        //safe unwraping character model with guard
                        guard let charctersData = responseModel.data,responseModel.code == 200 else {
                            completion(false,nil)
                            return
                        }
                        //return with success and charctersData model
                        completion(true,charctersData)
                        return
                    }catch{
                        print("loadc",error.localizedDescription)
                        completion(false,nil)
                    }
                }
                
        }
        
    }
    
    //MARK:- Fetch resource Image url result from the API
    func fetchImageUrl(resourceType:ResourceType?,_ completion:@escaping(_ status:Bool, _ url:String?)->()){
        /* 1 - API method arguments */
        let paramters = Commons.refactoringParamtersAndUrls(name: nil, page: 0, resourceType: resourceType)
        
        /* 2 - API request */
        request = Alamofire.SessionManager.default.request(paramters.1, method: .get,parameters: paramters.0, encoding: URLEncoding.default)
            .responseJSON { (response) in
                switch response.result{
                case  .failure:
                    completion(false,nil)
                case .success:
                    let decoder = JSONDecoder()
                    do {
                        //decode json with codable protocol
                        let responseModel = try decoder.decode(ItemImage.self, from: response.data!)
                        //safe unwraping photo model with guard
                        guard let resourceData = responseModel.data,responseModel.code == 200 else {
                            completion(false,nil)
                            return
                        }
                        guard let url = resourceData.results?.first?.thumbnail?.url else {
                            completion(false,nil)
                            return
                        }
                        //return with success and url
                        completion(true,url)
                        return
                    }catch{
                        print(error.localizedDescription)
                        completion(false,nil)
                    }
                }
                
        }


    }
    
    //MARK: - Cancel all previous tasks
    func cancelCurrentTask(){
        if request != nil {
            request?.cancel()
        }
        
    }
}
