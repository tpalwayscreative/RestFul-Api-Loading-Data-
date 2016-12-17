//
//  AsynTask.swift
//  RestFul API
//
//  Created by phong on 9/10/16.
//  Copyright © 2016 tpcreative.co. All rights reserved.
//

import UIKit

class AsynTask: NSObject {

    
    
    var view : AnyObject?
    var task : StructTask?
    var userDefault : UserDefaults
    var tbView : UITableView?
    init(view : AnyObject, task : StructTask,tbView: UITableView){
        
        self.view = view
        self.task = task
        self.userDefault = UserDefaults()
        self.tbView = tbView
    }
    
    func getTasks() {
        
        
        
        let api_key : String = userDefault.value(forKey: "apiKey") as! String
        let headers = ["Authorization" : api_key]
        do {
            let opt = try HTTP.GET("http://tpalwayscreative.esy.es/task_manager/v1/tasks", parameters: nil,headers: headers)
            opt.start { response in
                
                let data = response.data
                
                if response.error == nil {
                    let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("response: \(str)") //prints the HTML of the page
                    let jsonTask = JSONDecoder(data)
                    if jsonTask["error"].bool
                    {
                        DispatchQueue.main.async(execute: {
                            ()-> Void in
                            IJProgressView.shared.hideProgressView()
                        }
                        )
                        print("Error")
                    }
                    else{
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            
                            IJProgressView.shared.hideProgressView()
                            manageTask.addJsonDecoder(jsonTask)
                            self.tbView?.reloadData()
                            print(manageTask.list.count)
                            
                            
                        })
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        


    }
    
    
    
    func createTask() {
        
        
        
        
        let api_key : String = userDefault.value(forKey: "apiKey") as! String
        let headers = ["Authorization" : api_key]
        let params = ["task":task!.task!]
        do {
            let opt = try HTTP.POST("http://tpalwayscreative.esy.es/task_manager/v1/tasks", parameters: params,headers: headers)
            opt.start { response in
                
                let data = response.data
                
                if response.error == nil {
                    let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("response: \(str)") //prints the HTML of the page
                    let jsonTask = JSONDecoder(data)
                    if jsonTask["error"].bool
                    {
                        DispatchQueue.main.async(execute: {
                            ()-> Void in
                              print(jsonTask)
                            IJProgressView.shared.hideProgressView()
                        }
                        )
                        print("Error")
                    }
                    else{
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            
                            
                            IJProgressView.shared.hideProgressView()
                            manageTask.list.append(self.task!)
                            self.tbView?.reloadData()

                            
                            
                        })
                    }
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        
    }

}
