/** 01/28/2019
 * OpenCV 3.4.5 minified + Face module ported to react-native
 * https://github.com/adamgf/react-native-opencv3
 *
 * @format
 * @flow
 * @author Adam Freeman, adamgf@gmail.com
 */
import { NativeModules } from 'react-native';
import React, {Component} from 'react';
import { Platform, Image } from 'react-native';
const  { RNOpencv3 } = NativeModules;
import { ColorConv } from './constants';

var RNFS = require('react-native-fs')

export class CvImage extends Component {

  constructor(props) {
    super(props)
    this.resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource')
    this.state = { 'destFile' : '' }
  }

  componentDidMount = () => {
    const assetSource = this.props.source
    const uri = this.resolveAssetSource(assetSource).uri
	const downloadAssetSource = require('./downloadAssetSource');
	
    downloadAssetSource(uri)
    .then((sourceFile) => {
      let srcMat
      let dstMat
      RNOpencv3.Mat().then((res) => {
        dstMat = res
        RNOpencv3.imageToMat(sourceFile).then((res) => {
          srcMat = res
          RNFS.unlink(sourceFile).then(() => {

            // replace srcMat and dstMat strings with actual srcMat and dstMat
            const { cvinvoke } = this.props
			if (cvinvoke) {
              for (let i=0;i < cvinvoke.paramsArr.length;i++) {
                let params = cvinvoke.paramsArr[i]
                for (let j=0;j < Object.keys(params).length;j++) {
                  const pnum = 'p' + (j + 1).toString()
                  if (params[pnum] && params[pnum] === 'srcMat') {
                    params[pnum] = srcMat
                  }
                  if (params[pnum] && params[pnum] === 'dstMat') {
                    params[pnum] = dstMat
                  }
                }
              }
              //alert('cvinvoke is: ' + JSON.stringify(this.props.cvinvoke))
              RNOpencv3.invokeMethods(cvinvoke)
		    }

            RNOpencv3.matToImage(dstMat, sourceFile)
            .then((image) => {
              RNOpencv3.deleteMat(srcMat)
              RNOpencv3.deleteMat(dstMat)
              const { width, height, uri } = image
              if (uri && uri.length > 0) {
                this.setState({ destFile : uri })
              }
              else {
                console.error('Error getting image information.')
              }
            })
            .catch((err) => {
              console.error(err)
            })
          })
          .catch((err) => {
            console.error(err)
          })
        })
      })
    })
    .catch((err) => {
      console.error(err)
    })
  }

  render() {
    let imageFilePath = this.resolveAssetSource(this.props.source).uri
    if (this.state.destFile.length > 0) {
      const prependFilename = Platform.OS === 'ios' ? '' : 'file://'
      imageFilePath = prependFilename + this.state.destFile
    }
    return(
      <Image {...this.props} source={{uri:`${imageFilePath}`}} />
    )
  }
}
