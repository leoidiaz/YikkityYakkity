//
//  YikkityError.swift
//  YikkityYakkity
//
//  Created by Leonardo Diaz on 5/14/20.
//  Copyright © 2020 Cody Adcock. All rights reserved.
//

import Foundation
enum YikkityError: LocalizedError {
    case ckError(Error)
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        }
    }
}
