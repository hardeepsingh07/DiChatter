//
//  requestController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/18/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit


//Cell Class
class requestTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    
    var acceptTap: ((UITableViewCell) -> Void)?
    var declineTap: ((UITableViewCell) -> Void)?

    
    @IBAction func declineButton(_ sender: Any) {
        declineTap?(self)
    }
    
    @IBAction func acceptButton(_ sender: Any) {
        acceptTap?(self)
    }

}


//Adapater/ViewController Class
class requestController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var testArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
         testArray.append("Test1")
         testArray.append("Test2")
         testArray.append("Test3")
         testArray.append("Test4")
         testArray.append("Test5")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! requestTableViewCell
        
        let sName = testArray[indexPath.row]
        cell.labelName.text = sName
        cell.acceptTap = { (cell) in
            self.handleAccept(name: sName)
        }
        
        cell.declineTap = {
            (cell) in self.handleDecline(name: sName)
        }
        
        return cell
    }
    
    func handleAccept(name: String) {
        print("*****************Accept: " + name)
    }
    
    func handleDecline(name: String) {
        print("****************Decline: " + name)
    }
}
