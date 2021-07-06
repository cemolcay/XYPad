# XYPad

A quick and easy XY-Pad control for iOS, suitable for controlling two values on a 2D-grid such as music applications.


![alt](https://github.com/cemolcay/XYPad/raw/main/xy.gif)


### Install

Add the repo url to your swift package manager.
```
https://github.com/cemolcay/XYPad.git
```

### Usage

* Create an instance of `XYPad`
* Listen its `valueChanged` event

``` swift
var xyPad = XYPad()

override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(xyPad)
    xyPad.addTarget(self, action: #selector(xyPadValueChanged(sender:)), for: .valueChanged)
}

@IBAction func xyPadValueChanged(sender: XYPad) {
    print(sender.xValue, sender.yValue)
}
```

* You can set adjust the `indicatorSize`, `indicatorView`, `xLabel`, `yLabel`, `xLine` and `yLine` values after the initialization.

* You can set `minXValue` and `maxXValue` 
* You can set `minYValue` and `maxYValue` 
* for the x-y value ranges.