//
//  BaseViewController.swift
//  FolksamAppUtilities
//
//  Created by Johan Torell on 2021-06-30.
//

import Foundation

#if !os(macOS)
import UIKit

public protocol BaseViewController: UIViewController {
    associatedtype T
    associatedtype V: BaseViewModel
    var viewModel: V! { get set }
    static var storyboardName: String { get set }
    static func make(viewModel: V) -> T
}

public extension BaseViewController {
    static func make(viewModel: V) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.module)
        let vc = UIStoryboard.instantiateViewController(from: storyboard, ofType: self)
        vc.viewModel = viewModel
        // swiftlint:disable force_cast
        return vc as! Self.T
    }
}

// open class BaseViewController: UIViewController {
//    class var storyboardName: String {
//        return "BaseViewController"
//    }
//
//    private var viewModel: BaseViewModel!
//
//    public static func make<V: BaseViewModel>(viewModel: V) -> BaseViewController {
//        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self))
//        let vc = UIStoryboard.instantiateViewController(from: storyboard, ofType: self)
//        vc.viewModel = viewModel
//        return vc
//    }
// }
#endif
