//
//  PartsNStuff.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class PartsNStuff {

  static var instance = PartsNStuff()
  private var approveMechanics = Set<Int>()
  private init() {}

  func addApprovedMechanic(mechanicId: Int) {
    approveMechanics.insert(mechanicId)
  }

  func fulfillOrder(order: Order, mechanicId: Int) -> Bool {
    if approveMechanics.contains(mechanicId) {
      //Code by PartsNStuff to fulfill order
      return true
    }
    return false
  }
}
