// author Adam G. Freeman, adamgf@gmail.com 01/26/2019
// Of course this is just a tiny subset of all the mat stuff ...
import { NativeModules } from 'react-native';

const  { RNOpencv3 } = NativeModules;
import { CvType } from './constants';

export class Mat {
  constructor(numRows, numCols, cvtype) {
    if (numRows && numCols && cvtype) {
      this.rows = numRows
      this.cols = numCols
      this.CvType = cvtype
    }
  }

  init = async() => {
    let res
    if (this.rows && this.cols && this.CvType) {
      res = await RNOpencv3.MatWithParams(this.rows, this.cols, this.CvType)
    }
    else {
      res = await RNOpencv3.Mat()
    }
    return res
  }

  get = async(rownum, colnum, data) => {
    data = await RNOpencv3.getMatData(this, rownum, colnum)
  }
}

export class MatOfInt {
  constructor(intvalue) {
      this.intvalue = intvalue
  }

  init = async() => {
    return await RNOpencv3.MatOfInt(this.intvalue)
  }
}

export class MatOfFloat {
  constructor(lowfloatvalue, highfloatvalue) {
    this.lowfloatvalue = lowfloatvalue
    this.highfloatvalue = highfloatvalue
  }

  init = async() => {
    return await RNOpencv3.MatOfFloat(this.lowfloatvalue, this.highfloatvalue)
  }
}
