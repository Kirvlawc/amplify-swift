//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation

struct ThrowSignInError: Action {
    let identifier = "ThrowSignInError"

    let error: Error

    func execute(withDispatcher dispatcher: EventDispatcher,
                 environment: Environment) async {

        logVerbose("\(#fileID) Starting execution", environment: environment)
        let event = AuthenticationEvent(
            eventType: .error(.service(message: "\(error)", error: error)))
        logVerbose("\(#fileID) Sending event \(event)", environment: environment)
        await dispatcher.send(event)

    }
}

extension ThrowSignInError: DefaultLogger {
    public static var log: Logger {
        Amplify.Logging.logger(forCategory: CategoryType.auth.displayName, forNamespace: String(describing: self))
    }

    public var log: Logger {
        Self.log
    }
}

extension ThrowSignInError: CustomDebugDictionaryConvertible {
    var debugDictionary: [String: Any] {
        [
            "identifier": identifier
        ]
    }
}

extension ThrowSignInError: CustomDebugStringConvertible {
    var debugDescription: String {
        debugDictionary.debugDescription
    }
}
