
import { NativeModules, requireNativeComponent, View } from 'react-native';

import React, { Component } from 'react';
import PropTypes from 'prop-types';

//const CvCameraModule = NativeModules.CvCameraModule;
class CvCamera extends Component {
  render() {
    return (<CvCameraView {...this.props} />);
  }
}

class CvInvoke extends Component {
  static propTypes = {
    children: PropTypes.any.isRequired,
    func: PropTypes.string.isRequired,
    params: PropTypes.string.isRequired
  }
  constructor(props) {
    super(props)
    this.renderChildren = this.renderChildren.bind(this)
  }
  renderChildren() {
    const { children, func, params, functions, paramsArr } = this.props;
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

    const newKidsOnTheBlock = React.Children.map(children,
  (child, index) => React.cloneElement(child, {
    functions: newfunctions, paramsArr: newparams
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

CvCamera.propTypes = {
  ...View.propTypes,
  type: PropTypes.string
};

const CvCameraView = requireNativeComponent('CvCameraView', CvCamera);

const { RNOpencv3 } = NativeModules;

const RNCv = RNOpencv3

export { RNCv, CvCamera, CvInvoke };
