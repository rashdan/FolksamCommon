//
//  UIStoryboard+extensions.swift
//  Home
//
//  Created by Johan Torell on 2021-02-03.
//

// swiftlint:disable force_cast
import SwiftUI

public extension UIStoryboard {
    static func instantiateViewController<T>(
        from storyboard: UIStoryboard,
        ofType type: T.Type
    ) -> T where T: UIViewController {
        return storyboard.instantiateViewController(ofType: type)
    }

    private func instantiateViewController<T>(ofType _: T.Type) -> T where T: UIViewController {
        // We will crash on purpose if the view controller is not
        // of the correct type, as this is a programmer error.
        return instantiateInitialViewController() as! T
    }

    static func instantiateNavigationController<Child>(
        from storyboard: UIStoryboard,
        childOfType type: Child.Type
    ) -> (UINavigationController, Child)
        where Child: UIViewController
    {
        return storyboard.instantiateNavigationController(childOfType: type)
    }

    func instantiateNavigationController<Child>(childOfType _: Child.Type) -> (UINavigationController, Child)
        where Child: UIViewController
    {
        let navigationController = instantiateViewController(ofType: UINavigationController.self)
        // We will crash on purpose if the view controller is not
        // of the correct type, as this is a programmer error.
        let childViewController = navigationController.children[0] as! Child
        return (navigationController, childViewController)
    }

    func instantiateWithNavigationController<Child: UIViewController>(childOfType _: Child.Type, creator: @escaping (NSCoder) -> Child) -> (UINavigationController, Child) {
        let nav = UINavigationController()
        if #available(iOS 13.0, *) {
            let vc = self.instantiateInitialViewController(creator: creator)!
            nav.addChild(vc)
            nav.navigationBar.prefersLargeTitles = true
            return (nav, vc)
        } else {
            // Fallback on earlier versions
            return (nav, Child())
        }
    }
}
