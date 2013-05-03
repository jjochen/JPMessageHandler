# JPMessageHandler

Handles and shows status messages

## Installation

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `JPMessageHandler.m`, `JPMessage.m`, `JPMessageCell.m` and `XButton.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `JPMessageHandler/JPMessageHandler` folder into your project.
* Add the **QuartzCore** framework to your project.

## Usage

(see sample Xcode project in `/JPMessageDemo`)

### Init
In `viewDidLoad`

```objective-c
self.messageHandler = [[JPMessageHandler alloc] initWithSuperview:self.view];
```
### Showing a message

```objective-c
[self.messageHandler showMessage:@"Info Message" type:JPMessageTypeInfo];

[self.messageHandler showMessage:@"Long Error Message (min 4sec)" type:JPMessageTypeError minDuration:4.0 maxDuration:10.0];
```

## Credits

JPMessageHandler is brought to you by [Jochen Pfeiffer](http://jochen-pfeiffer.com) and [contributors to the project](https://github.com/jjochen/JPMessageHandler/contributors). If you have feature suggestions or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/jjochen/JPMessageHandler/issues/new). If you're using JPMessageHandler in your project, attribution would be nice.

