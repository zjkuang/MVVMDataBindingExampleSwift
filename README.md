# MVVMDataBindingExampleSwift

MVVM has been prominent for years featuring separation of data and business logic from views.

The most valuable part of MVVM is Data Binding. This demonstration gives an example for data binding between the view model and the UI view(s).

The comments which is above the "write" variable explains the purpose,

    // For recording who changed the value
    // In some cases, a UI element can both be the changer and the observer of a same observable. It may cause an infinite loop like
    //  (1) The user operates the UI and changes the value of a UI element, say controlA
    //  (2) controlA's observer is triggered by the change, and then writes the new value to the observable, say observableO
    //  (3) The changeHandler block of the observer is triggered by observerO's value change, and then updates all the related UI elements, including controlA
    //  (4) controlA's observer is triggered again by step(3) and an infinite loop between step(2) and step(3) started
    //  (...)
    //  (n) Finally the app crashed
    // To avoid this, in this scenario, in step(2), mark the "writer" as self (controlA) before writing the new value to the observable, and in step(3), update all the UI elements OTHER THAN the writer itself.

# Updates

Two solutions are provided.
(1) KVO solution is on objc_dynamic branch, and
(2) Pure Swift solution is on PureSwift branch

Personally I would recommend PureSwift over KVO. Reasons are
(1) KVO solution actually uses Objective-C features. For an observable object we must apply "@objc dynamic" and it must inherit NSObject class. KVO solution has a limitation that it only works for objects inherited from NSObject.
(2) Mixing Objective-C flavor into Swift is not tasty only unless we have no choice.

# Demo
![](https://github.com/zjkuang/MVVMDataBindingExampleSwift/blob/master/MVVMDataBindingSwift.gif)
