//
//  ExportViewController.swift
//  ipValidator
//
//  Created by Mehmet emin Kartal on 9/18/16.
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

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
	var i = 0
	return AnyIterator {
		let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
		if next.hashValue != i { return nil }
		i += 1
		return next
	}
}

class ExportViewController: UIViewController {
	@IBOutlet weak var formatButton: UIBarButtonItem!
	@IBOutlet weak var textField: UITextView!
	
	enum ExportConfigs {
		case dhcpd
		case interfaces
		case arduino
		
		func toString() -> String {
			switch self {
			case .dhcpd:
				return "dhcpd.conf"
			case .interfaces:
				return "interfaces"
			case .arduino:
				return "Arduino"
			}
		}
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
	
	func ip2(_ ip: [Int]) -> String {
		return "\(ip[0]), \(ip[1]), \(ip[2]), \(ip[3])"
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
			AttrString.append(NSAttributedString(string: "#dhcpd.conf file", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.red]))
			AttrString.append(NSAttributedString(string: "\ninterface", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " \(interface)", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.purple]))
			
			AttrString.append(NSAttributedString(string: "\nstatic ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "ip_address", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			AttrString.append(NSAttributedString(string: "=", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\(ip(IPaddr))/\(networkSize)", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\nstatic ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "routers", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			AttrString.append(NSAttributedString(string: "=", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\(ip(GWaddr))", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\nstatic ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "domain_name_servers", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			AttrString.append(NSAttributedString(string: "=", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\(ip(DNSaddr))", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
		case .interfaces:
			/*

			iface eth0 inet static
			address 192.168.1.1
			netmask 255.255.255.0
			gateway 192.168.1.254
			*/
			
			
			AttrString.append(NSAttributedString(string: "#interfaces file", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.red]))
			AttrString.append(NSAttributedString(string: "\niface", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " \(interface)", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.purple]))
			AttrString.append(NSAttributedString(string: " inet static", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			
			AttrString.append(NSAttributedString(string: "\naddress ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "\(ip(IPaddr))", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\ngateway ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "\(ip(GWaddr))", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			
			AttrString.append(NSAttributedString(string: "\nnetmask ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: "\(ip(Subnet))", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
		case .arduino:
			
			
			AttrString.append(NSAttributedString(string: "#include ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			AttrString.append(NSAttributedString(string: "<", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.gray]))
			AttrString.append(NSAttributedString(string: "SPI", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: ".h>\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.gray]))
			
			AttrString.append(NSAttributedString(string: "#include ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.green]))
			AttrString.append(NSAttributedString(string: "<", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.gray]))
			AttrString.append(NSAttributedString(string: "WiFi", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.orange]))
			AttrString.append(NSAttributedString(string: ".h>\n\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.gray]))
			
			
			AttrString.append(NSAttributedString(string: "char", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " ssid[] = ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\"networkSSID\"", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.red]))
			AttrString.append(NSAttributedString(string: ";\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			AttrString.append(NSAttributedString(string: "char", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " pass[] = ", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "\"networkPassword\"", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.red]))
			AttrString.append(NSAttributedString(string: ";\n\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			AttrString.append(NSAttributedString(string: "IPAddress", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " ip", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "(", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ip2(IPaddr), attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ")", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ";\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			AttrString.append(NSAttributedString(string: "IPAddress", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " dns", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "(", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ip2(DNSaddr), attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ")", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ";\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			AttrString.append(NSAttributedString(string: "IPAddress", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " gateway", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "(", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ip2(GWaddr), attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ")", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ";\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			
			AttrString.append(NSAttributedString(string: "IPAddress", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " subnet", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "(", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ip2(Subnet), attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ")", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ";\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			
			AttrString.append(NSAttributedString(string: "\nvoid", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.blue]))
			AttrString.append(NSAttributedString(string: " setup", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "(", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: ")", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			AttrString.append(NSAttributedString(string: "{\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			
			AttrString.append(NSAttributedString(string: "\tWiFi.begin(ssid, pass);\n\tWiFi.config(ip, dns, gateway, subnet);\n*", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			
			AttrString.append(NSAttributedString(string: "}\n", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white]))
			
			/*
			
			#include <WiFi.h>
			
			char ssid[] = "networkSSID";
			char pass[] = "networkPassword";
			
			IPAddress ip(0, 0, 0, 0);
			IPAddress dns(0, 0, 0, 0);
			IPAddress gateway(0, 0, 0, 0);
			IPAddress subnet(0, 0, 0, 0);
			
			void setup() {
			// put your setup code here, to run once:
			WiFi.begin(ssid, pass);
			WiFi.config(ip, dns, gateway, subnet);
			
			}
			
			void loop() {
			// put your main code here, to run repeatedly:
			}
			
			*/
			
			
		}
		AttrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "CourierNewPS-BoldMT", size: 14.0)!, range: NSMakeRange(0, AttrString.length))
		
		self.textField.attributedText = AttrString
	}
	
	@IBAction func formatAction(_ sender: AnyObject) {
		let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet);
		
		
		alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_) in
			let objectsToShare = [self.textField.attributedText,URL(string: "https://www.mekatrotekno.com/")!] as [Any]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//			activityVC.excludedActivityTypes = [UIActivityType.airDrop]
			activityVC.popoverPresentationController?.barButtonItem = self.formatButton
			self.present(activityVC, animated: true, completion: nil)
		}))
		
		
		for i in iterateEnum(ExportViewController.ExportConfigs) {
//			if config != i {
				alert.addAction(UIAlertAction(title: "Switch To \(i.toString()) Format", style: .default, handler: { (_) in
					print(i.toString());
					self.config = i
					self.prepareConfig()
				}))
//			}
		}
		
		alert.addAction(UIAlertAction(title: "Copy Text", style: .default, handler: { (_) in
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
