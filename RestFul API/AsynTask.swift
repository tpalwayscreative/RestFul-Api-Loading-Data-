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
    var userDefault : NSUserDefaults
    var tbView : UITableView?
    init(view : AnyObject, task : StructTask,tbView: UITableView){
        
        self.view = view
        self.task = task
        self.userDefault = NSUserDefaults()
        self.tbView = tbView
    }
    
    func getTasks() {
        
        
        let api_key : String = userDefault.valueForKey("apiKey") as! String
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = api_key
        let params = ["":""]
        
        request.GET("http://tpalwayscreative.esy.es/task_manager/v1/tasks" , parameters: params, completionHandler:
            {(response: HTTPResponse) in
                
                if let data = response.responseObject as? NSData {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print("response: \(str)") //prints the HTML of the page
                    let jsonTask = JSONDecoder(data)
                    if jsonTask["error"].bool
                    {
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                ()-> Void in
                                
                                
                                print(jsonTask)
                                IJProgressView.shared.hideProgressView()
                                
                            }
                        )
                        print("Error")
                    }
                    else{
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            IJProgressView.shared.hideProgressView()
                            manageTask.addJsonDecoder(jsonTask)
                            self.tbView?.reloadData()
                            print(manageTask.list.count)
                            
                        })
                    }
                }
        })
    
    }
    
    
    
    func createTask() {
        
        
        let api_key : String = userDefault.valueForKey("apiKey") as! String
        let request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = api_key
        let params = ["task":task!.task!]
        
        request.POST("http://tpalwayscreative.esy.es/task_manager/v1/tasks" , parameters: params, completionHandler:
            {(response: HTTPResponse) in
                
                if let data = response.responseObject as? NSData {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print("response: \(str)") //prints the HTML of the page
                    let jsonTask = JSONDecoder(data)
                    if jsonTask["error"].bool
                    {
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                ()-> Void in
                                
                                
                                print(jsonTask)
                                IJProgressView.shared.hideProgressView()
                                
                            }
                        )
                        print("Error")
                    }
                    else{
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            IJProgressView.shared.hideProgressView()
                            manageTask.list.append(self.task!)
                            self.tbView?.reloadData()
                           
                            
                        })
                    }
                }
        })
        
    }

    
}
