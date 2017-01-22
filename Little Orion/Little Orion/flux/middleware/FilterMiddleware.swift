//
//  FilterMiddleware.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 22/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

let filterMiddleware: Middleware = { dispatch, getState in
    return { next in
        return { action in
            return next(action)
        }
    }
}
