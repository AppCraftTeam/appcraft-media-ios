# ACMedia
[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![version](https://img.shields.io/badge/version-1.0.0-white.svg)](https://semver.org)

## Requirements
- Xcode 13 and later
- iOS 12 and later
- Swift 5.0 and later

## Overview
* [How to use](#how-to-use)
	* [Images picker](#images-picker)
	* [Files picker](#files-picker)
	* [Images And Files picker](#images-and-files-picker)
	* [Configuration](#configuration)
	* [Locale](#locale)
* [Example](#example)
* [Install](#install)

## How to use

### Images picker

```swift
let photoViewController = ACPhotoNavigationController(
  configuration: ACMediaConfiguration(),
  didPickAssets: { [weak self] assets in
    // Process the selected assets (images or video)
  },
  didOpenSettings: { [weak self] in
    // Ensure that the user goes to the settings to manually allow the app to access the photo
  }
)
self.present(photoViewController, animated: true)
  ```

<img src="/Resources/imagePicker.gif" width="300">

### Files picker
```swift
let configuration = ACMediaConfiguration(
  documentsConfig: ACMediaDocumentConfig(
    fileFormats: [.pdf],
    allowsMultipleSelection: true
  )
)

let documentsViewController = ACDocumentPickerViewController.create(
  configuration: configuration,
  didPickDocuments: { [weak self] fileUrls in
   // Process the selected files
  }
)

self.present(documentsViewController, animated: true)
  ```

<img src="/Resources/filePicker.gif" width="300">

### Images And Files picker
It is also possible to configure the library so that the user can select both files and images:

```swift
let tabbarController = ACTabBarController(
  configuration: ACMediaConfiguration(),
  photoViewController: photoViewController,
  documentsViewController: documentsViewController
)

self.present(tabbarController, animated: true)
  ```

<img src="/Resources/imageFilePicker.gif" width="300">

## Configuration

For advanced configuration, create a `ACMediaConfiguration` object and pass it as a `configuration` parameter when initializing the picker screen.

### Appearance config

Settings for customizing the picker interface.

```swift
 configuration.appearance = ACMediaAppearance(
  colors: <ACMediaColors>, 
  layout: <ACMediaLayout>,
  fonts: <ACMediaFonts>,
  allowsPhotoPreviewZoom: <Bool>
)
 ```

#### ACMediaColors

Color settings for UI elements.

```swift
ACMediaColors(
  tintColor: <UIColor>,
  backgroundColor: <UIColor>,
  foregroundColor: <UIColor>,
  checkmarkForegroundColor: <UIColor>
)
   ```

#### ACMediaLayout

Photo grid settings for the photo picker. You can specify the number of items in one row for portrait and landscape orientation of an iPhone and iPad, the distance between them, and the amount of rounding of the photo cell.

```swift
ACMediaLayout(
  phonePortraitCells: <Int>,
  phoneLandscapeCells: <Int>,
  padPortraitCells: <Int>,
  padLandscapeCells: <Int>,
  gridSpacing: <CGFloat>,
  previewCardCornerRadius: <CGFloat>
)
   ```

#### ACMediaFonts

Font settings for labels displayed in the interface.

```swift
ACMediaFonts(
  navBarTitleFont: <UIFont>,
  emptyAlbumFont: <UIFont>,
  cancelTitleFont: <UIFont>,
  doneTitleFont: <UIFont>,
  toolbarFont: <UIFont>
)
   ```

### Photo config
Config for photo picker.

```swift
  configuration.photoConfig = ACMediaPhotoPickerConfig(
     fileType: <ACPhotoPickerFilesType>,
     limiter: <ACMediaPhotoRestrictions>,
     allowCamera: <Bool>,
     displayMinMaxRestrictions: <Bool>
 )
   ```

#### ACPhotoPickerFilesType

Selecting the file type for the gallery picker.

```swift
 enum ACPhotoPickerFilesType: CaseIterable {
     case photo
     case video
 }
   ```

#### ACMediaPhotoRestrictions

Setting limits on the number of selected images (video).

```swift
 ACMediaPhotoRestrictions.onlyOne
 ACMediaPhotoRestrictions.limit(min: 3, max: 10)
   ```

### Documents config

For the file picker, you can configure the file type, allow to select multiple files, and display the extension.

```swift
 configuration.documentsConfig = ACMediaPhotoDocConfig(
     fileFormats: <ACMediaDocFileType>,
     allowsMultipleSelection: <Bool>,
     shouldShowFileExtensions: <Bool>
 )
   ```

#### ACMediaDocFileType

Selecting the file types that are allowed to be selected in the picker.

```swift
 enum ACMediaDocFileType: {
    case png, jpeg, gif, bmp, text, pdf, zip, docx, xlsx, mp3, mp4, csv, json
 }
   ```

You can also allow any files to be selected:

```swift
 ACMediaDocFileType.allCases
   ```


### Locale
Add to the `Localizable.strings` file the localization of the following strings for all languages supported in the application:

```swift
"ACMedia.done" = "Done";
"ACMedia.back" = "Back";
"ACMedia.cancel" = "Cancel";
"ACMedia.emptyAlbumLabel" = "Empty album";
"ACMedia.permissionRequired" = "Need photo permession";
"ACMedia.permissionRequiredDescription" = "Needed for picker correct work";
"ACMedia.settings" = "Allow permission in Settings";
"ACMedia.selectedCount" = "Selected %i";
"ACMedia.selectedCountFrom" = "Selected %i/%i";
"ACMedia.selectedMin" = "minimum %i";
"ACMedia.selectedMax" = "maximum %i";
"ACMedia.selected" = "Select";
"ACMedia.gallery" = "Gallery";
"ACMedia.file" = "File";
   ```

## Example
All these samples, as well as the integration of the `ACMedia` module into the application, can be seen in action in the [Example project](/Example).

## Install
To install this Swift package into your project, follow these steps:

1. Open your Xcode project.
2. Go to "File" > "Swift Packages" > "Add Package Dependency".
3. In the "Choose Package Repository" dialog, enter `https://github.com/AppCraftTeam/appcraft-media-ios.git`.
4. Click "Next" and select the version you want to use.
5. Choose the target where you want to add the package and click "Finish".

Xcode will then resolve the package and add it to your project. You can now import and use the package in your code.

Don't forget to include to the `Info.plist` permission for photo picker (if a camera is to be used):

```swift
<key>NSCameraUsageDescription</key>
<string>(write your reason)</string>
   ```


## License
This library is licensed under the MIT License.

## Author
Email: <moslienko.p@gmail.com>
