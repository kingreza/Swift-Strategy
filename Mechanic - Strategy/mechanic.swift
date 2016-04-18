//
//  mechanic.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

struct Mechanic: Hashable, Equatable {
  let mechanicId: Int
  let name: String

  init(mechanicId: Int, name: String) {
    self.mechanicId = mechanicId
    self.name = name
  }

  var hashValue: Int {
    return mechanicId
  }
}

func == (lhs: Mechanic, rhs: Mechanic) -> Bool {
  return lhs.mechanicId == rhs.mechanicId
}
