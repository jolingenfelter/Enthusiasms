//
//  Result.swift
//  EnthusiasmsApp
//
//  Created by Joanna LINGENFELTER on 10/2/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

import Foundation

enum Result<T> {
    case ok(T)
    case error(Error)
}

