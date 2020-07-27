
# react-native-opencv3 (v1.0.8)

React-native opencv3 or "RNOpencv3" wraps opencv native functions and propagates the return data from these functions to react native land for usage in android and iOS apps enabling native app developers with new functionality.  This package is not guaranteed bug-free and does not encompass all of OpenCV but is a good starting point with a nice chunk of Imgproc and Core functions supported and face and landmark detection and image and video overlays as well as saving images and recording video.  All two way communication between react-native and OpenCV is supported and thus can be expanded upon.  It establishes an infrastructure and provides scaffolding for eventually incorporating all functionality from OpenCV core and extension modules.  

The basic methodology is that any function from opencv can be opaquely called from react native using a string to lookup the function and a dictionary to look up Mats and utilize other structures (CvScalar, CvPoint, etc.) that are referenced by the react native application and by using Java method invocation and method wrapping in C++ to invoke the native methods.  Because Opencv provides a variety of methods that take an input of one or more Mats and other types and output one Mat, this seemed like a good place to start.  So RNOpencv3 is not intended to be some bulky monolithic library but a thin layer in between react native and opencv with functionality developers need to create awesome apps with more advanced image processing, object and face detection and other capabilities.  Hopefully this convinces others to take this basic framework run with it and become contributors.

## Getting started

`$ npm install react-native-opencv3 --save`

You will also need to install react-native-fs:

`$ npm install react-native-fs --save`

### Android

Since the aar currently used was not built with jetify support, in `gradle.properties` change the line to `android.enableJetifier=false`.  If using `CvCamera` app should be in landscape mode so add line         android:screenOrientation="landscape" to activity section in AndroidManifest.xml.  Reference the sample apps to see this.

Also if using `CvCamera` add the following lines to the `AndroidManifest.xml`.  Again reference the sample apps for this.
```javascript
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
<uses-feature android:name="android.hardware.camera.front" android:required="false"/>
<uses-feature android:name="android.hardware.camera.front.autofocus" android:required="false"/>
```

If saving images and/or recording video you will also need to add the storage permissions to `AndroidManifest.xml`:
```javascript
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```


### Mostly automatic installation iOS

Add to Podfile ->

```
pod 'RNOpencv3', :path => '../node_modules/react-native-opencv3/ios', :subspecs => [
      'CvCamera'
  ]  
pod 'RNFS', :path => '../node_modules/react-native-fs'
```
  
`$ pod install`

### iOS

For `CvCamera` app should be portrait only.  Also for `CvCamera` you will have to add the `Privacy - Camera Usage Description` property to your `Info.plist` file with a string description.

## CvInvoke

`CvInvoke` is a React Native component for wrapping `CvImage` and `CvCamera` react native components.  A CvInvoke component executes an OpenCV function on a CvImage or CvCamera view.  Multiple CvInvoke components can be chained such that multiple OpenCV functions can be called in order.  The innermost CvInvoke component invokes the first function the second innermost takes as input the output from the first etc.  This may be easier to visualize with an example:

```
import {CvImage, CvInvoke, ColorConv, Core} from 'react-native-opencv3';

...

<CvInvoke func='bitwise_not' params={{"p1":"dstMat","p2":"dstMat"}}>
  <CvInvoke func='rotate' params={{"p1":"dstMat","p2":"dstMat","p3":Core.ROTATE_90_COUNTERCLOCKWISE}}>
    <CvInvoke func='cvtColor' params={{"p1":"srcMat","p2":"dstMat","p3":ColorConv.COLOR_BGR2GRAY}}>
      <CvImage
        style={{width: 200, height: 200}}
        source={ require(`${originalImagePath}`) }
      />
    </CvInvoke>
  </CvInvoke>
</CvInvoke>

```

In this example the first function executed on the source image is `cvtColor`, the second function executed is `rotate` and the third function executed is `bitwise_not` and then the transformed image is displayed in the app.

The only required property is `func` which directly maps to an OpenCV Imgproc or Core function or a function on a Mat.  The `params` property for the function should be specifed in a json dictionary as "p1": XX, "p2": YY, "p3": ZZ ...  All variants with different numbers of parameters are supported so for example `cvtColor` can be called with three or four parameters.  

