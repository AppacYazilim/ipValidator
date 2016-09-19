//
//  ExportViewController.swift
//  ipValidator
//
//  Created by Mehmet emin Kartal on 9/18/16.
//  Copyright © 2016 mehmet. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController {
	@IBOutlet weak var formatButton: UIBarButtonItem!
	@IBOutlet weak var textField: UITextView!
	
	enum ExportConfigs {
		case dhcpd
		case interfaces
	}
	
	var config: ExportConfigs = .dhcpd
	
	var Subnet: [Int] = [0,0,0,0];
	var IPaddr: [Int] = [0,0,0,0];
	
	
	var GWaddr: [Int] = [0,0,0,0];
	var DNSaddr: [Int] = [0,0,0,0];
	
	
	var BroadcastIP: [Int] = [0,0,0,0]
	var networkSize = 0;
	var space: [Int] = [0,0,0,0]
	var interface = "en0"
	func ip(_ ip: [Int]) -> String {
		return "\(ip[0]).\(ip[1]).\(ip[2]).\(ip[3])"
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
    }
	override func viewWillAppear(_ animated: Bool) {
		prepareConfig();
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func prepareConfig() {
		let AttrString = NSMutableAttributedString()
		
		switch config {
		case .dhcpd:
			print("DHCPD");
			/*
			# dhcpcd.conf
			interface eth0
			static ip_address=192.168.1.141/24
			static routers=192.168.1.1
			static domain_name_servers=192.168.1.1
			*/
			AttrString.append(NSAttributedString(string: "#dhcpd.conf file", attributes: [ NSForegroundColorAttributeName: UIColor.red]))
			AttrString.append(NSAttributedString(string: "\ninterface", attributes: [ NSForegroundColorAttributeName: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " \(interface)", attributes: [ NSForegroundColorAttributeName: UIColor.purple]))
			
			AttrString.append(NSAttributedString(string: "\nstatic ", attributes: [ NSForegroundColorAttributeName: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "ip_address", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
			AttrString.append(NSAttributedString(string: "=", attributes: [ NSForegroundColorAttributeName: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\(ip(IPaddr))/\(networkSize)", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\nstatic ", attributes: [ NSForegroundColorAttributeName: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "routers", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
			AttrString.append(NSAttributedString(string: "=", attributes: [ NSForegroundColorAttributeName: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\(ip(GWaddr))", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\nstatic ", attributes: [ NSForegroundColorAttributeName: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "domain_name_servers", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
			AttrString.append(NSAttributedString(string: "=", attributes: [ NSForegroundColorAttributeName: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\(ip(DNSaddr))", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
		case .interfaces:
			/*

			iface eth0 inet static
			address 192.168.1.1
			netmask 255.255.255.0
			gateway 192.168.1.254
			*/
			
			
			AttrString.append(NSAttributedString(string: "#interfaces file", attributes: [ NSForegroundColorAttributeName: UIColor.red]))
			AttrString.append(NSAttributedString(string: "\niface", attributes: [ NSForegroundColorAttributeName: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " \(interface)", attributes: [ NSForegroundColorAttributeName: UIColor.purple]))
			AttrString.append(NSAttributedString(string: " inet static", attributes: [ NSForegroundColorAttributeName: UIColor.blue]))
			
			AttrString.append(NSAttributedString(string: "\naddress ", attributes: [ NSForegroundColorAttributeName: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "\(ip(IPaddr))", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\ngateway ", attributes: [ NSForegroundColorAttributeName: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "\(ip(GWaddr))", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\nnetmask ", attributes: [ NSForegroundColorAttributeName: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "\(ip(Subnet))", attributes: [ NSForegroundColorAttributeName: UIColor.green]))
		}
		
		self.textField.attributedText = AttrString
	}
	
	@IBAction func formatAction(_ sender: AnyObject) {
		let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet);
		
		
		alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_) in
			let objectsToShare = [self.textField.attributedText,URL(string: "https://www.mekatrotekno.com/")] as [Any]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//			activityVC.excludedActivityTypes = [UIActivityType.airDrop]
			activityVC.popoverPresentationController?.barButtonItem = self.formatButton
			self.present(activityVC, animated: true, completion: nil)
		}))
		
		if config != .dhcpd {
			alert.addAction(UIAlertAction(title: "Switch To dhcpd.conf", style: .default, handler: { (_) in
				print("dhcpd.conf");
				self.config = .dhcpd
				self.prepareConfig()
			}))
		}
		
		if config != .interfaces {
			alert.addAction(UIAlertAction(title: "Switch To interfaces format", style: .default, handler: { (_) in
				print("dhcpd.conf");
				self.config = .interfaces
				self.prepareConfig()
			}))
		}
		
		alert.addAction(UIAlertAction(title: "Copy Text", style: .default, handler: { (_) in
			print("dhcpd.conf");
			UIPasteboard.general.string = self.textField.text
		}))
		
		alert.addAction(UIAlertAction(title: "Change Interface", style: .default, handler: { (_) in
			let av = UIAlertController(title: "Enter Interface Name", message: nil, preferredStyle: .alert)
			av.addTextField(configurationHandler: { (tf: UITextField) in
				tf.placeholder = "Network Interface Name"
				tf.text = self.interface
			})
			
			av.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
				if let inf = av.textFields?[0].text {
					if inf != "" {
						self.interface = inf
						self.prepareConfig();
					}
				}
				
			}));
			self.present(av, animated: true, completion: nil);
		}))
		
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		if let popoverController = alert.popoverPresentationController {
			popoverController.barButtonItem = formatButton
		}
		
		self.present(alert, animated: true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
