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
    
    var userDedault : UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDedault = UserDefaults()
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.textFiledTask.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // Do any additional setup after loading the view.
    }

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        constraint.constant = 0.0
        return false
        
    }
    

    func keyboardWillShow(_ notification:Notification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        constraint.constant = CGFloat(keyboardHeight)
        
    }
    
    
    fileprivate func scrollToBotton(){
        
        let numberOfSections = self.tbView.numberOfSections
        let numberOfRows = self.tbView.numberOfRows(inSection: numberOfSections-1)
        let indexPath = IndexPath(row: numberOfRows-1, section: numberOfSections-1)
        
        self.tbView.scrollToRow(at: indexPath,
                                           at: UITableViewScrollPosition.middle, animated: true)
        tbView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let task = StructTask()
        let syn = AsynTask(view: self,task: task,tbView:tbView)
        syn.getTasks()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        
        
        userDedault.set("", forKey: "apiKey")
     performSegue(withIdentifier: "segue_to_register", sender: nil)
        
        
    }

    @IBAction func btnSend(_ sender: UIButton) {
        
      
        
        var task = StructTask()
        task.task = textFiledTask.text
        
        if(textFiledTask.text != ""){
            IJProgressView.shared.showProgressView(view)
            let syn = AsynTask(view: self,task: task,tbView: tbView)
            syn.createTask()
            textFiledTask.text = ""
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return manageTask.list.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = self.tbView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
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
