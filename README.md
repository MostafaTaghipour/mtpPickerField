# mtpPickerField

[![CI Status](http://img.shields.io/travis/mostafa.taghipour@ymail.com/mtpPickerField.svg?style=flat)](https://travis-ci.org/mostafa.taghipour@ymail.com/mtpPickerField)
[![Version](https://img.shields.io/cocoapods/v/mtpPickerField.svg?style=flat)](http://cocoapods.org/pods/mtpPickerField)
[![License](https://img.shields.io/cocoapods/l/mtpPickerField.svg?style=flat)](http://cocoapods.org/pods/mtpPickerField)
[![Platform](https://img.shields.io/cocoapods/p/mtpPickerField.svg?style=flat)](http://cocoapods.org/pods/mtpPickerField)


mtpPickerField is a good component to choose from among several options.
This custom control is made up of a UITextField combination  one of the UIPickerView, UIDatePicker, UItableView, UICollectionView controls that are built into a ActionSheet

![screen shots](https://raw.githubusercontent.com/mostafataghipour/mtpPickerField/master/screenshots/1.gif)



## Requirements
- iOS 9.0+
- Xcode 9+

## Installation

mtpPickerField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'mtpPickerField'
```


## Usage
- Drag a UITextView object onto the canvas.
- In the Identity inspector, set the Custom Class name to PickerField
- Set its type
- Now You can use the control according to the type of field

```swift
class ViewController: UIViewController , UIPickerViewDataSource {
    @IBOutlet weak var pickerViewField: PickerField!
    let states = ["Alaska",
                "Alabama",
                "Arkansas",
                "American Samoa",
                "Arizona",
                "California"]

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerViewField.type = .pickerView
        pickerViewField.pickerView?.dataSource=self
        pickerViewField.placeholder="your state ..."
        pickerViewField.titleLabel?.text="select a state"
        pickerViewField.pickerFieldDelegate=self
        tabelViewField.height=400
        tabelViewField.cancelWhenTouchUpOutside=false
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }

}

```

- Also you can use  PickerFieldDelegate aware of occurrence of events

```swift
extension ViewController:PickerFieldDelegate{
    func pickerField(didOKClick pickerField: PickerField) {
        if pickerField.type == .pickerView{
            if let row=pickerField.pickerView?.selectedRow(inComponent: 0){
                pickerField.text=states[row]
            }
        }
    }
}
```

For more exmples please review example project

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Mostafa Taghipour, mostafa@taghipour.me

## License

mtpPickerField is available under the MIT license. See the LICENSE file for more info.