For functions that operate directly on a Mat type the Mat should be referenced via the `inObj` property and the output Mat should be referenced via the `outObj` property.  An example of one of these functions is `submat`.

If wrapping CvImage, the special string "srcMat" references the source image for the enclosed CvImage tag.  The special string "dstMat" references the destination Mat for the first function that then gets sent to the next function as an input etc.

If wrapping CvCamera, the special string "rgba" references the source incoming video image, "rgbat" represents the transposed Mat for the source incoming video image, "gray" references the grayscale incoming video image and "grayt" references the transposed Mat for the grayscale incoming video image.

The `callback` property should only be used in conjunction with CvCamera and should only be referenced by the outermost tag in the CvInvoke chain.  This sends the output data from the outermost tag back to your application.  The callback function should be named `onPayload`.  The data will be returned as a json dictionary with the key `payload` and the data being returned as the value.  The data returned in the payload is either one array or an array of arrays.

CvInvoke can either enclose a CvCamera or CvImage as shown in the example or be on its own separate line if part of a CvInvokeGroup.

## CvInvokeGroup

`CvInvokeGroup` is a simple react native component intended to wrap a series of CvInvoke react native components so multiple arrays of data (an array of arrays) can be sent back to the callback specified in your app.  Its primary usage is to have two or more sets of CvInvokes applied to the same CvCamera instance.  A CvInvokeGroup is not necessary if only one set of CvInvokes is used but can still be used for one set of CvInvokes to put the CvInvoke tags on separate lines.  The `groupId` property is an arbitrary string used to identify the set of CvInvokes for *that* CvInvokeGroup.  The groupids for each CvInvokeGroup should be unique.

Example:
```javascript
<CvInvokeGroup groupid='invokeGroup1'>
  <CvInvoke func='normalize' params={{"p1":histogramMat,"p2":histogramMat,"p3":halfHeight,"p4":0,"p5":1}} callback='onPayload'/>
  <CvInvoke func='calcHist' params={{"p1":"rgba","p2":channelOne,"p3":maskMat,"p4":histogramMat,"p5":histSize,"p6":ranges}}/>
  <CvInvokeGroup groupid='invokeGroup0'>
    <CvInvoke func='normalize' params={{"p1":histogramMat,"p2":histogramMat,"p3":halfHeight,"p4":0,"p5":1}} callback='onPayload'/>
    <CvInvoke func='calcHist' params={{"p1":"rgba","p2":channelZero,"p3":maskMat,"p4":histogramMat,"p5":histSize,"p6":ranges}}/>
      <CvCamera ref={this.cvCamera} style={{ width: '100%', height: '100%', position: 'absolute' }} 
  	    overlayInterval={overlayInt}
  	    onPayload={this.onPayload}
  	    onFrameSize={this.onFrameSize}
      />
  </CvInvokeGroup>
</CvInvokeGroup>
```

In this example `invokeGroup0` executes two functions on CvCamera and `invokeGroup1` executes two different functions on CvCamera.  The data from the two invoke groups is returned to the `onPayload` method as two distinct arrays but both are part of the *payload* value sent to the callback.

## RNCv

`RNCv` is a React Native component that permits asynchronous interaction with OpenCV.  Typically RNCv will be used to convert a source image into a Mat via the `RNCV.imageToMat` function, performing any kind of operations on the Mat using `RNCV.invokeMethod` and then converting the Mat back to an image via the `RNCV.matToImage` function.  To see how this is used in action check out the HoughCircles2 sample app.  HoughCircles2 also demonstrates how to use RNCv to modify a source image without using CvInvokes which may not be possible with arbitrary data such as locations of circles.

