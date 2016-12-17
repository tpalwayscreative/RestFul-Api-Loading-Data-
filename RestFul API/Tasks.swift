//
//  Tasks.swift
//  RestFul API
//
//  Created by phong on 9/10/16.
//  Copyright © 2016 tpcreative.co. All rights reserved.
//

import UIKit


var manageTask : Tasks = Tasks()

struct StructTask {
    
    var id : Int?
    var task : String?
    var status : Int?
    var created_at : String?

    init()
    {
        
    }
    init(task : StructTask)
    {
        self.id = task.id
        self.task = task.task
        self.status = task.status
        self.created_at = task.created_at
    }
    
    init(jsonDecode : JSONDecoder)
    {
        
        self.id = jsonDecode["id"].integer
        self.task = jsonDecode["task"].string
        self.status = jsonDecode["status"].integer
        self.created_at = jsonDecode["created_at"].string
        
    }

}


class Tasks: NSObject {
    
    var list = [StructTask]()

    func addJsonDecoder(_ decoder : JSONDecoder)
    {
        
        if let add = decoder["tasks"].array{
            
            list = Array<StructTask>()
            for addDecoder in add{
                
                list.append(StructTask(jsonDecode: addDecoder))
                
            }
        }
        else
        {
            print("No Action==>")
        }
        
    }
    
    

}
