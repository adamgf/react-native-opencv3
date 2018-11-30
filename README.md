
# react-native-opencv3

## Getting started

`$ npm install react-native-opencv3 --save`

### Mostly automatic installation Android

`$ react-native link react-native-opencv3`

### Mostly automatic installation iOS

Add to Podfile ->

`pod 'RNCv', :podspec => '../node_modules/react-native-opencv3/ios/RNOpencv3.podspec'`

`$ pod install`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-opencv3` and add `RNOpencv3.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNOpencv3.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import org.opencvport.RNOpencv3Package;` to the imports at the top of the file
  - Add `new RNOpencv3Package()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-opencv3'
  	project(':react-native-opencv3').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-opencv3/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-opencv3')
  	```


## Usage
```javascript
import RNCv from 'react-native-opencv3';

// Basic convert input jpg or png to grayscale
RNCv.cvtColorGray(inFile, outFile)
.then((image) => {
  const { width, height, uri } = image
  console.log('width is: ' + width + 'height is: ' + height + ' uri is: ' + uri)
})
.error((err) => {
  console.error(err)
})
