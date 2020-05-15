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
    case couldNotUnwrap
    case unexpectedRecordsFound
    case unableLocateDeletedIDs
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Was not able to unwrap CK Record"
        case .unexpectedRecordsFound:
            return "Not the record behavior we were expecting"
        case .unableLocateDeletedIDs:
            return "No record ID found from delete"
        }
    }
}
