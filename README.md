# ACMedia
Customizable library for adding custom media files to a iOS application.

## Requirements
- iOS 12+

## Installation with Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code.

Add `ACMedia` as a dependency in your `Package.swift` file:

```
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/AppCraftTeam/appcraft-media-ios.git", from: "1.0.0")
    ]
)
```

Add to the `Info.plist` permission for photo picker:

```swift
<key>NSCameraUsageDescription</key>
<string>(write your reason)</string>
   ```

## Example
Open the `ACMedia.xcodeproj` and run the Example scheme.

## Images picker
```swift
let acMedia = ACMedia(
    fileType: [.gallery],
    assetsSelected: { [weak self] assets in
        let images = assets.images
        let videos = assets.videoUrls
    }
)

acMedia.didOpenSettings = {
    guard
    let settingsURL = URL(string: UIApplication.openSettingsURLString)
    else {
        return
    }
    if UIApplication.shared.canOpenURL(settingsURL) {
        UIApplication.shared.open(settingsURL)
    }
}

ACMediaConfiguration.shared.photoConfig = ACMediaPhotoPickerConfig(
    types: [.photo],
    limiter: .onlyOne
)

acMedia.show(in: self)
  ```


## Files picker
```swift
let acMedia = ACMedia(
    fileType: .files,
    filesSelected: {
        [weak self] fileUrls in
        // Your logic with actions with files
    }
)

ACMediaConfiguration.shared.documentsConfig = ACMediaPhotoDocConfig(
    fileFormats: [.zip],
    allowsMultipleSelection: true, 
    shouldShowFileExtensions: true
)

acMedia.show(in: self)
  ```

## Images And Files picker
Of course, you can configure it so that the user can select both files and images. To do this, you just need to specify both types.

```swift
 let acMedia = ACMedia(
     fileType: .galleryAndFiles,
     assetsSelected: { [weak self] assets in
       
     },
     filesSelected: { [weak self] fileUrls in
     }
 )
  ```

## Appearance config
The interface can be configured by `ACMediaConfiguration.shared.appearance`, specifying the values you want to change.

```swift
 ACMediaConfiguration.shared.appearance = ACMediaAppearance(
     tintColor: <UIColor>,
     backgroundColor: <UIColor>,
     foregroundColor: <UIColor>,
     checkmarkForegroundColor: <UIColor>,
     cellsInRow: <Int>,
     gridSpacing: <CGFloat>,
     previewCardCornerRadius: <CGFloat>,
     navBarTitleFont: <UIFont>,
     emptyAlbumFont: <UIFont>,
     cancelTitleFont: <UIFont>,
     doneTitleFont: <UIFont>,
     toolbarFont: <UIFont>,
     allowsPhotoPreviewZoom: <Bool>
 )
   ```

## Photo config
Config for photo picker.

```swift
  ACMediaConfiguration.shared.photoConfig = ACMediaPhotoPickerConfig(
     fileType: <PhotoPickerFilesType>,
     limiter: <ACMediaPhotoRestrictions>,
     allowCamera: <Bool>,
     displayMinMaxRestrictions: <Bool>
 )
   ```

Selecting the file type for the gallery picker.

```swift
 enum PhotoPickerFilesType: CaseIterable {
     case photo
     case video
 }
   ```


Gallery restrictions - you can specify a minimum and maximum count for selected files.

```swift
enum ACMediaPhotoRestrictions {
    case onlyOne, limit(min: Int, max: Int)
}
   ```

## Documents config

For the file picker, you can configure the file type, allow to select multiple files, and display the extension.

```swift
 ACMediaConfiguration.shared.documentsConfig = ACMediaPhotoDocConfig(
     fileFormats: <ACMediaDocFileType]>,
     allowsMultipleSelection: <#Bool>,
     shouldShowFileExtensions: <Bool>
 )
   ```

## Locale
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
