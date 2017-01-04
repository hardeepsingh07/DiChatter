//
//  chatController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/18/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit

class chatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var screenLabel: UIButton!
    
    var user = [String]()
    var passThis: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user.append("Hello")
        user.append("Bye")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cCell", for: indexPath)
        
        cell.textLabel?.text = user[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.passThis = user[indexPath.row]
        performSegue(withIdentifier: "chatDetail", sender: nil)
        print("********Trigger")
//        let controller = storyboard?.instantiateViewController(withIdentifier: "chatDetail") as! chatDetailController
//        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "chatDetail") {
            let svc = segue.destination as! detailChatController
            svc.name = self.passThis
        }
    }
}
