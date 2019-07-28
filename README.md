# MVVMDataBindingExampleSwift

As we can see from the demo animation, the upper part of the screen is a group of sliders and textFields, where we can adjust or input the values of red/green/blue (R/G/B), and the lower part shows the effect of synthesized RGB color.

In JKCSObservation.swift, the kernel of this example, is a simple and native implementation of Observer Pattern. It makes Data Binding in MVVM super easy, with no more need of any 3rd party reactive frameworks.

In JKCSRGBColor.swift, a structure is declared for a RGB valued color. Each part (red, green, and blue) of RGB is an instance of "JKCSObservable" class, which means it is observable.

In the UI part, ViewController.swift, we created three observers, redValueObserver, greenValueObserver, and blueValueObserver, to observe the value change of corresponding color value. When the UI receives a value change of either a slide or a textField, all it needs to do is to write the corresponding red, or green, or blue value in JKCSRGBColor. The observer will the trigger the updates of the whole UI.

A couple of memebers in the JKCSObservable, "writer" and "autoSave"/"autoSaveKey", may need some further explaination here.

"writer" is designed to avoid a possible infinite loop of "modification-observation-updates-modification". Consider this case:

    // (1) The user operates the UI and changes the value of a UI element, e.g. redSlider
    // (2) redSlider will update rgbColor.red.value according to its new value
    // (3) redValueObserver will be triggered to update the whole UI, including redSlider
    // (4) Being updated, redSlider will once again update rgbColor.red.value according to its new value, which falls into an infinite loop of (2)-(3)-(4)-(2)-(3)-(4)-(2)... until the app crashes
    
To avoid this, in this scenario, in step(2), mark the "writer" as self (redSlide) before writing the new value to the observable, and in step(3), update all the UI elements EXCEPT the writer (redSlide) itself.

"autoSave"/"autoSaveKey" is a pair of members offering a "bonus" feature, autoSave, which has nothing to do with data binding itself but very useful. When initialized with a non-empty key string, the new value changed will automatically be saved into UserDefaults.standard to the key string. And each time the app restarts, the saved value will be automatically retrieved from UserDefaults.standard. This can be very helpful for many values serve as user preferrences.

# Updates

[2019-07-26]

Two solutions are provided.
(1) KVO solution is on objc_dynamic branch, and
(2) Pure Swift solution is on PureSwift branch

Personally I would recommend PureSwift over KVO. Reasons are
(1) KVO solution actually uses Objective-C features. For an observable object we must apply "@objc dynamic" and it must inherit NSObject class. KVO solution has a limitation that it only works for objects inherited from NSObject.
(2) Most importantly, mixing Objective-C flavor into Swift is not tasty only unless we have no choice.

# Demo
![](https://github.com/zjkuang/MVVMDataBindingExampleSwift/blob/master/MVVMDataBindingSwift.gif)
