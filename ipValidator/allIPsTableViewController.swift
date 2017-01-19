//
//  allIPsTableViewController.swift
//  ipValidator
//
//  Created by Mehmet emin Kartal on 9/17/16.
//  Copyright © 2016 Mehmet Emin KARTAL
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.


import UIKit

class allIPsTableViewController: UITableViewController {
	var StartIP: [Int] = [0,0,0,0]
	var EndIP: [Int] = [0,0,0,0]
	var BroadcastIP: [Int] = [0,0,0,0]
	var IPCount: Int = 0;
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return  IPCount + 1
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let startNum  = (StartIP[3] + (StartIP[2] << 8) + (StartIP[1] << 16) + (StartIP[0] << 24))
//		let endNum  = (EndIP[3] + (EndIP[2] << 8) + (EndIP[1] << 16) + (EndIP[0] << 24))
		
		if indexPath.row == 0 {
			
			cell.textLabel?.text = self.ip(BroadcastIP);
			cell.detailTextLabel?.text = "Broadcast Ip"
			return cell
		}
		
		let r = indexPath.row - 1
		let nn = startNum + r ;
		
		var ip = [0,0,0,0];
		for i in 0...3 {
			ip[3 - i] = (nn &  (255 << (8 * i))  ) >> ( 8 * i)
		}
        // Configure the cell...
		cell.textLabel?.text = self.ip(ip);
		cell.detailTextLabel?.text = "";
        return cell
    }
	
	func ip(_ ip: [Int]) -> String {
		return "\(ip[0]).\(ip[1]).\(ip[2]).\(ip[3])"
	}

}
