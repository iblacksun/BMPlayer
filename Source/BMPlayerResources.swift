//
//  BMPlayerResources.swift
//  BMPlayer
//

import UIKit

public extension BMPlayer {

    /// 图片资源所在的 bundle（CocoaPods 下为 BMPlayer-Images.bundle，SPM 下为 Bundle.module）
    static let resourceBundle: Bundle? = {
        #if SWIFT_PACKAGE
        return .module
        #else
        guard let bundlePath = Bundle(for: BMPlayer.self)
            .path(forResource: "BMPlayer-Images", ofType: "bundle") else {
            return nil
        }
        return Bundle(path: bundlePath)
        #endif
    }()

    static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
}
