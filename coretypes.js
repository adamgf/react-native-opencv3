// author Adam G. Freeman, adamgf@gmail.com 01/26/2019
// Of course this is just a tiny subset of all the junk ...
export class CvScalar {

    constructor(v0val, v1val, v2val, v3val) {
      let v0, v1, v2, v3
      if (v3val) {
        v3 = v3val
      }
      else {
        v3 = 0.0
      }
      if (v2val) {
        v2 = v2val
      }
      else {
        v2 = 0.0
      }
      if (v1val) {
        v1 = v1val
      }
      else {
        v1 = 0.0
      }
      if (v0val) {
        v0 = v0val
      }
      else {
        v0 = 0.0
      }
      this.vals = [v0,v1,v2,v3]
    }

    all = (allval) => {
      this.vals = [allval,allval,allval,allval]
      return this.vals
    }

    set = (vals) => {
      let v0, v1, v2, v3
      if (vals) {
        v0 = vals.length > 0 ? vals[0] : 0.0
        v1 = vals.length > 1 ? vals[1] : 0.0
        v2 = vals.length > 2 ? vals[2] : 0.0
        v3 = vals.length > 3 ? vals[3] : 0.0
      }
      else {
        v0 = v1 = v2 = v3 = 0.0
      }
      this.vals = [v0,v1,v2,v3]
    }
}

export class CvPoint {
  constructor(xval, yval) {
    this.xval = xval
    this.yval = yval
  }

  set = (vals) => {
    if (vals) {
      this.xval = vals.length > 0 ? vals[0] : 0.0
      this.yval = vals.length > 1 ? vals[1] : 0.0
    }
    else {
      this.xval = 0.0
      this.yval = 0.0
    }
  }

  dot = (otherPt) => {
    return (this.xval * otherPt.xval + this.yval * otherPt.yval)
  }
}
