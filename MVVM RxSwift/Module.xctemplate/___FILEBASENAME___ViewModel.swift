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

import ReactiveKit
import UIKit

protocol ___VARIABLE_productName:identifier___ViewModelInputs {
    /**
    Example
    
    func onViewDidLoad()
    */
}

protocol ___VARIABLE_productName:identifier___ViewModelOutputs {
    /**
     Example
     
     var hello: Signal<String, Never> { get }
     */
}

protocol I___VARIABLE_productName:identifier___ViewModel: ___VARIABLE_productName:identifier___ViewModelInputs, ___VARIABLE_productName:identifier___ViewModelOutputs {
    var parameters: [String: Any]? { get }
    var input: ___VARIABLE_productName:identifier___ViewModelInputs { get }
    var output: ___VARIABLE_productName:identifier___ViewModelOutputs { get }
}

extension I___VARIABLE_productName:identifier___ViewModel {
    var input: ___VARIABLE_productName:identifier___ViewModelInputs {
        return self
    }

    var output: ___VARIABLE_productName:identifier___ViewModelOutputs {
        return self
    }
}

class ___VARIABLE_productName:identifier___ViewModel: I___VARIABLE_productName:identifier___ViewModel {
    var parameters: [String: Any]?

    /**
     Set varibale subjects
     Example:
     
     private let helloSubject = Subject<String, Never>()
     */
    
    /**
     Set Manager
     Example:
     
     private var manager: I___VARIABLE_productName:identifier___Manager {
         return ___VARIABLE_productName:identifier___Manager()
     }
     */
}

extension ___VARIABLE_productName:identifier___ViewModel {
    /**
     Implementaion ViewModel Inputs
     Example:
     
     var hello: Signal<String, Never> {
         return helloSubject.toSignal()
     }
     */
}

extension ___VARIABLE_productName:identifier___ViewModel {
    /**
    Implementaion ViewModel Inputs
    Example:
    
    func onViewDidLoad() {
        helloSubject.send("Hello, World!")
    }
    */
}
