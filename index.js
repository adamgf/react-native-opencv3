
import { NativeModules, requireNativeComponent, View } from 'react-native';

import React, { Component } from 'react';
import PropTypes from 'prop-types';

class CvCamera extends Component {
  render() {
    return (<CvCameraView {...this.props} />);
  }
}

CvCamera.propTypes = {
  ...View.propTypes,
  type: PropTypes.string
};

const CvCameraView = requireNativeComponent('CvCameraView', CvCamera);

const { RNCv } = NativeModules;

export { RNCv, CvCamera };
