//
//  ApiManager.swift
//  UMPY
//
//  Created by CBDev on 4/3/19.
//  Copyright © 2019 CBDev. All rights reserved.
//


import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ApiManager{
    
    static var _webService: ApiManager? = nil;
    var header: [String: String]?
    
    static func sharedInstance() -> ApiManager {
        if(_webService == nil) {
            _webService = ApiManager()
        }
        
        return _webService!
    }
    
    
    init()
    {
        
    }
    private func getErrorString(_ error: Data) -> String {
        do {
            let dicError = try JSONSerialization.jsonObject(with: error, options: []) as! [String: Any]
            if let errStr = dicError[Constants.Server.RESPONSE_MESSAGE] {
                return errStr as! String
            }else{
                return "No data to display"
            }
        } catch let error {
            return error.localizedDescription
        }
    }
    
    // MARK: - User Management
    func login(email: String, password: String,completion: @escaping (UserModel?, String?) -> Void){
        let parameters: Parameters = ["email": email, "password":password]
        let url = "\(Constants.Server.URL)login_user/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    func signup_user(firstName: String, secName: String, email: String, country: String, home_city: String, phone_num: String, password: String, user_type: String, latitude:String, longitude: String, completion: @escaping (UserModel?, String?) -> Void){
        let parameters: Parameters = ["first_name": firstName,  "sec_name": secName, "email":email, "country": country, "home_city": home_city, "phone_num": phone_num, "password": password, "user_type":user_type, "latitude": latitude, "longitude": longitude]
        let url = "\(Constants.Server.URL)register_user/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func update_user(userID: String, firstName: String, secName: String, email: String, country: String, home_city: String, phone_num: String, password: String, user_type: String, latitude:String, longitude: String, completion: @escaping (UserModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID, "first_name": firstName,  "sec_name": secName, "email":email, "country": country, "home_city": home_city, "phone_num": phone_num, "password": password, "user_type":user_type, "latitude": latitude, "longitude": longitude]
        let url = "\(Constants.Server.URL)register_user/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getUserInfo(userID:String, completion: @escaping (UserModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID]
        let url = "\(Constants.Server.URL)get_user_info/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<UserModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    func forgotPassword(email:String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["email": email]
        let url = "\(Constants.Server.URL)forgot_password/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    func updatePassword(userID:String, newPassword: String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID, "password": newPassword]
        let url = "\(Constants.Server.URL)update_password/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func verifyPhone(phoneNum:String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["phone": phoneNum]
        let url = "https://appdito.ditoexpress.com/apis/sendVerifyCode/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    
    //MARK: - Setting API
    
    func getSetting(userID: String, completion: @escaping (SettingModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID]
        let url = "\(Constants.Server.URL)get_setting/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SettingModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    func updateSetting(userID: String, video_resolution: Int, enable_audio: Int, video_permission: Int, video_duration: Int, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID, "video_resolution": video_resolution,  "enable_audio": enable_audio, "video_permission":video_permission, "video_duration": video_duration]
        let url = "\(Constants.Server.URL)update_setting/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    //MARK: Match API
    
    
    func addMatch(userID: String, home_team: String, visitors: String, venue: String, grade: String, date: String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID, "home_team": home_team,  "visitors": visitors, "venue":venue, "grade": grade, "date": date]
        
        let url = "\(Constants.Server.URL)add_match/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    
    func getMatches(userID: String, completion: @escaping (MatchList?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID]
        let url = "\(Constants.Server.URL)get_matches/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<MatchList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func deleteMatch(matchID: String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["match_id": matchID]
        let url = "\(Constants.Server.URL)del_match/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    //MARK: - Security Question
    
    
    
    func addSecurityQuestion(userID: String, question1: String, answer1: String, question2: String, answer2: String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["user_id": userID, "question1": question1,  "answer1": answer1, "question2": question2, "answer2": answer2]
        
        let url = "\(Constants.Server.URL)add_security_question/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    // MARK: -Video
    
    func uploadVideo(matchID: String, videoURL: String, permission: String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["match_id": matchID, "video_url": videoURL,  "permission": permission]
        
        let url = "\(Constants.Server.URL)add_video/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json ?? "")")
                }
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getVideos(matchID: String, completion: @escaping (VideoList?, String?) -> Void){
        let parameters: Parameters = ["match_id": matchID]
        let url = "\(Constants.Server.URL)get_videos/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<VideoList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func getPublicVideos(matchID: String, completion: @escaping (VideoList?, String?) -> Void){
        let parameters: Parameters = ["match_id": matchID]
        let url = "\(Constants.Server.URL)get_public_videos/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<VideoList>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }
    
    func deleteVideo(videoID: String, completion: @escaping (SimpleModel?, String?) -> Void){
        let parameters: Parameters = ["video_id": videoID]
        let url = "\(Constants.Server.URL)del_video/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: [:])
            .validate()
            .responseObject() { (response: DataResponse<SimpleModel>) in
                switch response.result {
                case .success(let objLead):
                    completion(objLead, nil)
                case .failure(_):
                    completion(nil, self.getErrorString(response.data!))
                }
        }
    }

}
