
// @author Adam G. Freeman, adamgf@gmail.com
import { NativeModules, requireNativeComponent, View } from 'react-native';

import React, { Component } from 'react';
import PropTypes from 'prop-types';
const  { RNOpencv3 } = NativeModules;
import { ColorConv, CvType } from './constants';
import { Mat, MatOfInt, MatOfFloat } from './mats';

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

class CvInvokeGroup extends Component {
  static propTypes = {
    children: PropTypes.any.isRequired,
    groupid: PropTypes.string.isRequired
  }
  constructor(props) {
    super(props)
  }
  renderChildren() {
    let { children, groupid } = this.props
    let stopMapping = false
    const mappedChildren = React.Children.map(children,
      (child, index) => {

      //if (child.type.displayName === 'CvInvokeGroup') {
      //  stopMapping = true
      //}
      if (child.type.displayName === 'CvInvoke') {
        const { func, params, callback, children } = child.props

        if (groupid === 'invokeGroup1') {
          let childtypes = []
          for (child in children) {
            childtypes.push(JSON.stringify(child))
          }
          alert('children is: ' + childtypes)
        }
        return <CvInvoke func={func} params={params} callback={callback} children={children} groupid={groupid}></CvInvoke>
      }
    })
    return mappedChildren
  }
  render() {
    return (
      <React.Fragment>
      {this.renderChildren()}
      </React.Fragment>
    )
  }
}

class CvInvoke extends Component {
  static propTypes = {
    children: PropTypes.any.isRequired,
    func: PropTypes.string.isRequired,
    params: PropTypes.any.isRequired,
    callback: PropTypes.string,
    groupid: PropTypes.string
  }
  constructor(props) {
    super(props)
    this.renderChildren = this.renderChildren.bind(this)
  }
  renderChildren() {
    const { func, params, callback, children, cvinvoke, groupid } = this.props;
    let newfunctions = []
    if (cvinvoke && cvinvoke.functions) {
      newfunctions = cvinvoke.functions
    }
    newfunctions.push(func)
    let newparams = []
    if (cvinvoke && cvinvoke.paramsArr) {
      newparams = cvinvoke.paramsArr
    }
    newparams.push(params)

    let newcallbacks = []
    if (cvinvoke && cvinvoke.callbacks) {
      newcallbacks = cvinvoke.callbacks
    }
    if (callback) {
      newcallbacks.push(callback)
    }
    else {
      newcallbacks.push("")
    }

    let groupids = []
    if (cvinvoke && cvinvoke.groupids) {
      groupids = cvinvoke.groupids
    }
    if (groupid) {
      groupids.push(groupid)
    }
    else {
      groupids.push("")
    }

    const newKidsOnTheBlock = React.Children.map(children,
      (child, index) => React.cloneElement(child, {
        ...child.props, "cvinvoke" : { "functions" : newfunctions, "paramsArr": newparams, "callbacks": newcallbacks, "groupids": groupids }
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

export {
  RNCv,
  CvCamera,
  CvInvoke,
  CvInvokeGroup,
  ColorConv,
  CvType,
  Mat,
  MatOfInt,
  MatOfFloat
};
