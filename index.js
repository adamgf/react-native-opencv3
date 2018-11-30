
import { NativeModules, requireNativeComponent, View } from 'react-native';

import React, { Component } from 'react';
import PropTypes from 'prop-types';

const CvCameraModule = NativeModules.AndroidCameraModule;

class CvCamera extends Component {

  render() {
    return (<AndroidCameraView {...this.props} />);
  }
}

CvCamera.propTypes = {
  ...View.propTypes,
  type: PropTypes.string
};

const AndroidCameraView = requireNativeComponent('AndroidCameraView', CvCamera);

const { RNOpencv3 } = NativeModules;

const RNCv = RNOpencv3

export { RNCv, CvCamera };