Example usage in asynchronous function:
```javascript
import {RNCv, Mat, CvType, CvSize, CvPoint, CvScalar, ColorConv} from 'react-native-opencv3';

...

  componentDidMount = async() => {
	  
    const newImagePath = this.RNFS.DocumentDirectoryPath + '/Billiard-balls-table-circles.jpg'
	  
    const interMat = await new Mat().init()
    const circlesMat = await new Mat().init()
	  		
    let overlayMat
    if (Platform.OS === 'ios') {
      overlayMat = await new Mat(1600,1280,CvType.CV_8UC4).init()
    }
    else {
      overlayMat = await new Mat(1280,1600,CvType.CV_8UC4).init()
    } 
	
    const sourceuri = this.resolveAssetSource(require('./images/Billiard-balls-table.jpg')).uri
    const sourceFile = await this.downloadAssetSource(sourceuri)
    const srcMat = await RNCv.imageToMat(sourceFile)
    const gaussianKernelSize = new CvSize(9, 9)
	
    RNCv.invokeMethod('cvtColor', {"p1":srcMat,"p2":interMat,"p3":ColorConv.COLOR_BGR2GRAY}) 
    RNCv.invokeMethod('GaussianBlur', {"p1":interMat,"p2":interMat,"p3":gaussianKernelSize,"p4":2,"p5":2})
    RNCv.invokeMethod('HoughCircles', {"p1":interMat,"p2":circlesMat,"p3":3,"p4":2,"p5":100,"p6":100,"p7":90,"p8":1,"p9":130})
	
    const scalar1 = new CvScalar(255,0,255,255)
    const scalar2 = new CvScalar(255,255,0,255)
	
    const circles = await RNCv.getMatData(circlesMat, 0, 0)
	
    for (let i=0;i < circles.length;i+=3) {
      const center = new CvPoint(Math.round(circles[i]), Math.round(circles[i+1]))
      const radius = Math.round(circles[i+2])
      RNCv.invokeMethod("circle", {"p1":overlayMat,"p2":center,"p3":3,"p4":scalar1,"p5":12,"p6":8,"p7":0})
      RNCv.invokeMethod("circle", {"p1":overlayMat,"p2":center,"p3":radius,"p4":scalar2,"p5":24,"p6":8,"p7":0})
    }
    
    RNCv.invokeMethod("addWeighted", {"p1":srcMat,"p2":1.0,"p3":overlayMat,"p4":1.0,"p5":0.0,"p6":srcMat})
    const { uri, width, height } = await RNCv.matToImage(srcMat, newImagePath)
	
    RNCv.deleteMat(overlayMat)	
    RNCv.deleteMat(interMat)	
    RNCv.deleteMat(circlesMat)
	
    this.setState({ ...this.state, destImageUri: uri })
  }
  
  ...
  
  render() {
    const { destImageUri } = this.state
    let circlesImageUri = this.resolveAssetSource(require('./images/Billiard-balls-table.jpg')).uri

    if (destImageUri.length > 0) {
      const prependFilename = Platform.OS === 'ios' ? '' : 'file://'
      circlesImageUri = prependFilename + destImageUri  
    }
	
    return (
      <View style={styles.container}>
        <Image
          style={{width: 200, height: 250}}
          source={{ uri: `${circlesImageUri}` }}
        />
      </View>
    )
  }

```

`downloadAssetSource` is a convenience meta method provided that uses RNFS under the hood to download the asset source locally to be used by RNCv to convert into a Mat.  You can include this method in your app by adding it to the constructor via -->
```javascript
this.downloadAssetSource = require('react-native-opencv3/downloadAssetSource')
```

and then call the method in your app using `this.downloadAssetSource(uri)`.  The uri is the uri of the source image which can be obtained using the React function resolveAssetSource which can also be included via -->
```javascript
this.resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource')
```
For more info about resolveAssetSource refer to the online React documentation.

## CvImage

`CvImage` is a React Native component that is intended to exactly replicate the Image React component but applies a set of one or more CvInvoke operations to the source image and displays the transformed image.  It takes the same properties as the Image React component.  For example usage refer to the above CvInvoke example.

## CvCamera

`CvCamera` is a React Native component that displays the front or back facing camera view and can be wrapped in CvInvoke tags.  The innermost CvInvoke tag should reference either 'rgba', 'rgbat', 'gray' or 'grayt' as the first parameter 'p1' in the params dictionary property.  The optional `facing` property should be set to either 'front' the default for the camera view away from the user or 'back' for towards the user.  

