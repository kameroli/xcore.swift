//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import LocalAuthentication

// MARK: - Kind

extension Biometrics {
    public enum Kind {
        case none
        case touchID
        case faceID

        fileprivate init() {
            let context = LAContext()
            let isAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

            // There is a bug in the earlier versions of iOS 11 that causes crash
            // when accessing `LAContext.biometryType`. Guarding using `context.responds`
            // is a workaround for the devices running older iOS 11 versions.
            // This is fixed in the later version of iOS 11.
            guard context.responds(to: #selector(getter: LAContext.biometryType)) else {
                // If it's is available it will always be Touch ID as the first Face ID device
                // shipped allows access to `LAContext.biometryType`. Thus, if it's Face ID
                // this code path will never be executed.
                self = isAvailable ? .touchID : .none
                return
            }

            switch context.biometryType {
                case .touchID:
                    self = .touchID
                case .faceID:
                    self = .faceID
                default:
                    // The device does not support biometry.
                    //
                    // `LABiometryNone` introduced in `11.0` and was deprecated in `11.2` and
                    // renamed to be `LABiometryType.none`. This default case allows us to handle
                    // both of those cases without resorting to hacks or explicit checks.
                    self = .none
            }
        }

        /// The name of the biometry authentication, "Touch ID" or "Face ID"; otherwise,
        /// an empty string.
        public var displayName: String {
            switch self {
                case .none:
                    return ""
                case .touchID:
                    return "Touch ID"
                case .faceID:
                    return "Face ID"
            }
        }

        /// The asset associated with biometry authentication.
        public var assetIdentifier: ImageAssetIdentifier {
            switch self {
                case .none:
                    return ""
                case .touchID:
                    return .biometricsTouchIDIcon
                case .faceID:
                    return .biometricsFaceIDIcon
            }
        }
    }
}

final public class Biometrics {
    /// Indicates that the device owner can authenticate using biometry, Touch ID or
    /// Face ID.
    public var isAvailable: Bool {
        LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    /// The type of biometric authentication supported.
    ///
    /// - Note: This property returns the actual capability of the device regardless
    /// of the permission status. For example, Face ID requires permission prompt.
    /// If user denies the permission, then the returned value is still `.faceID`.
    /// If you need to check if biometrics authentication is available then use
    /// `UIDevice.current.biometrics.isAvailable`.
    public var kind: Kind {
        let kind = Kind()

        guard kind == .none else {
            return kind
        }

        return UIDevice.current.modelType.screenSize.iPhoneXSeries ? .faceID : .touchID
    }
}

// MARK: - Authenticate

extension Biometrics {
    /// Evaluates the user authentication with biometry policy.
    ///
    /// - Parameter completion: A closure that is executed when policy evaluation
    ///                         finishes.
    public func authenticate(_ completion: @escaping (_ success: Bool) -> Void) {
        guard isAvailable else {
            return
        }

        // Using blank string " " here for `localizedReason` because `localizedReason`
        // is not used for Face ID authentication.
        //
        // - SeeAlso: `NSFaceIDUsageDescription` in `Info.plist` file.
        let context = LAContext()
        context.localizedFallbackTitle = ""
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { success, error in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    public func requestPermission(_ completion: @escaping () -> Void) {
        guard isAvailable else {
            return
        }

        let context = LAContext()
        context.localizedFallbackTitle = ""
        context.interactionNotAllowed = true
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { success, error in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

// MARK: - UIDevice

extension UIDevice {
    public var biometrics: Biometrics {
        .init()
    }
}
