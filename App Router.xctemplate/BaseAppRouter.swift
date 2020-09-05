//
//  BaseAppRouter.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) 2020 ARI MUNANDAR. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar
//              * https://www.youtube.com/channel/UC7jr8DR06tcVR0QKKl6cSNA?view_as=subscriber

import Foundation
import UIKit

public class BaseAppRouter: NSObject, IAppRouter, UINavigationControllerDelegate {
    struct ModuleStack {
        var moduleId: String
        var presentType: PresentType
        var dismiss: (([String: Any]) -> Void)?
    }
    
    var window: UIWindow?
    public var modules: [String: (_ appRouter: IAppRouter) -> IModule]!
    private var modulesStack: [ModuleStack] = []
    private var onPresented: (() -> Void)?
    private var onDismissed: ((_ parameters: [String: Any]) -> Void)?
    private var presentType: PresentType = .push
}

public extension BaseAppRouter {
    func getModule(module: Module) -> UIViewController? {
        return getModule(module: module, parameters: [:])
    }
    
    func getModule(module: Module, parameters: [String: Any]) -> UIViewController? {
        if let module = modules[module.routePath] {
            let module = module(self)
            return module.createView(parameters: parameters)
        }
        return nil
    }
}

public extension BaseAppRouter {
    func presentModule(module: Module) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any]) {
        presentModule(module: module, parameters: parameters, type: .push, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, type: PresentType) {
        presentModule(module: module, parameters: [:], type: type, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType) {
        presentModule(module: module, parameters: parameters, type: type, onPresented: nil, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any], onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: parameters, type: .push, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any], onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: parameters, type: .push, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: [:], type: type, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, type: PresentType, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: type, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: .push, onPresented: onPresented, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?) {
        presentModule(module: module, parameters: parameters, type: type, onPresented: onPresented, onDismissed: nil)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: parameters, type: type, onPresented: nil, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?) {
        presentModule(module: module, parameters: [:], type: type, onPresented: onPresented, onDismissed: onDismissed)
    }
    
    func presentModule(module: Module, parameters: [String: Any], type: PresentType, onPresented: (() -> Void)?, onDismissed: (([String: Any]) -> Void)?) {
        presentType = type
        self.onDismissed = onDismissed
        self.onPresented = onPresented
        
        if let moduleId = UIApplication.topViewController()?.moduleId {
            modulesStack.append(
                ModuleStack(
                    moduleId: moduleId,
                    presentType: type,
                    dismiss: onDismissed
                )
            )
        }
        
        if let module = modules[module.routePath] {
            let module = module(self)
            module.presentView(parameters: parameters)
        }
    }
    
    func presentView(view: UIViewController) {
        presentView(view: view, animated: true, completion: nil)
    }
    
    func presentView(view: UIViewController, animated: Bool) {
        presentView(view: view, animated: animated, completion: nil)
    }
    
    func presentView(view: UIViewController, completion: (() -> Void)?) {
        presentView(view: view, animated: true, completion: completion)
    }
    
    func presentView(view: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard window?.rootViewController != nil else {
            switch view {
            case is UITabBarController, is UIPageViewController, is UINavigationController:
                window?.rootViewController = view
            default:
                let navigation = UINavigationController(rootViewController: view)
                window?.rootViewController = navigation
            }
            presentCompletion()
            return
        }
        
        switch presentType {
        case .root:
            switch view {
            case is UITabBarController, is UIPageViewController, is UINavigationController:
                switchRootViewController(rootViewController: view, animated: true, completion: onPresented)
            default:
                let navigation = UINavigationController(rootViewController: view)
                switchRootViewController(rootViewController: navigation, animated: true, completion: onPresented)
            }
            presentCompletion()
        case .push:
            view.hidesBottomBarWhenPushed = true
            getNavigation()?.pushViewController(view, animated: true)
            presentCompletion()
        case .present:
            view.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(view, animated: true, completion: onPresented)
        case .presentWithNavigation:
            let nav = UINavigationController(rootViewController: view)
            nav.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(nav, animated: true, completion: onPresented)
        case .modal:
            view.modalPresentationStyle = .overFullScreen
            view.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.present(view, animated: true, completion: onPresented)
        case .modalWithNavigation:
            let nav = UINavigationController(rootViewController: view)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.present(nav, animated: true, completion: onPresented)
        }
    }
}

