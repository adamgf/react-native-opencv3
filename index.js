
import { NativeModules, requireNativeComponent, View } from 'react-native';

import React, { Component } from 'react';
import PropTypes from 'prop-types';

const CameraModule = NativeModules.AndroidCameraModule;

class Camera extends Component {

  render() {
    return (<AndroidCameraView {...this.props} />);
  }
}

Camera.propTypes = {
  ...View.propTypes,
  type: PropTypes.string
};

const AndroidCameraView = requireNativeComponent('AndroidCameraView', Camera);

const { RNOpencv3 } = NativeModules;

export { RNOpencv3, Camera };
