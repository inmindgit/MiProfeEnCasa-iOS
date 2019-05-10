//
//  ApiManager.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/2/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper
import SVProgressHUD

class ApiManager
{
    typealias ServiceResponse = (AnyObject?) -> Void

    let url = Constants.Backend.kUrl
    
    var parameters:[String:Any] = ["":""]
    var queryParameters : String = ""
    var serviceUrl:String = ""
    var image:UIImage?
    var countTries:Int = 0
    var responseIsArray:Bool = false
    let countRetry:Int = 2
    var albumId = ""
    var castingId = ""
    var showHud: Bool = true
   
    class var sharedInstance:ApiManager {
        struct Singleton {
            static let instance = ApiManager()
        }
        return Singleton.instance
    }
    
    func execute <T> (type: T.Type, operation:String, onCompletion: @escaping ServiceResponse)->Void where T:Mappable, T:Meta
    {
        var headers = [String:String]()
        headers = ["Content-Type":"application/x-www-form-urlencoded","AuthToken":"ApxnHCG/NmmqRN9NA+IHOKtsPj6I/UJlfw64mbW3nPjQ"]
        
     
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(UIColor(red: 255/255.0, green: 136.0/255.0, blue: 0/255.0, alpha: 1))
        SVProgressHUD.show()
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.executeHttpFunction(type: type, headers: headers, operation: operation, onCompletion: { (response:AnyObject?) in
            if(response != nil)
            {
                SVProgressHUD.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onCompletion(response)
            }
            else
            {
                SVProgressHUD.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onCompletion(response as! NSError?)
            }
        })
    }
    
    func executeHttpFunction <T> (type: T.Type, headers:[String:String], operation:String, onCompletion: @escaping ServiceResponse)->Void where T:Mappable, T:Meta
    {
        switch operation
        {
        case "get":
            self.get(type: type, headers: headers, onCompletion: { (response:AnyObject?) in
                if(response != nil)
                {
                    onCompletion(response)
                }
                else
                {
                    onCompletion(response as! NSError?)
                }
            })
            break
        case "post":
            self.post(type: type, headers: headers, onCompletion: { (response:AnyObject?) in
                
                if(response != nil)
                {
                    onCompletion(response)
                }
                else
                {
                    onCompletion(response as! NSError?)
                }
            })
            break
        case "put":
            self.put(type: type, headers: headers, onCompletion: { (response:AnyObject?) in
                
                if(response != nil)
                {
                    onCompletion(response)
                }
                else
                {
                    onCompletion(response as! NSError?)
                }
            })
            
            break
        case "delete":
            self.delete(type: type, headers: headers, onCompletion: { (response:AnyObject?) in
                
                if(response != nil)
                {
                    onCompletion(response)
                }
                else
                {
                    onCompletion(response as! NSError?)
                }
            })
            
            break
        default: break
        }
    }
    
    func get <T> (type: T.Type, headers:[String:String], onCompletion: @escaping ServiceResponse) where T:Mappable, T:Meta {
        
        var url = self.url + type.url()
        
        if(type.queryString() != "")
        {
            url = url + type.queryString()
        }
        
        if(type.expand() != "")
        {
            url = url + type.expand()
        }
        
        let getManager = Alamofire.request(url, method: .get, parameters: nil, headers: headers)
        getManager.validate()
        
        if(self.responseIsArray)
        {
            getManager.responseArray{ (response: DataResponse<[T]>) in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as AnyObject)
                case .failure(let error):
                    onCompletion(error as NSError?)
                }
                
            }
        }
   
            /*
            getManager.responseString { (response: DataResponse<String>) in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as AnyObject)
                case .failure(let error):
                    onCompletion(error as NSError?)
                }
            }
 */
        else
        {
            getManager.responseObject { (response: DataResponse<T>) in
            {
                switch response.result {
                case .success:
                    onCompletion(response.result.value as AnyObject)
                case .failure(let error):
                    onCompletion(error as NSError?)
                }
            }()
            }
    
        }
    }
    
    func post <T> (type: T.Type, headers:[String:String], onCompletion: @escaping ServiceResponse)->Void where T:Mappable, T:Meta {
        
        var url = self.url + type.url()
    
        if(type.queryString() != "")
        {
            url = url + type.queryString()
        }
        
        if(type.expand() != "")
        {
            url = url + type.expand()
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        
        let data = (self.queryParameters.addingPercentEncoding( withAllowedCharacters: .urlUserAllowed)!.data(using: .utf8))! as Data
       
        request.httpBody = data
        let postManager = Alamofire.request(request)
        postManager.validate()
        
        postManager.responseObject{ (response: DataResponse<T>) in
            switch response.result {
            case .success:
                onCompletion(response.result.value as AnyObject)
            case .failure(let error):
                onCompletion(error as NSError?)
            }
        }
    }
    
    func delete <T> (type: T.Type, headers:[String:String], onCompletion: @escaping ServiceResponse)->Void where T:Mappable, T:Meta {
        
        let url = self.url + type.url()
        let parameters = self.parameters
        let postManager = Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        postManager.validate()
        
        postManager.responseObject{ (response: DataResponse<T>) in
            switch response.result {
            case .success:
                onCompletion(response.result.value as AnyObject)
                
            case .failure(let error):
                onCompletion(error as NSError?)
            }
        }
    }
    
    func put <T> (type: T.Type, headers:[String:String], onCompletion: @escaping ServiceResponse)->Void where T:Mappable, T:Meta {
        
        var url = self.url + type.url()
        
        let parameters = self.parameters
        let postManager = Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        postManager.validate()
        
        postManager.responseObject{ (response: DataResponse<T>) in
            switch response.result {
            case .success:
                onCompletion(response.result.value as AnyObject)
            case .failure(let error):
                onCompletion(error as NSError?)
            }
        }
    }
}