The optional `onFrameSize` property refers to the callback that gets the frame size information.  The information is returned to the callback in the json dictionary format: `{ "payload" : { "frameSize" : { "frameWidth" : XXX, "frameHeight" : YYY }}}`.  The callback in your app should also be called `onFrameSize`.
   
Basic Usage Example:
```javascript
import {CvCamera, CvScalar, Mat, CvInvoke, CvInvokeGroup} from 'react-native-opencv3';

...
<CvInvokeGroup groupid='zeeGrup'>
  <CvInvoke func='convertScaleAbs' params={{"p1":this.interMat,"p2":"rgba","p3":16,"p4":0}}/>
  <CvInvoke func='convertScaleAbs' params={{"p1":"rgba","p2":this.interMat,"p3":1./16,"p4":0}}/>
  <CvInvoke inobj='rgba' func='setTo' params={{"p1":posterScalar,"p2":this.interMat}}/>
  <CvInvoke func='Canny' params={{"p1":"rgba","p2":this.interMat,"p3":80,"p4":90}}/>		
  <CvCamera
    ref={ref => { this.cvCamera = ref }}
    style={styles.preview}
    facing={facing}
  />
</CvInvokeGroup>

```

### Face detection

The optional `onDetectFaces` property refers to the callback that gets the payload data if one or more faces is detected in the camera view.  The format of the payload data is described below.  The callback in your app should be named `onDetectFaces`.

In conjunction with the `onDetectFaces` property the properties `faceClassifier`, `eyesClassifier`, `noseClassifer` and `mouthClassifier` should be specified with a minimum of the faceClassifier property being set and each refers to its corresponding cascade classifier data file.  The available classifiers currently are: 

1. haarcascade_mcs_eyepair_small 
2. haarcascade_righteye_2splits
3. eye
4. haarcascade_mcs_leftear
5. haarcascade_upperbody
6. face
7. haarcascade_mcs_lefteye 
8. haarcascade_eye_tree_eyeglasses	
9. haarcascade_mcs_lefteye_alt		
10. lbpcascade_frontalface
11. haarcascade_frontalface_alt		
12. haarcascade_mcs_mouth		
13. left_ear
14. haarcascade_frontalface_alt2	
15. haarcascade_mcs_nose		
16. left_eye.xml
17. haarcascade_frontalface_alt_tree	
18. haarcascade_mcs_rightear		
19. mouth
20. haarcascade_frontalface_default	
21. haarcascade_mcs_righteye		
22. nose
23. haarcascade_fullbody		
24. haarcascade_mcs_righteye_alt	
25. right_ear
26. haarcascade_lowerbody		
27. haarcascade_mcs_upperbody
28. haarcascade_mcs_eyepair_big		
29. haarcascade_profileface

Only the classifiers in the CvFaceDetection sample app have currently been tested.

The `landmarksModel` property should be used for the 68 face landmarks in conjunction with a face classifier.  Currently it can only be set to `lbfmodel` because there is only one landmarks data file supported `lbfmodel.yaml`.  As for face boxes, face landmarks should also be used in conjunction with the same `onFacesDetectedCv` callback.  As for face detection For the json format of the landmarks data returned to the callback method see below.  

Face Detection Example:
```javascript
  onFacesDetectedCv = (e) => {
    //alert('payload: ' + JSON.stringify(e.payload))
    if (Platform.OS === 'ios') {
      if ((!e.nativeEvent.payload && this.state.faces) || (e.nativeEvent.payload && !this.state.faces) || (e.nativeEvent.payload && this.state.faces)) {
        this.setState({ faces : e.nativeEvent.payload })
      }
    }
    else {
      if ((!e.payload && this.state.faces) || (e.payload && !this.state.faces) || (e.payload && this.state.faces)) {
        this.setState({ faces : e.payload })
      }
    }
  }

  ...
  
  <CvCamera
    facing='back'
    faceClassifier='haarcascade_frontalface_alt2'
    eyesClassifier='haarcascade_eye_tree_eyeglasses'
    noseClassifier='nose'
    mouthClassifier='mouth'
    onFacesDetectedCv={this.onFacesDetectedCv}
  />
```

