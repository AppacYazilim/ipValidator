//
//  ResultsTableViewController.swift
//  ipValidator
//
//  Created by Mehmet emin Kartal on 9/17/16.
//  Copyright © 2016 mehmet. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {
	
	var Subnet: [Int] = [0,0,0,0];
	var IPaddr: [Int] = [0,0,0,0];
	
	var space  = [1,1,1,255];
	
	let sections = ["Network Info","IP Range","Stats"];
	let dataPoints = [["Network","Net Mask","Broadcast Address","CIDR Notation"],["Start Address","End Address", "Show All"], ["Number Of Devices", "Number Of Subnets"]]
	
	var StartIP: [Int] = [0,0,0,0]
	var EndIP: [Int] = [0,0,0,0]
	var BroadcastIP: [Int] = [0,0,0,0]
	var networkSize = 0;
	var IPCount: Int = 0;
	var SubnetCount: Int = 0;
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		calculate()
	}
	
	func calculate(){
		self.space = [(255 - Subnet[0]) ,(255 - Subnet[1]) ,(255 - Subnet[2]) ,(255 - Subnet[3])];
		let nn  = (Subnet[3] + (Subnet[2] << 8) + (Subnet[1] << 16) + (Subnet[0] << 24))
		
		networkSize = 0;
		for i in 0...31 {
			let n = 1 << i
			if nn & n != 0 {
				networkSize += 1
			}
		}
		
		SubnetCount = space[0] + space[1] + space[2];
		
		
		for i in 0...3 {
			let a = IPaddr[i] & Subnet[i];
			StartIP[i] = (i == 3) ? a + 1 : a;
			EndIP[i] = a + ((i == 3) ? space[i] - 1 : space[i]);
			BroadcastIP[i] = a;
		}
		
		let endNum  = (EndIP[3] + (EndIP[2] << 8) + (EndIP[1] << 16) + (EndIP[0] << 24))
		let startNum  = (StartIP[3] + (StartIP[2] << 8) + (StartIP[1] << 16) + (StartIP[0] << 24))
		
		IPCount = (endNum - startNum) + 1
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if IPCount > 10000 && section == 1 {
			return dataPoints[section].count - 1
		}
        return dataPoints[section].count
    }

	func ip(_ ip: [Int]) -> String {
		return "\(ip[0]).\(ip[1]).\(ip[2]).\(ip[3])"
	}
	
	
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if IPCount <= 10000 && indexPath.section == 1 && indexPath.row == 2 {
			return  tableView.dequeueReusableCell(withIdentifier: "showAll", for: indexPath)
		}
		
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		var detail = "Err";
		
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				detail = ip(IPaddr)
			case 1:
				detail = ip(Subnet)
			case 2:
				detail = ip(BroadcastIP)
			case 3:
				var Sip = StartIP;
				Sip[3] = 0;
				detail = "\(ip(Sip))/\(networkSize)"
			default: break
			}
		case 1:
			switch indexPath.row {
			case 0:
				detail = ip(StartIP)
			case 1:
				detail = ip(EndIP)
			case 2:
				detail = "\(IPCount)"
			default: break
			}
		case 2:
			switch indexPath.row {
			case 0:
				detail = "\(IPCount)"
			case 1:
				detail = "\(SubnetCount)"
			default: break
			}
		default:
			break
		}
		
		
        // Configure the cell...
		cell.textLabel?.text = dataPoints[indexPath.section][indexPath.row];
		cell.detailTextLabel?.text = detail;
        return cell
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section];
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dest = segue.destination as? allIPsTableViewController {
			dest.StartIP = self.StartIP
			dest.BroadcastIP = self.BroadcastIP
			dest.EndIP = self.EndIP
			dest.IPCount = self.IPCount
		}
		
		if let dest = segue.destination as? DNSConfigViewController {
			dest.BroadcastIP = self.BroadcastIP
			
			dest.networkSize = self.networkSize;
			dest.IPaddr = self.IPaddr
			dest.Subnet = self.Subnet
			dest.space = space;
		}
		
		
	}
}
