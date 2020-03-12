//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A type to which all `UIView` subclasses conform.
///
/// It provides a safe way to load views from nibs. It also eliminates casting
/// as `initFromNib()` method automatically returns the correct `UIView`'s
/// subclass.
///
/// The default `nibId` value is `UIView`'s class name:
///
/// ```swift
/// class ProfileView: UIView { }
///
/// print(ProfileView.nibId)
/// // "ProfileView"
///
/// let view = ProfileView.initFromNib()
/// addSubview(view)
/// ```
///
/// If you want to provide your own custom `nibId` you can do so like:
///
/// ```swift
/// class ProfileView: UIView {
///     class var nibId: String { "Profile" }
/// }
///
/// let view = ProfileView.initFromNib()
/// addSubview(view)
/// ```
public protocol NibInstantiable {
    static var nibId: String { get }
}

extension NibInstantiable {
    public static var nibId: String {
        String(describing: self)
    }
}

extension NibInstantiable where Self: UIView {
    /// Instantiates and returns the nib of type `Self`.
    ///
    /// - Parameter bundle: The bundle containing the nib file and its related
    ///                     resources. If `nil`, then this method looks in the
    ///                     `main` bundle of the current application. The default
    ///                     value is `nil`.
    /// - Returns: The nib of type `Self`.
    public static func initFromNib(bundle: Bundle? = nil) -> Self {
        let bundle = bundle ?? Bundle(for: Self.self)
        return bundle.loadNibNamed(nibId, owner: nil, options: nil)!.first as! Self
    }
}

extension UIView: NibInstantiable { }
