//
//  PlayerInformationBoxTableViewController.swift
//  Tennis
//
//  Created by seasong on 16/4/23.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class PlayerInformationBoxTableViewController: UITableViewController {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var sexNameLabel: UILabel!
    @IBOutlet weak var ageNameLabel: UILabel!
    @IBOutlet weak var seedPlayerSwitch: UISwitch!
    @IBOutlet weak var quitBeforeCompetitionBeginSwitch: UISwitch!
    @IBOutlet weak var quitAfterCompetitonBeginSwitch: UISwitch!
    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hideBottomHairline()
        
        playerNameLabel.text = player.name
        sexNameLabel.text = player.sex
        ageNameLabel.text = String(player.age)
        seedPlayerSwitch.on = player.isSeedPlayer
        quitBeforeCompetitionBeginSwitch.on = player.isQuitBeforeCompetitionBegin
        quitAfterCompetitonBeginSwitch.on = player.isQuitAfterCompetitionBegin
        
        self.navigationItem.title = player.name
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func cancelBarButtonClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneBarButtonClick(sender: UIBarButtonItem) {
        player.isSeedPlayer = seedPlayerSwitch.on
        player.isQuitBeforeCompetitionBegin = quitBeforeCompetitionBeginSwitch.on
        player.isQuitAfterCompetitionBegin = quitAfterCompetitonBeginSwitch.on
        let notification = NSNotificationCenter.defaultCenter()
        notification.postNotificationName("PlayerInformationBoxNotification", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