Face Landmarks Example:
```javascript
  onFacesDetectedCv = (e) => {
    //alert('payload: ' + JSON.stringify(e.payload))
    if (Platform.OS === 'ios') {
      if ((!e.nativeEvent.payload && this.state.faces) || (e.nativeEvent.payload && !this.state.faces) || (e.nativeEvent.payload && this.state.faces)) {
        this.setState({ faces : e.nativeEvent.payload })
      }
    }
    else {
      if ((!e.payload && this.state.faces) || (e.payload && !this.state.faces) || (e.payload && this.state.faces)) {
        this.setState({ faces : e.payload })
      }
    }
  }
  
  ...
  
  <CvCamera
    facing='back'
    faceClassifier='haarcascade_frontalface_alt2'
    landmarksModel='lbfmodel'
    onFacesDetectedCv={this.onFacesDetectedCv}
  />
```

Including facing='back' sets the camera view towards the user so you can test it using your own face.  To specify the other direction set facing='front' or leave out the facing property.

#### Face detection data format

The data returned to the callback method `onFacesDetectedCv` will have the json dictionary format:
```javascript
{ "payload" : { "faces": 
  [
    { "x":0.000000,
      "y":0.359375,
      "width":0.387500,
      "height":0.217969,
      "faceId":"0",
      "nose":{"x":0.301075,"y":0.308244,"width":0.215054,"height":0.129032},
      "mouth":{"x":0.376344,"y":0.874552,"width":0.121864,"height":0.057348},
      "landmarks": [
        {"x":0.190278,"y":0.826562},
        {"x":0.172222,"y":0.828125},
        {"x":0.154167,"y":0.830469},
        {"x":0.134722,"y":0.833594},
        {"x":0.118056,"y":0.838281},
        {"x":0.102778,"y":0.846875}, 
        ... 
      ]
    },
    { "x":0.352778,
      "y":0.406250,
      "width":0.372222,
      "height":0.209375,
      "faceId":"1",
      "firstEye":{"x":0.567164,"y":0.201493,"width":0.242537,"height":0.242537},
      "secondEye":{"x":0.868172,"y":0.231591,"width":0.239439,"height":0.288819},
      "nose":{"x":0.343284,"y":0.537313,"width":0.268657,"height":0.160448}
     }
  ]} 
}
```
The values represent percentages so 0.15 represents 15% of the width for example.  For the face components other than the landmarks the percentage is the percentage of the face box not the entire image.  As can be seen from the sample data if something is not detected it is simply not included in the return data.  For the landmarks there are 68 points of data.  For in-depth examples of how to parse the json payload return data check out the sample apps CvFaceDetection and CvFaceLandmarks.


### Callbacks and overlays

The optional `onPayload` property refers to the callback that gets the payload data from the set of enclosing CvInvoke methods.  The outermost CvInvoke method should include a `callback` property that also references this method.  The method should be named `onPayload`.  The data returned to the callback will be in the json dictionary format: `{ "payload" : ... }` where the ... value is either an array of data or an array of arrays of data.  When a callback is used the property `overlayInterval` should be set to at least 100 milliseconds.  This is the amount of time before a new chunk of data is sent back to the callback so an overlay image can be updated.  You may need to test different values for overlayInterval to see what is the best value to use for your application.  You also may need to use different overlay interval values on iOS and Android.  

Once inside the onPayload method you can use the data returned to generate an overlay Mat and then set the overlay on the CvCamera view using the `setOverlay` method as `this.cvCamera.setOverlay(overlayMat)`.  Callbacks and overlays are used in the CvImageManipulations sample app.  Usage is also shown in the above CvInvokeGroup example.

### Saving images and recording video

