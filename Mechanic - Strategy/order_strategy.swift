//
//  order_strategy.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

protocol OrderStrategy {
  func fulfillOrder(order: Order) -> Bool
}
