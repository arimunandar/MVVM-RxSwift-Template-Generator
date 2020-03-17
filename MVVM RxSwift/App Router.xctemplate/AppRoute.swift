//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ARI MUNANDAR. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar
//              * https://www.youtube.com/channel/UC7jr8DR06tcVR0QKKl6cSNA?view_as=subscriber

import Foundation
import UIKit

enum PresentType {
    case root
    case push
    case present
    case presentWithNavigation
    case modal
    case modalWithNavigation
}

protocol IAppRouter {
    // MARK: - Get Module Handler

    func getModule(module: Module) -> UIViewController?
    func getModule(module: Module, parameters: [String: Any]) -> UIViewController?
    
    // MARK: - Present Module Handler

    func presentModule(module: Module)
    func presentModule(module: Module, parameters: [String: Any])
    func presentModule(module: Module, type: PresentType)
    func presentModule(module: Module, onPresented: (() -> Void)?)
    func presentModule(module: Module, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType)
    func presentModule(module: Module, parameters: [String: Any], onPresented: (() -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?)
    func presentModule(module: Module, type: PresentType, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?)
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?)
    
    // MARK: - Present View Handler

    func presentView(view: UIViewController)
    func presentView(view: UIViewController, animated: Bool)
    func presentView(view: UIViewController, completion: (() -> Void)?)
    func presentView(view: UIViewController, animated: Bool, completion: (() -> Void)?)

    // MARK: - Dismiss Handler

    func dismiss()
    func dismiss(module: Module)
    func dismiss(animated: Bool)
    func dismiss(parameters: [String: Any])
    func dismiss(module: Module, animated: Bool)
    func dismiss(module: Module, parameters: [String: Any])
    func dismiss(animated: Bool, parameters: [String: Any])
    func dismiss(module: Module?, animated: Bool, parameters: [String: Any])
}

class AppRouter: BaseAppRouter {
    static let share = AppRouter.create()
    
    private static func create() -> AppRouter {
        let modules: [String: (_ appRouter: IAppRouter) -> IModule] = [:]
        
        var window: UIWindow?
        
        if let _window = UIApplication.shared.keyWindow {
            window = _window
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        window?.makeKeyAndVisible()
        
        let router = AppRouter(window: window, products: modules)
        return router
    }
}

extension UIApplication {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}

private extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version: String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}

private extension UIViewController {
    var moduleId: String {
        return Bundle.appName() + "/" + String(describing: type(of: self)).replacingOccurrences(of: "ViewController", with: "")
    }
}