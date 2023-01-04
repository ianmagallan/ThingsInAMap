# ThingsInAMap

## Installation

Cocoapods is required. In order to install the pods, perform the following commands:

```sh
pod install
```

Then, just proceed to open the generated .xcworkspace file :)

## Features

- Loads points of interest provided by an URL
- List of points of interest received is shown anchored at the bottom of the screen.
- User can drag and drop the location markers to increase-reduce the area
- User's selected origin and destination coordinates are stored in user defaults
- Tapping a point of interest in the list will animate and zoom in to the point of interest coordinates
- Street name and number is shown if available (tends to fail, due to CLLocation cooldown 💀)
