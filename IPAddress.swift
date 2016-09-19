//
//  IPAddress.swift
//  ipValidator
//
//  Created by Mehmet emin Kartal on 9/19/16.
//  Copyright © 2016 mehmet. All rights reserved.
//

import Foundation

class IPAddress: CustomStringConvertible {
	var address: UInt32 = 0;
	
	init(with blocks: [UInt8]) {
		if blocks.count < 4 {
			return;
		}
		
		self.address = (UInt32(blocks[3]) + (UInt32(blocks[2]) << 8))
		self.address += (UInt32(blocks[1]) << 16) + (UInt32(blocks[0]) << 24)
	}
	
	func get(block: Int) -> UInt8{
		return UInt8((address & UInt32(255 << (8 * block)) ) >> UInt32(8 * block))
	}
	
	
	func toString() -> String {
		return "\(get(block: 0)).\(get(block: 1)).\(get(block: 2)).\(get(block: 3))"
	}
	
	var description: String {
		get {
			return self.toString();
		}
	}
}
