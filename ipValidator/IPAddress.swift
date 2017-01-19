//
//  IPAddress.swift
//  ipValidator
//
//  Created by Mehmet emin Kartal on 9/19/16.
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
