//
// HTTPCookieStorage+Extensions.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

extension HTTPCookieStorage {
    /// Removes all cookies from the storage.
    public func deleteCookies() {
        cookies?.forEach {
            deleteCookie($0)
        }
    }

    /// Stores given list of cookies in the cookie storage if the cookie accept
    /// policy permits.
    ///
    /// The cookies replace existing cookies with the same name, domain, and path,
    /// if they exists in the cookie storage. This method accepts the cookies only
    /// if the storage’s cookie accept policy is `HTTPCookie.AcceptPolicy.always` or
    /// `HTTPCookie.AcceptPolicy.onlyFromMainDocumentDomain`. The cookies are
    /// ignored if the storage’s cookie accept policy is
    /// `HTTPCookie.AcceptPolicy.never`.
    ///
    /// - Parameter cookies: The cookies to store.
    public func setCookies(_ cookies: [HTTPCookie]) {
        cookies.forEach {
            setCookie($0)
        }
    }
}

extension HTTPCookie {
    /// A boolean value that indicates whether the cookie is expired.
    ///
    /// This value is `false` if there is no specific expiration date, as with
    /// session-only cookies. The expiration date is compared to the current date to
    /// determine if the cookie is expired.
    public var isExpired: Bool {
        guard let expiresDate = expiresDate else {
            return false
        }

        if expiresDate < Date() {
            return true
        }

        return false
    }
}
