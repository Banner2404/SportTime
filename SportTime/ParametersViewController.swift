//
//  ParametersViewController.swift
//  SportTime
//
//  Created by Соболь Евгений on 04.08.16.
//  Copyright © 2016 Соболь Евгений. All rights reserved.
//

import UIKit

class ParametersViewController: UITableViewController, SettingsDelegate {

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
        
        return section == 0 ? "Активные" : "Неактивные"
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return settings.active.count
        } else {
            return settings.passive.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var data = Settings.Data(max: 0, min: 0, order: 0, identifier: "")
        
        switch indexPath.section {
        case 0:
            data = settings.active[indexPath.row]
        case 1:
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

        return true
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        var data: Settings.Data
        
        if fromIndexPath.section == 0 {
            data = settings.active.removeAtIndex(fromIndexPath.row)
        } else {
            data = settings.passive.removeAtIndex(fromIndexPath.row)
        }
        
        if toIndexPath.section == 0 {
            settings.active.insert(data, atIndex: toIndexPath.row)
        } else {
            settings.passive.insert(data, atIndex: toIndexPath.row)
        }
        
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //MARK: - SettingsDelegate
    
    func getActive() -> [Settings.Data] {
        
        var active = settings.active
        
        for i in 0..<active.count {
            
            active[i].order = i
            
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))!
            let textFieldMin = cell.viewWithTag(1) as! UITextField
            active[i].min = Int(textFieldMin.text!)!
            
            let textFieldMax = cell.viewWithTag(2) as! UITextField
            active[i].max = Int(textFieldMax.text!)!
            
        }
        
        return active
        
    }

    func getPassive() -> [Settings.Data] {
        
        var passive = settings.passive
        
        for i in 0..<passive.count {
            
            passive[i].order = Settings.InactiveOrder
            
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 1))!
            let textFieldMin = cell.viewWithTag(1) as! UITextField
            passive[i].min = Int(textFieldMin.text!)!
            
            let textFieldMax = cell.viewWithTag(2) as! UITextField
            passive[i].max = Int(textFieldMax.text!)!
        }

        
        return passive
        
    }
    
    //MARK: - Actions
    
    @IBAction func actionEditButton(sender: UIBarButtonItem) {
        
        tableView.editing = !tableView.editing
        view.endEditing(true)
        
        
    }
    
    func actionBackButton() {
        
    }

}
