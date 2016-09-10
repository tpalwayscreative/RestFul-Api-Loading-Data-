//
//  TaskViewController.swift
//  RestFul API
//
//  Created by phong on 9/10/16.
//  Copyright © 2016 tpcreative.co. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate,UITableViewDataSource , UITextFieldDelegate{

    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var textFiledTask: UITextField!
    @IBOutlet weak var tbView: UITableView!
    
    var userDedault : NSUserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDedault = NSUserDefaults()
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.textFiledTask.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        constraint.constant = 0.0
        return false
        
    }
    

    func keyboardWillShow(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        constraint.constant = CGFloat(keyboardHeight)
        
    }
    
    
    private func scrollToBotton(){
        
        let numberOfSections = self.tbView.numberOfSections
        let numberOfRows = self.tbView.numberOfRowsInSection(numberOfSections-1)
        let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: numberOfSections-1)
        
        self.tbView.scrollToRowAtIndexPath(indexPath,
                                           atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        tbView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var task = StructTask()
        let syn = AsynTask(view: self,task: task,tbView:tbView)
        syn.getTasks()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogout(sender: UIButton) {
        
        
        userDedault.setObject("", forKey: "apiKey")
     performSegueWithIdentifier("segue_to_register", sender: nil)
        
        
    }

    @IBAction func btnSend(sender: UIButton) {
        
        IJProgressView.shared.showProgressView(view)
        
        var task = StructTask()
        task.task = textFiledTask.text
        
        let syn = AsynTask(view: self,task: task,tbView: tbView)
        syn.createTask()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return manageTask.list.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = self.tbView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text  = manageTask.list[indexPath.row].task
        return cell
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
