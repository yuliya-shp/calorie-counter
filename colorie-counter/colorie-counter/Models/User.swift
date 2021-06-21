//
//  User.swift
//  colorie-counter
//
//  Created by Юля on 26.05.21.
//

import Foundation
import Firebase

struct User {

    let uid: String
    let email: String

    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }
}
