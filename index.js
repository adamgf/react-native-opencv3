
import { NativeModules, requireNativeComponent, View } from 'react-native';

import React, { Component } from 'react';
import PropTypes from 'prop-types';
const  { RNOpencv3 } = NativeModules;
import { ColorConv, CvTypeClass } from './constants';
import { CvMat } from './mats';

const CvCameraView = requireNativeComponent('CvCameraView', CvCamera);

class CvCamera extends Component {
  constructor(props) {
    super(props)
    //alert(JSON.stringify(props))
  }
  render() {
    return (<CvCameraView {...this.props} />);
  }
}

CvCamera.propTypes = {
  ...View.propTypes,
  type: PropTypes.string
};

class CvInvoke extends Component {
  static propTypes = {
    children: PropTypes.any.isRequired,
    func: PropTypes.string.isRequired,
    params: PropTypes.any.isRequired
  }
  constructor(props) {
    super(props)
    this.renderChildren = this.renderChildren.bind(this)
  }
  renderChildren() {
    const { children, func, params, callback, functions, paramsArr, callbacks } = this.props;
    let newfunctions = []
    if (functions) {
      newfunctions = functions
    }
    newfunctions.push(func)
    let newparams = []
    if (paramsArr) {
      newparams = paramsArr
    }
    newparams.push(params)

    let newcallbacks = []
    if (callbacks) {
      newcallbacks = callbacks
    }
    if (callback) {
      newcallbacks.push(callback)
    }
    else {
      newcallbacks.push("")
    }

    const newKidsOnTheBlock = React.Children.map(children,
      (child, index) => React.cloneElement(child, {
        ...child.props, functions: newfunctions, paramsArr: newparams, callbacks: newcallbacks
      })
    );
    return newKidsOnTheBlock
  }
  render() {
    return (
      <React.Fragment>
        {this.renderChildren()}
      </React.Fragment>
    )
  }
}

const RNCv = RNOpencv3

export { RNCv, CvCamera, CvInvoke, ColorConv, CvTypeClass, CvMat };
