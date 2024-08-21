//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation

public protocol AuthAWSCredentialsProvider {
    /// Return the most recent Result of fetching the AWS Credentials
    func getAWSCredentials() -> Result<AWSCredentials, AuthError>
}

public extension AuthAWSCredentialsProvider where Self: AWSAuthSessionBehavior {
    /// Return the most recent Result of fetching the AWS Credentials. If the temporary credentials are expired, returns
    /// a `AuthError.sessionExpired` failure.
    func getAWSCredentials() -> Result<AWSCredentials, AuthError> {
        let result: Result<AWSCredentials, AuthError>
        switch awsCredentialsResult {
        case .failure(let error): result = .failure(error)
        case .success(let tempCreds):
            if tempCreds.expiration > Date() {
                result = .success(tempCreds)
            } else {
                result = .failure(AuthError.sessionExpired("AWS Credentials are expired", ""))
            }
        }
        return result
    }
}

public protocol AWSCredentialsProvider {
    func fetchAWSCredentials() async throws -> AWSCredentials
}

/**
 Represents AWS credentials.

 Typically refers to long-term credentials that do not expire unless manually rotated or deactivated.
 These credentials are generally associated with an IAM (Identity and Access Management) user and are used to authenticate API requests to AWS services.

 - Properties:
 - accessKeyId: A unique identifier.
 - secretAccessKey: A secret key used to sign requests cryptographically.
 */
public protocol AWSCredentials {

    /// A unique identifier.
    var accessKeyId: String { get }

    /// A secret key used to sign requests cryptographically.
    var secretAccessKey: String { get }
}

/**
 Represents temporary AWS credentials.

 Refers to short-term credentials generated by AWS STS (Security Token Service).
 These credentials are used for temporary access, often for applications, temporary roles, federated users, or scenarios requiring limited-time access.

 - Inherits: AWSCredentials

 - Properties:
 - sessionToken: A token that is required when using temporary security credentials to sign requests.
 - expiration: The expiration date and time of the temporary credentials.
 */
public protocol AWSTemporaryCredentials: AWSCredentials {

    /// A token that is required when using temporary security credentials to sign requests.
    var sessionToken: String { get }

    /// The expiration date and time of the temporary credentials.
    var expiration: Date { get }
}