The optional property `useStorage` should be set to `true` so the storage permissions `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE` are prompted for. Currently the image formats jpeg and png are supported on both iOS and Android for saved images.  The image is saved in the format indicated by the filename extension so ".jpg" or ".jpeg" for jpeg and ".png" for png.  On Android the recorded video format is avi and on iOS the recorded video format is mpeg-4 with a filename extension of ".m4v".  There is no audio recorded with the video.  This may be a feature included for a future release.  For examples of saving images and recording video reference the CvCameraPreview app.

To take a picture or record a video you should have a ref to the CvCamera instance as shown in the examples below.

#### Saving images

Using the reference to the camera instance an image can be taken with whatever filename you wish to give it using the asynchronous CvCamera method `takePicture` as in this example:
```javascript

  takePic = async() => {
    const { uri, width, height } = await this.cvCamera.takePicture('myimage.jpg')
    //alert('Picture successfully taken uri is: ' + uri)
    if (Platform.OS === 'android') {
      this.setState({ picuri : 'file://' + uri })
    }
    else {
      this.setState({ picuri : uri })
    }
  }
  
  ...
  
  <CvCamera
    ref={ref => { this.cvCamera = ref }}
    style={styles.preview}
    facing={facing}
    useStorage={true}
  />
  
```

#### Recording video

Using the reference to the camera instance a video can be recorded by first calling the CvCamera method `startRecording` and after time has elapsed calling the asynchronous CvCamera method `stopRecording` as in this example:
```javascript

  startRecordingVideo = async() => {
    filenameStr = 'myvideo'
    if (Platform.OS === 'android') {
      filenameStr += '.avi'
    }
    else {
      filenameStr += '.m4v'
    }
    let itexists = await RNFS.exists(filenameStr)
    if (itexists) {
      await RNFS.unlink(filenameStr)
    }
    this.cvCamera.startRecording(filenameStr)
  }
  
  stopRecordingVideo = async() => {
    const { uri, width, height } = await this.cvCamera.stopRecording()
    const { size } = await RNFS.stat(uri)
    if (Platform.OS === 'android') {
      // avi does not seem to play in react-native-video ??
      alert('Video uri is: ' + uri + ' width is: ' + width + ' height is: ' + height + ' size is: ' + size)
      this.setState({ videouri : 'file://' + uri})
    }
    else {
      this.setState({ videouri : uri })
    }
  }
  
  ...
  
  <CvCamera
    ref={ref => { this.cvCamera = ref }}
    style={styles.preview}
    facing={facing}
    useStorage={true}
  />
  
```

## Supported types, constants and functions

There are currently some basic supported OpenCV types.  The supported types that map directly to native OpenCV types are:

Mat, MatOfInt, MatOfFloat, CvPoint, CvScalar, CvSize and CvRect

A number of Imgproc and Core constants are supported.  As well as ColorConv constants which are for converting from one colorspace to another.  To see which constants are supported check out `constants.js`.  You can also use the actual number instead of the constant so 2 instead of Core.ROTATE_90_COUNTERCLOCKWISE for instance.  `CvType` is also supported for identifying and setting the data format of the Mats.

There are also some functions that are available for the various basic types.  Not all of these have been tested but some are used in the sample apps. 

Of course not all OpenCV functions are supported but a large chunk of Imgproc and Core methods are.  The supported functions on iOS are listed in the file OpencvFuncs.mm.  On Android method invocation is used so any Core and Imgproc function can be called but not every function is going to work because arrays of Mats cannot yet be passed to functions for example.  Most Imgproc and Core functions that take the supported types and return or set the output Mat are available.

*Copyright © 2019-20 Adam G. Freeman, All Rights Reserved.*

Sample apps are at: https://github.com/adamgf/react-native-opencv3-tests

If you would like to contribute to react-native-opencv3 please e-mail me at: adamgf@gmail.com

Thanks to @jackychanfox, @jslok, @przytua, @cirych and @dmydry for contributing.

## Apps that use react-native-opencv3

1. Pop Art Lite: https://apps.apple.com/us/app/pop-art-lite/id320338807

2. Pop Art: https://apps.apple.com/us/app/pop-art/id299466474


