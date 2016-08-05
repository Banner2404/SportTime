//
//  ParametersViewController.swift
//  SportTime
//
//  Created by Соболь Евгений on 04.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class ParametersViewController: UITableViewController, SettingsDelegate, UITextFieldDelegate {

    let settings = Settings.sharedSettings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        settings.update()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return "Вермя"
        case 1: return "Активные"
        case 2: return "Неактивные"
        default: return ""
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return settings.active.count
        case 2: return settings.passive.count
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var data = Settings.Data(max: 0, min: 0, order: 0, identifier: "")
        
        switch indexPath.section {
        case 0:
            data = settings.time
        case 1:
            data = settings.active[indexPath.row]
        case 2:
            data = settings.passive[indexPath.row]
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(data.identifier, forIndexPath: indexPath)
        
        let textFieldMin = cell.viewWithTag(1) as! UITextField
        textFieldMin.text = String(data.min)
        
        let textFieldMax = cell.viewWithTag(2) as! UITextField
        textFieldMax.text = String(data.max)

        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        var data = Settings.Data()
        
        if fromIndexPath.section == 1 {
            data = settings.active.removeAtIndex(fromIndexPath.row)
        } else if fromIndexPath.section == 2 {
            data = settings.passive.removeAtIndex(fromIndexPath.row)
        }
        
        if toIndexPath.section == 1 {
            settings.active.insert(data, atIndex: toIndexPath.row)
        } else if toIndexPath.section == 2 {
            settings.passive.insert(data, atIndex: toIndexPath.row)
        }
        
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //MARK: - SettingsDelegate
    
    func getTime() -> Settings.Data {
        
        let (min, max, order) = parseData(forRow: 0, andSection: 0)
        
        return Settings.Data(max: max, min: min, order: order, identifier: "timeCell")
        
    }
    
    func getActive() -> [Settings.Data] {
        
        var active = settings.active
        
        for i in 0..<active.count {
            
            let (min, max, order) = parseData(forRow: i, andSection: 1)
            active[i].min = min
            active[i].max = max
            active[i].order = order
            
        }
        
        return active
        
    }

    func getPassive() -> [Settings.Data] {
        
        var passive = settings.passive
        
        for i in 0..<passive.count {
            
            let (min, max, order) = parseData(forRow: i, andSection: 2)
            passive[i].min = min
            passive[i].max = max
            passive[i].order = order
        }

        
        return passive
        
    }
    
    private func parseData(forRow row: Int, andSection section: Int) -> (min: Int, max: Int, order: Int) {
        
        let order = section == 1 ? row : Settings.InactiveOrder
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))!
        
        let textFieldMin = cell.viewWithTag(1) as! UITextField
        var min = Int(textFieldMin.text!) ?? 0
        
        let textFieldMax = cell.viewWithTag(2) as! UITextField
        var max = Int(textFieldMax.text!) ?? 0
        
        if max < min {
            swap(&max, &min)
        }
        
        return (min, max, order)

        
    }
    
    //MARK: - UITextFieldDelegate
    //TODO: don't edit text field while editing
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = textField.text! as NSString
        let str = nsString.stringByReplacingCharactersInRange(range, withString: string)
        if str.characters.count > 2 {
            return false
        }
        let characters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        
        let array = str.componentsSeparatedByCharactersInSet(characters)
        
        if array.count > 1 {
            return false
        }
        
        return true
    }
    
    //MARK: - Actions
    
    @IBAction func actionEditButton(sender: UIBarButtonItem) {
        
        tableView.editing = !tableView.editing
        view.endEditing(true)
        
        
    }

}
