//
//  LogMiddleware.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

let logMiddleware: Middleware = { dispatch, getState in
    return { next in
        return { action in
            print(type(of: action))
            return next(action)
        }
    }
}
