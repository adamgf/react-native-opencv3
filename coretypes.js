// author Adam G. Freeman, adamgf@gmail.com 01/26/2019
// Of course this is just a tiny subset of all the junkola ...
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

    static all(allval) {
      let res = new CvScalar()
      res.vals = [allval,allval,allval,allval]
      return res
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
    if (xval && yval) {
      this.x = xval
      this.y = yval
    }
    else {
      this.x = 0.0
      this.y = 0.0
    }
  }

  set = (vals) => {
    if (vals) {
      this.x = vals.length > 0 ? vals[0] : 0.0
      this.y = vals.length > 1 ? vals[1] : 0.0
    }
    else {
      this.x = 0.0
      this.y = 0.0
    }
  }

  dot = (otherPt) => {
    return (this.x * otherPt.x + this.y * otherPt.y)
  }
}

export class CvSize {
  constructor(width, height) {
	if (width) {
      this.width = width
	}
	else {
	  this.width = 0.0
	}
	if (height) {
      this.height = height
	}
	else {
	  this.height = 0.0
	}	
  }
}

export class CvRect {
  constructor(top, left, width, height) {
    if (top) {
	  this.top = top
	}
	else {
	  this.top = 0.0
	}
	if (left) {
	  this.left = left
	}
	else {
	  this.left = 0.0
	}
	if (width) {
      this.width = width
	}
	else {
	  this.width = 0.0
	}
	if (height) {
      this.height = height
	}
	else {
	  this.height = 0.0
	}		  	
  }
}