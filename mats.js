import { NativeModules } from 'react-native';

const  { RNOpencv3 } = NativeModules;
import { CvType } from './constants';

export class CvMat {
  constructor(cols, rows, cvtype, promise) {
    if (cols && rows && cvtype) {
      RNOpencv3.MatWithParams(cols, rows, cvtype)
      .then((res) => {
        promise.resolve(res)
      })
    }
    else {
      RNOpenCv3.Mat()
      .then((res) => {
        promise.resolve(res)
      })
    }
  }
}

export class MatOfInt {
  constructor(intvalue) {
    RNOpencv3.MatOfInt(intvalue).then((res) => {
      this.matIndex = res.matIndex
      this.value = intvalue
    })
  }
}

export class MatOfFloat {
  constructor(lowfloatvalue, highfloatvalue) {
    RNOpencv3.MatOfFloat(lowfloatvalue, highfloatvalue).then((res) => {
      this.matIndex = res.matIndex
      this.value = floatvalue
    })
  }
}
