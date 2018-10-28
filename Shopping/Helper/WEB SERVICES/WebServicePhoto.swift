//
//  WebServicePhoto.swift
//  Shopping
//
//  Created by Naggar on 11/11/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import AlamofireImage

extension WebServices {
    
    
    class func uploadImages(allImage: [(UIImage , String)] , completion: @escaping (_ success: Bool , _ err: String) -> Void) {
        
        for img in allImage {
            
            let image = img.0 // as image itself
            let name = img.1 // as image name
            
            Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                
                if let data = UIImageJPEGRepresentation(image, 0.5) {
                    form.append(data, withName: "file", fileName: "\(name)", mimeType: "image/jpeg")
                    
                }
                
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: Constants.Services.uploadImage, method: .post, headers: nil) { (result: SessionManager.MultipartFormDataEncodingResult) in
                
                switch result {
                case .failure(let error):
                    print(error)
                    completion(false , error.localizedDescription)
                    return
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    
                    upload.uploadProgress(closure: { (progress: Progress) in
                        print(progress)
                    })
                        .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                            
                            switch response.result
                            {
                            case .failure(let error):
                                print(error)
                                
                                completion(false , error.localizedDescription)
                                
                                return // Mtkml4
                                
                            case .success(let value):
                                let json = JSON(value)
                                print(json)
                                
                                if json["success"].string == "File successfully uploaded" {
                                    // success
                                    print("Upload Succeed")
                                    
                                   completion(true , "Uploaded Succeed")
                                } else {
                                    print("Upload Failed")
                                    completion(false , "Uploaded Failed")
                                    return
                                }
                            }
                            
                        })
                }
                
            }
        }
        
        // completion(true , "Uploaded Successfully")

    }
    
    /// NOT USED :"D
    class func downloadImage(name: String , completion: @escaping (_ success: Bool , _ image: UIImage?) -> Void) {
        
        let urlwithPercentEscapes = name.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)

        
        
        guard let url = URL(string: "\(Constants.Services.imagePath)\(String(describing: urlwithPercentEscapes))") else {
            
            
            completion(false , nil)
            return
        }
        
        
        Alamofire.request(url)
        
            .responseImage { (response) in
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    
                    completion(false , nil)
                    
                case .success(_ ) :
                    if let image = response.result.value {
                        completion(true , image)
                        
                    } else {
                        completion(false , nil)
                    }
                }
        }
        
    }
    
    
}