extension BaseAppRouter {
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (_: Bool) -> Void in
                if completion != nil {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
}

extension BaseAppRouter {
    public func dismiss() {
        dismiss(animated: true, parameters: [:])
    }
    
    public func dismiss(animated: Bool) {
        dismiss(animated: animated, parameters: [:])
    }
    
    public func dismiss(parameters: [String: Any]) {
        dismiss(animated: true, parameters: parameters)
    }
    
    public func dismiss(animated: Bool, parameters: [String: Any]) {
        onDismissed = modulesStack.last?.dismiss
        UIApplication.topViewController()?.dismiss(animated: animated, completion: { [weak self] in
            self?.onDismissed?(parameters)
        })
        
        if let lastNavigation = modulesStack.lastIndex(where: { $0.presentType == .presentWithNavigation || $0.presentType == .modalWithNavigation }) {
            modulesStack.removeSubrange(lastNavigation..<modulesStack.count)
        } else {
            modulesStack.removeLast()
        }
    }

    
    public func popViewController() {
        popViewController(module: nil, animated: true, parameters: [:])
    }
    
    public func popViewController(module: Module?) {
        popViewController(module: module, animated: true, parameters: [:])
    }
    
    public func popViewController(animated: Bool) {
        popViewController(module: nil, animated: animated, parameters: [:])
    }
    
    public func popViewController(parameters: [String: Any]) {
        popViewController(module: nil, animated: true, parameters: parameters)
    }
    
    public func popViewController(module: Module?, animated: Bool) {
        popViewController(module: module, animated: animated, parameters: [:])
    }
    
    public func popViewController(module: Module?, parameters: [String: Any]) {
        popViewController(module: module, animated: true, parameters: parameters)
    }
    
    public func popViewController(animated: Bool, parameters: [String: Any]) {
        popViewController(module: nil, animated: animated, parameters: parameters)
    }
    
    public func popViewController(module: Module?, animated: Bool, parameters: [String: Any]) {
        if let module = module {
            if let vc = getNavigation()?.viewControllers.filter({ $0.moduleId == module.routePath }).first {
                getNavigation()?.popToViewController(vc, animated: animated)
                onDismissed = modulesStack.last(where: { $0.moduleId == vc.moduleId })?.dismiss
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self = self else { return }
                    self.onDismissed?(parameters)
                }
                
                if let lastNavigation = modulesStack.lastIndex(where: { $0.moduleId == vc.moduleId }) {
                    modulesStack.removeSubrange(lastNavigation..<modulesStack.count)
                }
            }
        } else {
            getNavigation()?.popViewController(animated: animated)
            onDismissed = modulesStack.last?.dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.onDismissed?(parameters)
            }
            modulesStack.removeLast()
        }
    }
    
    public func popToRoot() {
        popToRoot(animated: true, parameters: [:])
    }
    
    public func popToRoot(animated: Bool) {
        popToRoot(animated: animated, parameters: [:])
    }
    
    public func popToRoot(parameters: [String: Any]) {
        popToRoot(animated: true, parameters: parameters)
    }
    
    public func popToRoot(animated: Bool, parameters: [String: Any]) {
        getNavigation()?.popToRootViewController(animated: animated)
        if let moduleId = getNavigation()?.viewControllers.first?.moduleId {
            if let lastIndex = modulesStack.lastIndex(where: { $0.moduleId == moduleId }) {
                onDismissed = modulesStack.last(where: { $0.moduleId == moduleId })?.dismiss
                let range = lastIndex..<modulesStack.count
                modulesStack.removeSubrange(range)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.onDismissed?(parameters)
        }
    }
}

extension BaseAppRouter {
    private func getNavigation() -> UINavigationController? {
        var navigation: UINavigationController?
        if let nav = UIApplication.topViewController()?.navigationController {
            navigation = nav
        } else if let vc = (window?.rootViewController as? UITabBarController)?.selectedViewController {
            if let nav = vc.navigationController {
                navigation = nav
            }
        } else if let nav = window?.rootViewController?.navigationController {
            navigation = nav
        }
        navigation?.delegate = self
        return navigation
    }
    
    private func presentCompletion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.onPresented?()
        }
    }
}


private extension UIApplication {
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
