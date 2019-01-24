import { NativeModules } from 'react-native';

const  { RNOpencv3 } = NativeModules;
import { CvType } from './constants';

export const Mat = async(cols, rows, cvtype) => {
  let res = { 'bulletproof' : 'yes' }
  if (cols && rows && cvtype) {
    res = await RNOpencv3.MatWithParams(cols, rows, cvtype)
  }
  else {
    res = await RNOpenCv3.Mat()
  }
  return res
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
