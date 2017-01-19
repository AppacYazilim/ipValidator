//
//  ViewController.swift
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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		SNpicker.selectRow(0,  inComponent: 0,animated: false);
		SNpicker.selectRow(0,  inComponent: 1,animated: false);
		SNpicker.selectRow(0,  inComponent: 2,animated: false);
		SNpicker.selectRow(6,  inComponent: 3,animated: false);
		
		IPpicker.selectRow(192,inComponent: 0,animated: false);
		IPpicker.selectRow(168,inComponent: 1,animated: false);
		IPpicker.selectRow(2,  inComponent: 2,animated: false);
		IPpicker.selectRow(2,  inComponent: 3,animated: false);
		
		RTpicker.selectRow(192,inComponent: 0,animated: false);
		RTpicker.selectRow(168,inComponent: 1,animated: false);
		RTpicker.selectRow(2,  inComponent: 2,animated: false);
		RTpicker.selectRow(1,  inComponent: 3,animated: false);
	}
	
	@IBOutlet weak var IPpicker: UIPickerView!
	@IBOutlet weak var SNpicker: UIPickerView!
	@IBOutlet weak var RTpicker: UIPickerView!
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 4
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == SNpicker {
			if component == 3 {
				return 7
			}
			return 9
		}
		
		if pickerView == RTpicker {
			return space[component];
		}
//		if pickerView == IPpicker && component == 3 {
//			return 1;
//		}
		return 256
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == SNpicker {
			if component == 3 {
				let p = 255 - Int(pow(2.0, Double(row + 2)) - 1)
				return "\(p)"
			}
			let p = 255 - Int(pow(2.0, Double(row)) - 1)
			return "\(p)"
		}
		
		if pickerView == RTpicker {
			let s = IPaddr[component] & Subnet[component];
			return "\(s + row)"
		}
		return "\(row)"
	}
	var Subnet = [255,255,255,0];
	var IPaddr = [192,168,2,0];
	var RTaddr = [192,168,2,1];
	var space  = [1,1,1,255];
	
	func updateRT(){
		print(Subnet);
		let a = [Subnet[0] & IPaddr[0],Subnet[1] & IPaddr[1],Subnet[2] & IPaddr[2],Subnet[3] & IPaddr[3]];
		self.space = [(255 - Subnet[0]) + 1,(255 - Subnet[1]) + 1,(255 - Subnet[2]) + 1,(255 - Subnet[3])];
		
		RTpicker.reloadAllComponents()
		print(space)
		print(a);
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == SNpicker {
			let p:Int;
			if component == 3 {
				p = 255 - Int(pow(2.0, Double(row + 2)) - 1)
			} else {
				p = 255 - Int(pow(2.0, Double(row)) - 1)
			}
			
			if component == 3 {
				Subnet[3] = p;
				if row != 6 {
					Subnet[0] = 255;
					Subnet[1] = 255;
					Subnet[2] = 255;
					SNpicker.selectRow(0,inComponent: 0,animated: true);
					SNpicker.selectRow(0,inComponent: 1,animated: true);
					SNpicker.selectRow(0,inComponent: 2,animated: true);
				}
			}
			if component == 2 {
				Subnet[2] = p;
				if row != 0 {
					Subnet[3] = 0;
					Subnet[0] = 255;
					Subnet[1] = 255;
					SNpicker.selectRow(6,inComponent: 3,animated: true);
					SNpicker.selectRow(0,inComponent: 0,animated: true);
					SNpicker.selectRow(0,inComponent: 1,animated: true);
				} else {
					Subnet[0] = 255;
					Subnet[1] = 255;
					SNpicker.selectRow(0,inComponent: 0,animated: true);
					SNpicker.selectRow(0,inComponent: 1,animated: true);
				}
			}
			if component == 1 {
				Subnet[1] = p;
				if row != 0 {
					
					Subnet[2] = 0;
					Subnet[3] = 0;
					SNpicker.selectRow(6,inComponent: 3,animated: true);
					SNpicker.selectRow(8,inComponent: 2,animated: true);
				} else {
					Subnet[0] = 255;
					SNpicker.selectRow(0,inComponent: 0,animated: true);
				}
			}
			if component == 0 {
				Subnet[0] = p;
				if row != 0 {
					Subnet[1] = 0;
					Subnet[2] = 0;
					Subnet[3] = 0;
					SNpicker.selectRow(6,inComponent: 3,animated: true);
					SNpicker.selectRow(8,inComponent: 2,animated: true);
					SNpicker.selectRow(8,inComponent: 1,animated: true);
				}
			}
			updateRT();
		}
		
		if pickerView == IPpicker {
			IPaddr[component] = row;
			updateRT();
		}
		
		
		if pickerView == RTpicker {
			RTaddr[component] = row;
			updateRT();
		}
		print("\(row) , \(component)")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		for i in 0...3 {
			
			self.IPaddr[i] = IPpicker.selectedRow(inComponent: i);
			
			let row = SNpicker.selectedRow(inComponent: i);
			if i == 3 {
				self.Subnet[i] =  255 - Int(pow(2.0, Double(row + 2)) - 1)
			} else {
				self.Subnet[i] =  255 - Int(pow(2.0, Double(row)) - 1)
			}
		}
		
		if let dest = segue.destination as? ResultsTableViewController {
			dest.IPaddr = self.IPaddr
			dest.Subnet = self.Subnet
		}
	}
}

