//
//  NetworkTool.swift
//  Tennis
//
//  Created by seasong on 16/5/12.
//  Copyright © 2016年 seasong. All rights reserved.
//
import Alamofire

enum NetworkTool {
    
    case Login(phoenNumber: String, password: String)
    case AddSite(siteName: String)
    case SubmitSitePhoto(placeId: String, imageArray: Array<UIImage>)
    

    private static let shopid = NSUserDefaults.standardUserDefaults().valueForKey("userId") as! String
    
    func getResult(completion: (NSDictionary?, String?) -> Void) {
        var method: Alamofire.Method!
        var url: String!
        var params: [String:AnyObject]!
        
        let defaultError = "服务器出错"
        var result: NSDictionary!
        switch self {
        //登录
        case .Login(phoenNumber: let pn, password: let pw):
            method = .GET
            url = "http://172.27.40.2:8080/Tennis/ShopServlet"
            params = [
                "phone":pn,
                "password":pw,
                "flag":"login"
            ]
            //连接网络
            Alamofire.request(method, url, parameters: params).validate().responseJSON { response in
                
                print("**********************")
                print(response)
                print("**********************")
                
                switch response.result {
                case .Success(let date):
                    result = date as! NSDictionary
                    completion(result, nil)
                    return
                case .Failure:
                    completion(nil, defaultError)
                    return
                }
            }
            
        //添加场地（场地名）
        case .AddSite(siteName: let placeName):
            method = Method.POST
            url = "http://172.27.40.2:8080/Tennis/PlaceServlet"
            params = [
                "shopid":NetworkTool.shopid,
                "placeName":placeName,
                "flag":"setPlace"
            ]
            //连接网络
            Alamofire.request(method, url, parameters: params).validate().responseJSON { response in
                
                print("**********************")
                print(response)
                print("**********************")
                
                switch response.result {
                case .Success(let date):
                    result = date as! NSDictionary
                    completion(result, nil)
                    return
                case .Failure:
                    completion(nil, defaultError)
                    return
                }
            }
            
        //添加场地图片
        case .SubmitSitePhoto(placeId: let pi, imageArray: let imgs):
            
            url = "http://172.27.40.2:8080/Tennis/UploadIconServlet"
            params = [
                "type":"3",
                "place_id":pi
            ]
            
            Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                for (key, value) in params {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                if let imageData = UIImageJPEGRepresentation(imgs[0], 0.6) {
                    multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.png", mimeType: "image/png")
                }
                }, encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(request: let upload, _, _):
                        upload.responseJSON(completionHandler: { response in
                            debugPrint(response)
                            print("&&&&&&&&&&&&&&&&&&&&&&")
                            print(response)
                            print("&&&&&&&&&&&&&&&&&&&&&&")
                            result = response.result.value as! NSDictionary
                            completion(result, nil)
                        })
                    case .Failure(let encodingError):
                        print(encodingError)
                        completion(nil, defaultError)
                    }
            })
            
            
            

        }
    }
}
