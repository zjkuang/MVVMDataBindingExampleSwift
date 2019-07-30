# MVVMDataBindingExampleSwift

In this example we employed the Observer Pattern to implement the data binding. The Observer Pattern we implemented here did not use any 3rd party frameworks, and is just a simple, native swift class (defined in JKCSObservation.swift).

From the demo animation we can see that the upper part of the screen is a group of sliders and textFields, where we can adjust or input the values of red/green/blue (R/G/B) ranging from 0 through 255, and the lower part shows the effect of synthesized color according to the R/G/B values.

In JKCSRGBColor.swift, a structure is defined to serve as a color's R/G/B value.

In the UI part, ViewController.swift, three observers, redValueObserver, greenValueObserver, and blueValueObserver, will observe the value change of the corresponding color and will update the UI up value changes.

Please track the comment thread "Quick guide" from (1) through (5) in the code to have a idea of the work flow and how to use.

It is worth mentioning the properties "writer" and "autoSave"/"autoSaveKey". Search "IMPORTANT!!! - About the observer's 'writer' property" in the code comments for explaination on "writer" property, and "BONUS FEATURE: autoSave" in the comments for explaination on "autoSave"/"autoSaveKey".

An alternative solution, KVO manner, is also available on brancch "objc_dynamic". Personally I would recommend the Pure Swift solution over KVO. Reasons are
(1) KVO solution actually uses Objective-C features. For an observable object, we must apply "@objc dynamic" and it MUST BE A SUBCLASS OF NSObject, a big and unpleasant limitation.
(2) Most importantly, mixing Objective-C flavor into Swift is not tasty only unless we have to.

[(The Android/Kotlin solution is also available)](https://github.com/zjkuang/MVVMDataBindingExampleKotlin)

# Demo
![](https://github.com/zjkuang/MVVMDataBindingExampleSwift/blob/master/MVVMDataBindingSwift.gif)
