export const ColorConv = {
    "COLOR_BGR2BGRA"     : 0, //!< add alpha"Channel to RGB or BGR image
    "COLOR_RGB2RGBA"     : "COLOR_BGR2BGRA",

    "COLOR_BGRA2BGR"     : 1, //!< remove alpha"Channel from RGB or BGR image
    "COLOR_RGBA2RGB"     : "COLOR_BGRA2BGR",

    "COLOR_BGR2RGBA"     : 2, //!<"Convert between RGB and BGR"Color spaces (with or without alpha"Channel)
    "COLOR_RGB2BGRA"     :"COLOR_BGR2RGBA",

    "COLOR_RGBA2BGR"     : 3,
    "COLOR_BGRA2RGB"     :"COLOR_RGBA2BGR",

    "COLOR_BGR2RGB"      : 4,
    "COLOR_RGB2BGR"      :"COLOR_BGR2RGB",

    "COLOR_BGRA2RGBA"    : 5,
    "COLOR_RGBA2BGRA"    :"COLOR_BGRA2RGBA",

    "COLOR_BGR2GRAY"     : 6, //!<"Convert between RGB/BGR and grayscale, @ref"Color_convert_rgb_gray "color"Conversions"
    "COLOR_RGB2GRAY"     : 7,
    "COLOR_GRAY2BGR"     : 8,
    "COLOR_GRAY2RGB"     :"COLOR_GRAY2BGR",
    "COLOR_GRAY2BGRA"    : 9,
    "COLOR_GRAY2RGBA"    :"COLOR_GRAY2BGRA",
    "COLOR_BGRA2GRAY"    : 10,
    "COLOR_RGBA2GRAY"    : 11,

    "COLOR_BGR2BGR565"   : 12, //!<"Convert between RGB/BGR and BGR565 (16-bit images)
    "COLOR_RGB2BGR565"   : 13,
    "COLOR_BGR5652BGR"   : 14,
    "COLOR_BGR5652RGB"   : 15,
    "COLOR_BGRA2BGR565"  : 16,
    "COLOR_RGBA2BGR565"  : 17,
    "COLOR_BGR5652BGRA"  : 18,
    "COLOR_BGR5652RGBA"  : 19,

    "COLOR_GRAY2BGR565"  : 20, //!<"Convert between grayscale to BGR565 (16-bit images)
    "COLOR_BGR5652GRAY"  : 21,

    "COLOR_BGR2BGR555"   : 22,  //!<"Convert between RGB/BGR and BGR555 (16-bit images)
    "COLOR_RGB2BGR555"   : 23,
    "COLOR_BGR5552BGR"   : 24,
    "COLOR_BGR5552RGB"   : 25,
    "COLOR_BGRA2BGR555"  : 26,
    "COLOR_RGBA2BGR555"  : 27,
    "COLOR_BGR5552BGRA"  : 28,
    "COLOR_BGR5552RGBA"  : 29,

    "COLOR_GRAY2BGR555"  : 30, //!<"Convert between grayscale and BGR555 (16-bit images)
    "COLOR_BGR5552GRAY"  : 31,

    "COLOR_BGR2XYZ"      : 32, //!<"Convert RGB/BGR to"CIE XYZ, @ref"Color_convert_rgb_xyz "color"Conversions"
    "COLOR_RGB2XYZ"      : 33,
    "COLOR_XYZ2BGR"      : 34,
    "COLOR_XYZ2RGB"      : 35,

    "COLOR_BGR2YCrCb"    : 36, //!<"Convert RGB/BGR to luma-chroma (aka YCC), @ref"Color_convert_rgb_ycrcb "color"Conversions"
    "COLOR_RGB2YCrCb"    : 37,
    "COLOR_YCrCb2BGR"    : 38,
    "COLOR_YCrCb2RGB"    : 39,

    "COLOR_BGR2HSV"      : 40, //!<"Convert RGB/BGR to HSV (hue saturation value), @ref"Color_convert_rgb_hsv "color"Conversions"
    "COLOR_RGB2HSV"      : 41,

    "COLOR_BGR2Lab"      : 44, //!<"Convert RGB/BGR to"CIE Lab, @ref"Color_convert_rgb_lab "color"Conversions"
    "COLOR_RGB2Lab"      : 45,

    "COLOR_BGR2Luv"      : 50, //!<"Convert RGB/BGR to"CIE Luv, @ref"Color_convert_rgb_luv "color"Conversions"
    "COLOR_RGB2Luv"      : 51,
    "COLOR_BGR2HLS"      : 52, //!<"Convert RGB/BGR to HLS (hue lightness saturation), @ref"Color_convert_rgb_hls "color"Conversions"
    "COLOR_RGB2HLS"      : 53,

    "COLOR_HSV2BGR"      : 54, //!< backward"Conversions to RGB/BGR
    "COLOR_HSV2RGB"      : 55,

    "COLOR_Lab2BGR"      : 56,
    "COLOR_Lab2RGB"      : 57,
    "COLOR_Luv2BGR"      : 58,
    "COLOR_Luv2RGB"      : 59,
    "COLOR_HLS2BGR"      : 60,
    "COLOR_HLS2RGB"      : 61,

    "COLOR_BGR2HSV_FULL" : 66,
    "COLOR_RGB2HSV_FULL" : 67,
    "COLOR_BGR2HLS_FULL" : 68,
    "COLOR_RGB2HLS_FULL" : 69,

    "COLOR_HSV2BGR_FULL" : 70,
    "COLOR_HSV2RGB_FULL" : 71,
    "COLOR_HLS2BGR_FULL" : 72,
    "COLOR_HLS2RGB_FULL" : 73,

    "COLOR_LBGR2Lab"     : 74,
    "COLOR_LRGB2Lab"     : 75,
    "COLOR_LBGR2Luv"     : 76,
    "COLOR_LRGB2Luv"     : 77,

    "COLOR_Lab2LBGR"     : 78,
    "COLOR_Lab2LRGB"     : 79,
    "COLOR_Luv2LBGR"     : 80,
    "COLOR_Luv2LRGB"     : 81,

    "COLOR_BGR2YUV"      : 82, //!<"Convert between RGB/BGR and YUV
    "COLOR_RGB2YUV"      : 83,
    "COLOR_YUV2BGR"      : 84,
    "COLOR_YUV2RGB"      : 85,

    //! YUV 4:2:0 family to RGB
    "COLOR_YUV2RGB_NV12"  : 90,
    "COLOR_YUV2BGR_NV12"  : 91,
    "COLOR_YUV2RGB_NV21"  : 92,
    "COLOR_YUV2BGR_NV21"  : 93,
    "COLOR_YUV420sp2RGB"  :"COLOR_YUV2RGB_NV21",
    "COLOR_YUV420sp2BGR"  :"COLOR_YUV2BGR_NV21",

    "COLOR_YUV2RGBA_NV12" : 94,
    "COLOR_YUV2BGRA_NV12" : 95,
    "COLOR_YUV2RGBA_NV21" : 96,
    "COLOR_YUV2BGRA_NV21" : 97,
    "COLOR_YUV420sp2RGBA" :"COLOR_YUV2RGBA_NV21",
    "COLOR_YUV420sp2BGRA" :"COLOR_YUV2BGRA_NV21",

    "COLOR_YUV2RGB_YV12"  : 98,
    "COLOR_YUV2BGR_YV12"  : 99,
    "COLOR_YUV2RGB_IYUV"  : 100,
    "COLOR_YUV2BGR_IYUV"  : 101,
    "COLOR_YUV2RGB_I420"  :"COLOR_YUV2RGB_IYUV",
    "COLOR_YUV2BGR_I420"  :"COLOR_YUV2BGR_IYUV",
    "COLOR_YUV420p2RGB"   :"COLOR_YUV2RGB_YV12",
    "COLOR_YUV420p2BGR"   :"COLOR_YUV2BGR_YV12",

   "COLOR_YUV2RGBA_YV12" : 102,
   "COLOR_YUV2BGRA_YV12" : 103,
   "COLOR_YUV2RGBA_IYUV" : 104,
   "COLOR_YUV2BGRA_IYUV" : 105,
   "COLOR_YUV2RGBA_I420" :"COLOR_YUV2RGBA_IYUV",
   "COLOR_YUV2BGRA_I420" :"COLOR_YUV2BGRA_IYUV",
   "COLOR_YUV420p2RGBA"  :"COLOR_YUV2RGBA_YV12",
   "COLOR_YUV420p2BGRA"  :"COLOR_YUV2BGRA_YV12",

   "COLOR_YUV2GRAY_420"  : 106,
   "COLOR_YUV2GRAY_NV21" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_NV12" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_YV12" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_IYUV" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_I420" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV420sp2GRAY" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV420p2GRAY"  :"COLOR_YUV2GRAY_420",

    //! YUV 4:2:2 family to RGB
   "COLOR_YUV2RGB_UYVY" : 107,
   "COLOR_YUV2BGR_UYVY" : 108,
    //COLOR_YUV2RGB_VYUY : 109,
    //COLOR_YUV2BGR_VYUY : 110,
   "COLOR_YUV2RGB_Y422" :"COLOR_YUV2RGB_UYVY",
   "COLOR_YUV2BGR_Y422" :"COLOR_YUV2BGR_UYVY",
   "COLOR_YUV2RGB_UYNV" :"COLOR_YUV2RGB_UYVY",
   "COLOR_YUV2BGR_UYNV" :"COLOR_YUV2BGR_UYVY",

   "COLOR_YUV2RGBA_UYVY" : 111,
   "COLOR_YUV2BGRA_UYVY" : 112,
    //COLOR_YUV2RGBA_VYUY : 113,
    //COLOR_YUV2BGRA_VYUY : 114,
   "COLOR_YUV2RGBA_Y422" :"COLOR_YUV2RGBA_UYVY",
   "COLOR_YUV2BGRA_Y422" :"COLOR_YUV2BGRA_UYVY",
   "COLOR_YUV2RGBA_UYNV" :"COLOR_YUV2RGBA_UYVY",
   "COLOR_YUV2BGRA_UYNV" :"COLOR_YUV2BGRA_UYVY",

   "COLOR_YUV2RGB_YUY2" : 115,
   "COLOR_YUV2BGR_YUY2" : 116,
   "COLOR_YUV2RGB_YVYU" : 117,
   "COLOR_YUV2BGR_YVYU" : 118,
   "COLOR_YUV2RGB_YUYV" :"COLOR_YUV2RGB_YUY2",
   "COLOR_YUV2BGR_YUYV" :"COLOR_YUV2BGR_YUY2",
   "COLOR_YUV2RGB_YUNV" :"COLOR_YUV2RGB_YUY2",
   "COLOR_YUV2BGR_YUNV" :"COLOR_YUV2BGR_YUY2",

   "COLOR_YUV2RGBA_YUY2" : 119,
   "COLOR_YUV2BGRA_YUY2" : 120,
   "COLOR_YUV2RGBA_YVYU" : 121,
   "COLOR_YUV2BGRA_YVYU" : 122,
   "COLOR_YUV2RGBA_YUYV" :"COLOR_YUV2RGBA_YUY2",
   "COLOR_YUV2BGRA_YUYV" :"COLOR_YUV2BGRA_YUY2",
   "COLOR_YUV2RGBA_YUNV" :"COLOR_YUV2RGBA_YUY2",
   "COLOR_YUV2BGRA_YUNV" :"COLOR_YUV2BGRA_YUY2",

   "COLOR_YUV2GRAY_UYVY" : 123,
   "COLOR_YUV2GRAY_YUY2" : 124,
    //CV_YUV2GRAY_VYUY    :"CV_YUV2GRAY_UYVY,
   "COLOR_YUV2GRAY_Y422" :"COLOR_YUV2GRAY_UYVY",
   "COLOR_YUV2GRAY_UYNV" :"COLOR_YUV2GRAY_UYVY",
   "COLOR_YUV2GRAY_YVYU" :"COLOR_YUV2GRAY_YUY2",
   "COLOR_YUV2GRAY_YUYV" :"COLOR_YUV2GRAY_YUY2",
   "COLOR_YUV2GRAY_YUNV" :"COLOR_YUV2GRAY_YUY2",

    //! alpha premultiplication
   "COLOR_RGBA2mRGBA"    : 125,
   "COLOR_mRGBA2RGBA"    : 126,

    //! RGB to YUV 4:2:0 family
   "COLOR_RGB2YUV_I420"  : 127,
   "COLOR_BGR2YUV_I420"  : 128,
   "COLOR_RGB2YUV_IYUV"  :"COLOR_RGB2YUV_I420",
   "COLOR_BGR2YUV_IYUV"  :"COLOR_BGR2YUV_I420",

   "COLOR_RGBA2YUV_I420" : 129,
   "COLOR_BGRA2YUV_I420" : 130,
   "COLOR_RGBA2YUV_IYUV" :"COLOR_RGBA2YUV_I420",
   "COLOR_BGRA2YUV_IYUV" :"COLOR_BGRA2YUV_I420",
   "COLOR_RGB2YUV_YV12"  : 131,
   "COLOR_BGR2YUV_YV12"  : 132,
   "COLOR_RGBA2YUV_YV12" : 133,
   "COLOR_BGRA2YUV_YV12" : 134,

    //! Demosaicing
   "COLOR_BayerBG2BGR" : 46,
   "COLOR_BayerGB2BGR" : 47,
   "COLOR_BayerRG2BGR" : 48,
   "COLOR_BayerGR2BGR" : 49,

   "COLOR_BayerBG2RGB" :"COLOR_BayerRG2BGR",
   "COLOR_BayerGB2RGB" :"COLOR_BayerGR2BGR",
   "COLOR_BayerRG2RGB" :"COLOR_BayerBG2BGR",
   "COLOR_BayerGR2RGB" :"COLOR_BayerGB2BGR",

   "COLOR_BayerBG2GRAY" : 86,
   "COLOR_BayerGB2GRAY" : 87,
   "COLOR_BayerRG2GRAY" : 88,
   "COLOR_BayerGR2GRAY" : 89,

    //! Demosaicing using Variable Number of Gradients
   "COLOR_BayerBG2BGR_VNG" : 62,
   "COLOR_BayerGB2BGR_VNG" : 63,
   "COLOR_BayerRG2BGR_VNG" : 64,
   "COLOR_BayerGR2BGR_VNG" : 65,

   "COLOR_BayerBG2RGB_VNG" :"COLOR_BayerRG2BGR_VNG",
   "COLOR_BayerGB2RGB_VNG" :"COLOR_BayerGR2BGR_VNG",
   "COLOR_BayerRG2RGB_VNG" :"COLOR_BayerBG2BGR_VNG",
   "COLOR_BayerGR2RGB_VNG" :"COLOR_BayerGB2BGR_VNG",

    //! Edge-Aware Demosaicing
   "COLOR_BayerBG2BGR_EA"  : 135,
   "COLOR_BayerGB2BGR_EA"  : 136,
   "COLOR_BayerRG2BGR_EA"  : 137,
   "COLOR_BayerGR2BGR_EA"  : 138,

   "COLOR_BayerBG2RGB_EA"  :"COLOR_BayerRG2BGR_EA",
   "COLOR_BayerGB2RGB_EA"  :"COLOR_BayerGR2BGR_EA",
   "COLOR_BayerRG2RGB_EA"  :"COLOR_BayerBG2BGR_EA",
   "COLOR_BayerGR2RGB_EA"  :"COLOR_BayerGB2BGR_EA",

    //! Demosaicing with alpha"Channel
   "COLOR_BayerBG2BGRA" : 139,
   "COLOR_BayerGB2BGRA" : 140,
   "COLOR_BayerRG2BGRA" : 141,
   "COLOR_BayerGR2BGRA" : 142,

   "COLOR_BayerBG2RGBA" :"COLOR_BayerRG2BGRA",
   "COLOR_BayerGB2RGBA" :"COLOR_BayerGR2BGRA",
   "COLOR_BayerRG2RGBA" :"COLOR_BayerBG2BGRA",
   "COLOR_BayerGR2RGBA" :"COLOR_BayerGB2BGRA",

   "COLOR_COLORCVT_MAX"  : 143
};

makeType = (depth, channels) => {
    if (channels <= 0 || channels >= 512) {
      alert("Channels count should be 1.." + 511)
    }
    if (depth < 0 || depth >= (1 << 3)) {
      alert("Data type depth should be 0.." + ((1 << 3) - 1))
    }
    return ((depth & ((1 << 3) - 1)) + ((channels - 1) << 3))
}

CV_8UC = (ch) => {
  return makeType(0, ch)
}

CV_8SC = (ch) => {
  return makeType(1, ch)
}

CV_16UC = (ch) => {
  return makeType(2, ch)
}

CV_16SC = (ch) => {
  return makeType(3, ch)
}

CV_32SC = (ch) => {
  return makeType(4, ch)
}

CV_32FC = (ch) => {
  return makeType(5, ch)
}

CV_64FC = (ch) => {
  return makeType(6, ch)
}

export const CvType = {
     "CV_8U" : 0,
     "CV_8S" : 1,
     "CV_16U" : 2,
     "CV_16S" : 3,
     "CV_32S" : 4,
     "CV_32F" : 5,
     "CV_64F" : 6,
     "CV_USRTYPE1" : 7,
     "CV_8UC1" : CV_8UC(1), "CV_8UC2" : CV_8UC(2), "CV_8UC3" : CV_8UC(3), "CV_8UC4" : CV_8UC(4),
     "CV_8SC1" : CV_8SC(1), "CV_8SC2" : CV_8SC(2), "CV_8SC3" : this.CV_8SC(3), "CV_8SC4" : CV_8SC(4),
     "CV_16UC1" : CV_16UC(1), "CV_16UC2" : CV_16UC(2), "CV_16UC3" : CV_16UC(3), "CV_16UC4" : CV_16UC(4),
     "CV_16SC1" : CV_16SC(1), "CV_16SC2" : CV_16SC(2), "CV_16SC3" : CV_16SC(3), "CV_16SC4" : CV_16SC(4),
     "CV_32SC1" : CV_32SC(1), "CV_32SC2" : CV_32SC(2), "CV_32SC3" : CV_32SC(3), "CV_32SC4" : CV_32SC(4),
     "CV_32FC1" : CV_32FC(1), "CV_32FC2" : CV_32FC(2), "CV_32FC3" : CV_32FC(3), "CV_32FC4" : CV_32FC(4),
     "CV_64FC1" : CV_64FC(1), "CV_64FC2" : CV_64FC(2), "CV_64FC3" : CV_64FC(3), "CV_64FC4" : CV_64FC(4),
     "CV_CN_MAX" : 512, "CV_CN_SHIFT" : 3, "CV_DEPTH_MAX" : (1 << 3)
};

export const Imgproc = {
    "LINE_AA" : 16,
    "LINE_8" : 8,
    "LINE_4" : 4,
    "CV_BLUR_NO_SCALE" : 0,
    "CV_BLUR" : 1,
    "CV_GAUSSIAN" : 2,
    "CV_MEDIAN" : 3,
    "CV_BILATERAL" : 4,
    "CV_GAUSSIAN_5x5" : 7,
    "CV_SCHARR" : -1,
    "CV_MAX_SOBEL_KSIZE" : 7,
    "CV_RGBA2mRGBA" : 125,
    "CV_mRGBA2RGBA" : 126,
    "CV_WARP_FILL_OUTLIERS" : 8,
    "CV_WARP_INVERSE_MAP" : 16,
    "CV_SHAPE_RECT" : 0,
    "CV_SHAPE_CROSS" : 1,
    "CV_SHAPE_ELLIPSE" : 2,
    "CV_SHAPE_CUSTOM" : 100,
    "CV_CHAIN_CODE" : 0,
    "CV_LINK_RUNS" : 5,
    "CV_POLY_APPROX_DP" : 0,
    "CV_CONTOURS_MATCH_I1" : 1,
    "CV_CONTOURS_MATCH_I2" : 2,
    "CV_CONTOURS_MATCH_I3" : 3,
    "CV_CLOCKWISE" : 1,
    "CV_COUNTER_CLOCKWISE" : 2,
    "CV_COMP_CORREL" : 0,
    "CV_COMP_CHISQR" : 1,
    "CV_COMP_INTERSECT" : 2,
    "CV_COMP_BHATTACHARYYA" : 3,
    "CV_COMP_HELLINGER" : "CV_COMP_BHATTACHARYYA",
    "CV_COMP_CHISQR_ALT" : 4,
    "CV_COMP_KL_DIV" : 5,
    "CV_DIST_MASK_3" : 3,
    "CV_DIST_MASK_5" : 5,
    "CV_DIST_MASK_PRECISE" : 0,
    "CV_DIST_LABEL_CCOMP" : 0,
    "CV_DIST_LABEL_PIXEL" : 1,
    "CV_DIST_USER" : -1,
    "CV_DIST_L1" : 1,
    "CV_DIST_L2" : 2,
    "CV_DIST_C" : 3,
    "CV_DIST_L12" : 4,
    "CV_DIST_FAIR" : 5,
    "CV_DIST_WELSCH" : 6,
    "CV_DIST_HUBER" : 7,
    "CV_CANNY_L2_GRADIENT" : (1 << 31),
    "CV_HOUGH_STANDARD" : 0,
    "CV_HOUGH_PROBABILISTIC" : 1,
    "CV_HOUGH_MULTI_SCALE" : 2,
    "CV_HOUGH_GRADIENT" : 3,
    "MORPH_ERODE" : 0,
    "MORPH_DILATE" : 1,
    "MORPH_OPEN" : 2,
    "MORPH_CLOSE" : 3,
    "MORPH_GRADIENT" : 4,
    "MORPH_TOPHAT": 5,
    "MORPH_BLACKHAT" : 6,
    "MORPH_HITMISS" : 7,
    "MORPH_RECT" : 0,
    "MORPH_CROSS" : 1,
    "MORPH_ELLIPSE" : 2,
    "INTER_NEAREST" : 0,
    "INTER_LINEAR" : 1,
    "INTER_CUBIC" : 2,
    "INTER_AREA" : 3,
    "INTER_LANCZOS4" : 4,
    "INTER_LINEAR_EXACT" : 5,
    "INTER_MAX" : 7,
    "WARP_FILL_OUTLIERS" : 8,
    "WARP_INVERSE_MAP" : 16,
    "WARP_POLAR_LINEAR" : 0,
    "WARP_POLAR_LOG" : 256,
    "INTER_BITS" : 5,
    "INTER_BITS2" : "INTER_BITS" * 2,
    "INTER_TAB_SIZE" : 1 << "INTER_BITS",
    "INTER_TAB_SIZE2" : "INTER_TAB_SIZE" * "INTER_TAB_SIZE",
    "DIST_USER" : -1,
    "DIST_L1" : 1,
    "DIST_L2" : 2,
    "DIST_C" : 3,
    "DIST_L12" : 4,
    "DIST_FAIR" : 5,
    "DIST_WELSCH" : 6,
    "DIST_HUBER" : 7,
    "DIST_MASK_3" : 3,
    "DIST_MASK_5" : 5,
    "DIST_MASK_PRECISE" : 0,
    "THRESH_BINARY" : 0,
    "THRESH_BINARY_INV" : 1,
    "THRESH_TRUNC" : 2,
    "THRESH_TOZERO" : 3,
    "THRESH_TOZERO_INV" : 4,
    "THRESH_MASK" : 7,
    "THRESH_OTSU" : 8,
    "THRESH_TRIANGLE" : 16,
    "ADAPTIVE_THRESH_MEAN_C" : 0,
    "ADAPTIVE_THRESH_GAUSSIAN_C" : 1,
    "PROJ_SPHERICAL_ORTHO" : 0,
    "PROJ_SPHERICAL_EQRECT" : 1,
    "GC_BGD" : 0,
    "GC_FGD" : 1,
    "GC_PR_BGD" : 2,
    "GC_PR_FGD" : 3,
    "GC_INIT_WITH_RECT" : 0,
    "GC_INIT_WITH_MASK" : 1,
    "GC_EVAL" : 2,
    "GC_EVAL_FREEZE_MODEL" : 3,
    "DIST_LABEL_CCOMP" : 0,
    "DIST_LABEL_PIXEL" : 1,
    "FLOODFILL_FIXED_RANGE" : 1 << 16,
    "FLOODFILL_MASK_ONLY" : 1 << 17,
    "CC_STAT_LEFT" : 0,
    "CC_STAT_TOP" : 1,
    "CC_STAT_WIDTH" : 2,
    "CC_STAT_HEIGHT" : 3,
    "CC_STAT_AREA" : 4,
    "CC_STAT_MAX" : 5,
    "CCL_WU" : 0,
    "CCL_DEFAULT" : -1,
    "CCL_GRANA" : 1,
    "RETR_EXTERNAL" : 0,
    "RETR_LIST" : 1,
    "RETR_CCOMP" : 2,
    "RETR_TREE" : 3,
    "RETR_FLOODFILL" : 4,
    "CHAIN_APPROX_NONE" : 1,
    "CHAIN_APPROX_SIMPLE" : 2,
    "CHAIN_APPROX_TC89_L1" : 3,
    "CHAIN_APPROX_TC89_KCOS" : 4,
    "CONTOURS_MATCH_I1" : 1,
    "CONTOURS_MATCH_I2" : 2,
    "CONTOURS_MATCH_I3" : 3,
    "HOUGH_STANDARD" : 0,
    "HOUGH_PROBABILISTIC" : 1,
    "HOUGH_MULTI_SCALE" : 2,
    "HOUGH_GRADIENT" : 3,
    "LSD_REFINE_NONE" : 0,
    "LSD_REFINE_STD" : 1,
    "LSD_REFINE_ADV" : 2,
    "HISTCMP_CORREL" : 0,
    "HISTCMP_CHISQR" : 1,
    "HISTCMP_INTERSECT" : 2,
    "HISTCMP_BHATTACHARYYA" : 3,
    "HISTCMP_HELLINGER" : "HISTCMP_BHATTACHARYYA",
    "HISTCMP_CHISQR_ALT" : 4,
    "HISTCMP_KL_DIV" : 5,

    "COLOR_BGR2BGRA"     : 0, //!< add alpha"Channel to RGB or BGR image
    "COLOR_RGB2RGBA"     : "COLOR_BGR2BGRA",

    "COLOR_BGRA2BGR"     : 1, //!< remove alpha"Channel from RGB or BGR image
    "COLOR_RGBA2RGB"     : "COLOR_BGRA2BGR",

    "COLOR_BGR2RGBA"     : 2, //!<"Convert between RGB and BGR"Color spaces (with or without alpha"Channel)
    "COLOR_RGB2BGRA"     :"COLOR_BGR2RGBA",

    "COLOR_RGBA2BGR"     : 3,
    "COLOR_BGRA2RGB"     :"COLOR_RGBA2BGR",

    "COLOR_BGR2RGB"      : 4,
    "COLOR_RGB2BGR"      :"COLOR_BGR2RGB",

    "COLOR_BGRA2RGBA"    : 5,
    "COLOR_RGBA2BGRA"    :"COLOR_BGRA2RGBA",

    "COLOR_BGR2GRAY"     : 6, //!<"Convert between RGB/BGR and grayscale, @ref"Color_convert_rgb_gray "color"Conversions"
    "COLOR_RGB2GRAY"     : 7,
    "COLOR_GRAY2BGR"     : 8,
    "COLOR_GRAY2RGB"     :"COLOR_GRAY2BGR",
    "COLOR_GRAY2BGRA"    : 9,
    "COLOR_GRAY2RGBA"    :"COLOR_GRAY2BGRA",
    "COLOR_BGRA2GRAY"    : 10,
    "COLOR_RGBA2GRAY"    : 11,

    "COLOR_BGR2BGR565"   : 12, //!<"Convert between RGB/BGR and BGR565 (16-bit images)
    "COLOR_RGB2BGR565"   : 13,
    "COLOR_BGR5652BGR"   : 14,
    "COLOR_BGR5652RGB"   : 15,
    "COLOR_BGRA2BGR565"  : 16,
    "COLOR_RGBA2BGR565"  : 17,
    "COLOR_BGR5652BGRA"  : 18,
    "COLOR_BGR5652RGBA"  : 19,

    "COLOR_GRAY2BGR565"  : 20, //!<"Convert between grayscale to BGR565 (16-bit images)
    "COLOR_BGR5652GRAY"  : 21,

    "COLOR_BGR2BGR555"   : 22,  //!<"Convert between RGB/BGR and BGR555 (16-bit images)
    "COLOR_RGB2BGR555"   : 23,
    "COLOR_BGR5552BGR"   : 24,
    "COLOR_BGR5552RGB"   : 25,
    "COLOR_BGRA2BGR555"  : 26,
    "COLOR_RGBA2BGR555"  : 27,
    "COLOR_BGR5552BGRA"  : 28,
    "COLOR_BGR5552RGBA"  : 29,

    "COLOR_GRAY2BGR555"  : 30, //!<"Convert between grayscale and BGR555 (16-bit images)
    "COLOR_BGR5552GRAY"  : 31,

    "COLOR_BGR2XYZ"      : 32, //!<"Convert RGB/BGR to"CIE XYZ, @ref"Color_convert_rgb_xyz "color"Conversions"
    "COLOR_RGB2XYZ"      : 33,
    "COLOR_XYZ2BGR"      : 34,
    "COLOR_XYZ2RGB"      : 35,

    "COLOR_BGR2YCrCb"    : 36, //!<"Convert RGB/BGR to luma-chroma (aka YCC), @ref"Color_convert_rgb_ycrcb "color"Conversions"
    "COLOR_RGB2YCrCb"    : 37,
    "COLOR_YCrCb2BGR"    : 38,
    "COLOR_YCrCb2RGB"    : 39,

    "COLOR_BGR2HSV"      : 40, //!<"Convert RGB/BGR to HSV (hue saturation value), @ref"Color_convert_rgb_hsv "color"Conversions"
    "COLOR_RGB2HSV"      : 41,

    "COLOR_BGR2Lab"      : 44, //!<"Convert RGB/BGR to"CIE Lab, @ref"Color_convert_rgb_lab "color"Conversions"
    "COLOR_RGB2Lab"      : 45,

    "COLOR_BGR2Luv"      : 50, //!<"Convert RGB/BGR to"CIE Luv, @ref"Color_convert_rgb_luv "color"Conversions"
    "COLOR_RGB2Luv"      : 51,
    "COLOR_BGR2HLS"      : 52, //!<"Convert RGB/BGR to HLS (hue lightness saturation), @ref"Color_convert_rgb_hls "color"Conversions"
    "COLOR_RGB2HLS"      : 53,

    "COLOR_HSV2BGR"      : 54, //!< backward"Conversions to RGB/BGR
    "COLOR_HSV2RGB"      : 55,

    "COLOR_Lab2BGR"      : 56,
    "COLOR_Lab2RGB"      : 57,
    "COLOR_Luv2BGR"      : 58,
    "COLOR_Luv2RGB"      : 59,
    "COLOR_HLS2BGR"      : 60,
    "COLOR_HLS2RGB"      : 61,

    "COLOR_BGR2HSV_FULL" : 66,
    "COLOR_RGB2HSV_FULL" : 67,
    "COLOR_BGR2HLS_FULL" : 68,
    "COLOR_RGB2HLS_FULL" : 69,

    "COLOR_HSV2BGR_FULL" : 70,
    "COLOR_HSV2RGB_FULL" : 71,
    "COLOR_HLS2BGR_FULL" : 72,
    "COLOR_HLS2RGB_FULL" : 73,

    "COLOR_LBGR2Lab"     : 74,
    "COLOR_LRGB2Lab"     : 75,
    "COLOR_LBGR2Luv"     : 76,
    "COLOR_LRGB2Luv"     : 77,

    "COLOR_Lab2LBGR"     : 78,
    "COLOR_Lab2LRGB"     : 79,
    "COLOR_Luv2LBGR"     : 80,
    "COLOR_Luv2LRGB"     : 81,

    "COLOR_BGR2YUV"      : 82, //!<"Convert between RGB/BGR and YUV
    "COLOR_RGB2YUV"      : 83,
    "COLOR_YUV2BGR"      : 84,
    "COLOR_YUV2RGB"      : 85,

    //! YUV 4:2:0 family to RGB
    "COLOR_YUV2RGB_NV12"  : 90,
    "COLOR_YUV2BGR_NV12"  : 91,
    "COLOR_YUV2RGB_NV21"  : 92,
    "COLOR_YUV2BGR_NV21"  : 93,
    "COLOR_YUV420sp2RGB"  :"COLOR_YUV2RGB_NV21",
    "COLOR_YUV420sp2BGR"  :"COLOR_YUV2BGR_NV21",

    "COLOR_YUV2RGBA_NV12" : 94,
    "COLOR_YUV2BGRA_NV12" : 95,
    "COLOR_YUV2RGBA_NV21" : 96,
    "COLOR_YUV2BGRA_NV21" : 97,
    "COLOR_YUV420sp2RGBA" :"COLOR_YUV2RGBA_NV21",
    "COLOR_YUV420sp2BGRA" :"COLOR_YUV2BGRA_NV21",

    "COLOR_YUV2RGB_YV12"  : 98,
    "COLOR_YUV2BGR_YV12"  : 99,
    "COLOR_YUV2RGB_IYUV"  : 100,
    "COLOR_YUV2BGR_IYUV"  : 101,
    "COLOR_YUV2RGB_I420"  :"COLOR_YUV2RGB_IYUV",
    "COLOR_YUV2BGR_I420"  :"COLOR_YUV2BGR_IYUV",
    "COLOR_YUV420p2RGB"   :"COLOR_YUV2RGB_YV12",
    "COLOR_YUV420p2BGR"   :"COLOR_YUV2BGR_YV12",

   "COLOR_YUV2RGBA_YV12" : 102,
   "COLOR_YUV2BGRA_YV12" : 103,
   "COLOR_YUV2RGBA_IYUV" : 104,
   "COLOR_YUV2BGRA_IYUV" : 105,
   "COLOR_YUV2RGBA_I420" :"COLOR_YUV2RGBA_IYUV",
   "COLOR_YUV2BGRA_I420" :"COLOR_YUV2BGRA_IYUV",
   "COLOR_YUV420p2RGBA"  :"COLOR_YUV2RGBA_YV12",
   "COLOR_YUV420p2BGRA"  :"COLOR_YUV2BGRA_YV12",

   "COLOR_YUV2GRAY_420"  : 106,
   "COLOR_YUV2GRAY_NV21" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_NV12" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_YV12" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_IYUV" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV2GRAY_I420" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV420sp2GRAY" :"COLOR_YUV2GRAY_420",
   "COLOR_YUV420p2GRAY"  :"COLOR_YUV2GRAY_420",

    //! YUV 4:2:2 family to RGB
   "COLOR_YUV2RGB_UYVY" : 107,
   "COLOR_YUV2BGR_UYVY" : 108,
    //COLOR_YUV2RGB_VYUY : 109,
    //COLOR_YUV2BGR_VYUY : 110,
   "COLOR_YUV2RGB_Y422" :"COLOR_YUV2RGB_UYVY",
   "COLOR_YUV2BGR_Y422" :"COLOR_YUV2BGR_UYVY",
   "COLOR_YUV2RGB_UYNV" :"COLOR_YUV2RGB_UYVY",
   "COLOR_YUV2BGR_UYNV" :"COLOR_YUV2BGR_UYVY",

   "COLOR_YUV2RGBA_UYVY" : 111,
   "COLOR_YUV2BGRA_UYVY" : 112,
    //COLOR_YUV2RGBA_VYUY : 113,
    //COLOR_YUV2BGRA_VYUY : 114,
   "COLOR_YUV2RGBA_Y422" :"COLOR_YUV2RGBA_UYVY",
   "COLOR_YUV2BGRA_Y422" :"COLOR_YUV2BGRA_UYVY",
   "COLOR_YUV2RGBA_UYNV" :"COLOR_YUV2RGBA_UYVY",
   "COLOR_YUV2BGRA_UYNV" :"COLOR_YUV2BGRA_UYVY",

   "COLOR_YUV2RGB_YUY2" : 115,
   "COLOR_YUV2BGR_YUY2" : 116,
   "COLOR_YUV2RGB_YVYU" : 117,
   "COLOR_YUV2BGR_YVYU" : 118,
   "COLOR_YUV2RGB_YUYV" :"COLOR_YUV2RGB_YUY2",
   "COLOR_YUV2BGR_YUYV" :"COLOR_YUV2BGR_YUY2",
   "COLOR_YUV2RGB_YUNV" :"COLOR_YUV2RGB_YUY2",
   "COLOR_YUV2BGR_YUNV" :"COLOR_YUV2BGR_YUY2",

   "COLOR_YUV2RGBA_YUY2" : 119,
   "COLOR_YUV2BGRA_YUY2" : 120,
   "COLOR_YUV2RGBA_YVYU" : 121,
   "COLOR_YUV2BGRA_YVYU" : 122,
   "COLOR_YUV2RGBA_YUYV" :"COLOR_YUV2RGBA_YUY2",
   "COLOR_YUV2BGRA_YUYV" :"COLOR_YUV2BGRA_YUY2",
   "COLOR_YUV2RGBA_YUNV" :"COLOR_YUV2RGBA_YUY2",
   "COLOR_YUV2BGRA_YUNV" :"COLOR_YUV2BGRA_YUY2",

   "COLOR_YUV2GRAY_UYVY" : 123,
   "COLOR_YUV2GRAY_YUY2" : 124,
    //CV_YUV2GRAY_VYUY    :"CV_YUV2GRAY_UYVY,
   "COLOR_YUV2GRAY_Y422" :"COLOR_YUV2GRAY_UYVY",
   "COLOR_YUV2GRAY_UYNV" :"COLOR_YUV2GRAY_UYVY",
   "COLOR_YUV2GRAY_YVYU" :"COLOR_YUV2GRAY_YUY2",
   "COLOR_YUV2GRAY_YUYV" :"COLOR_YUV2GRAY_YUY2",
   "COLOR_YUV2GRAY_YUNV" :"COLOR_YUV2GRAY_YUY2",

    //! alpha premultiplication
   "COLOR_RGBA2mRGBA"    : 125,
   "COLOR_mRGBA2RGBA"    : 126,

    //! RGB to YUV 4:2:0 family
   "COLOR_RGB2YUV_I420"  : 127,
   "COLOR_BGR2YUV_I420"  : 128,
   "COLOR_RGB2YUV_IYUV"  :"COLOR_RGB2YUV_I420",
   "COLOR_BGR2YUV_IYUV"  :"COLOR_BGR2YUV_I420",

   "COLOR_RGBA2YUV_I420" : 129,
   "COLOR_BGRA2YUV_I420" : 130,
   "COLOR_RGBA2YUV_IYUV" :"COLOR_RGBA2YUV_I420",
   "COLOR_BGRA2YUV_IYUV" :"COLOR_BGRA2YUV_I420",
   "COLOR_RGB2YUV_YV12"  : 131,
   "COLOR_BGR2YUV_YV12"  : 132,
   "COLOR_RGBA2YUV_YV12" : 133,
   "COLOR_BGRA2YUV_YV12" : 134,

    //! Demosaicing
   "COLOR_BayerBG2BGR" : 46,
   "COLOR_BayerGB2BGR" : 47,
   "COLOR_BayerRG2BGR" : 48,
   "COLOR_BayerGR2BGR" : 49,

   "COLOR_BayerBG2RGB" :"COLOR_BayerRG2BGR",
   "COLOR_BayerGB2RGB" :"COLOR_BayerGR2BGR",
   "COLOR_BayerRG2RGB" :"COLOR_BayerBG2BGR",
   "COLOR_BayerGR2RGB" :"COLOR_BayerGB2BGR",

   "COLOR_BayerBG2GRAY" : 86,
   "COLOR_BayerGB2GRAY" : 87,
   "COLOR_BayerRG2GRAY" : 88,
   "COLOR_BayerGR2GRAY" : 89,

    //! Demosaicing using Variable Number of Gradients
   "COLOR_BayerBG2BGR_VNG" : 62,
   "COLOR_BayerGB2BGR_VNG" : 63,
   "COLOR_BayerRG2BGR_VNG" : 64,
   "COLOR_BayerGR2BGR_VNG" : 65,

   "COLOR_BayerBG2RGB_VNG" :"COLOR_BayerRG2BGR_VNG",
   "COLOR_BayerGB2RGB_VNG" :"COLOR_BayerGR2BGR_VNG",
   "COLOR_BayerRG2RGB_VNG" :"COLOR_BayerBG2BGR_VNG",
   "COLOR_BayerGR2RGB_VNG" :"COLOR_BayerGB2BGR_VNG",

    //! Edge-Aware Demosaicing
   "COLOR_BayerBG2BGR_EA"  : 135,
   "COLOR_BayerGB2BGR_EA"  : 136,
   "COLOR_BayerRG2BGR_EA"  : 137,
   "COLOR_BayerGR2BGR_EA"  : 138,

   "COLOR_BayerBG2RGB_EA"  :"COLOR_BayerRG2BGR_EA",
   "COLOR_BayerGB2RGB_EA"  :"COLOR_BayerGR2BGR_EA",
   "COLOR_BayerRG2RGB_EA"  :"COLOR_BayerBG2BGR_EA",
   "COLOR_BayerGR2RGB_EA"  :"COLOR_BayerGB2BGR_EA",

    //! Demosaicing with alpha"Channel
   "COLOR_BayerBG2BGRA" : 139,
   "COLOR_BayerGB2BGRA" : 140,
   "COLOR_BayerRG2BGRA" : 141,
   "COLOR_BayerGR2BGRA" : 142,

   "COLOR_BayerBG2RGBA" :"COLOR_BayerRG2BGRA",
   "COLOR_BayerGB2RGBA" :"COLOR_BayerGR2BGRA",
   "COLOR_BayerRG2RGBA" :"COLOR_BayerBG2BGRA",
   "COLOR_BayerGR2RGBA" :"COLOR_BayerGB2BGRA",

   "COLOR_COLORCVT_MAX"  : 143,

   "INTERSECT_NONE" : 0,
   "INTERSECT_PARTIAL" : 1,
   "INTERSECT_FULL" : 2,
   "TM_SQDIFF" : 0,
   "TM_SQDIFF_NORMED" : 1,
   "TM_CCORR" : 2,
   "TM_CCORR_NORMED" : 3,
   "TM_CCOEFF" : 4,
   "TM_CCOEFF_NORMED" : 5,
   "COLORMAP_AUTUMN" : 0,
   "COLORMAP_BONE" : 1,
   "COLORMAP_JET" : 2,
   "COLORMAP_WINTER" : 3,
   "COLORMAP_RAINBOW" : 4,
   "COLORMAP_OCEAN" : 5,
   "COLORMAP_SUMMER" : 6,
   "COLORMAP_SPRING" : 7,
   "COLORMAP_COOL" : 8,
   "COLORMAP_HSV" : 9,
   "COLORMAP_PINK" : 10,
   "COLORMAP_HOT" : 11,
   "COLORMAP_PARULA" : 12,
   "MARKER_CROSS" : 0,
   "MARKER_TILTED_CROSS" : 1,
   "MARKER_STAR" : 2,
   "MARKER_DIAMOND" : 3,
   "MARKER_SQUARE" : 4,
   "MARKER_TRIANGLE_UP" : 5,
   "MARKER_TRIANGLE_DOWN" : 6
};

/**

CvType functions not implemented yet ...

static channels(type) {
  return ((type >> CvType.CV_CN_SHIFT) + 1)
}

static depth(type) {
  return (type & (CvType.CV_DEPTH_MAX - 1))
}

static isInteger(type) {
  return depth(type) < CvType.CV_32F
}

static ELEM_SIZE(type) {
  switch (depth(type)) {
  case CvType.CV_8U:
  case CvType.CV_8S:
      return channels(type)
  case CvType.CV_16U:
  case CvType.CV_16S:
      return 2 * channels(type)
  case CvType.CV_32S:
  case CvType.CV_32F:
      return 4 * channels(type)
  case CvType.CV_64F:
      return 8 * channels(type)
  default:
      alert("Unsupported this.CvType value: " + type)
  }
}

static typeToString(type) {
    let s = ""
    switch (depth(type)) {
    case CvType.CV_8U:
        s = "CV_8U"
        break;
    case CvType.CV_8S:
        s = "CV_8S"
        break;
    case CvType.CV_16U:
        s = "CV_16U"
        break;
    case CvType.CV_16S:
        s = "CV_16S"
        break;
    case CvType.CV_32S:
        s = "CV_32S"
        break;
    case CvType.CV_32F:
        s = "CV_32F"
        break
    case CvType.CV_64F:
        s = "CV_64F"
        break
    case this.CvType.CV_USRTYPE1:
        s = "CV_USRTYPE1"
        break
    default:
        console.error("Unsupported CvType value: " + type)
    }

    let ch = channels(type);
    if (ch <= 4)
        return s + "C" + ch
    else
        return s + "C(" + ch + ")"
  }
*/

export const Core = {
    "SVD_MODIFY_A" : 1,
    "SVD_NO_UV" : 2,
    "SVD_FULL_UV" : 4,
    "FILLED" : -1,
    "REDUCE_SUM" : 0,
    "REDUCE_AVG" : 1,
    "REDUCE_MAX" : 2,
    "REDUCE_MIN" : 3,
    "StsOk" : 0,
    "StsBackTrace" : -1,
    "StsError" : -2,
    "StsInternal" : -3,
    "StsNoMem" : -4,
    "StsBadArg" : -5,
    "StsBadFunc" : -6,
    "StsNoConv" : -7,
    "StsAutoTrace" : -8,
    "HeaderIsNull" : -9,
    "BadImageSize" : -10,
    "BadOffset" : -11,
    "BadDataPtr" : -12,
    "BadStep" : -13,
    "BadModelOrChSeq" : -14,
    "BadNumChannels" : -15,
    "BadNumChannel1U" : -16,
    "BadDepth" : -17,
    "BadAlphaChannel" : -18,
    "BadOrder" : -19,
    "BadOrigin" : -20,
    "BadAlign" : -21,
    "BadCallBack" : -22,
    "BadTileSize" : -23,
    "BadCOI" : -24,
    "BadROISize" : -25,
    "MaskIsTiled" : -26,
    "StsNullPtr" : -27,
    "StsVecLengthErr" : -28,
    "StsFilterStructContentErr" : -29,
    "StsKernelStructContentErr" : -30,
    "StsFilterOffsetErr" : -31,
    "StsBadSize" : -201,
    "StsDivByZero" : -202,
    "StsInplaceNotSupported" : -203,
    "StsObjectNotFound" : -204,
    "StsUnmatchedFormats" : -205,
    "StsBadFlag" : -206,
    "StsBadPoint" : -207,
    "StsBadMask" : -208,
    "StsUnmatchedSizes" : -209,
    "StsUnsupportedFormat" : -210,
    "StsOutOfRange" : -211,
    "StsParseError" : -212,
    "StsNotImplemented" : -213,
    "StsBadMemBlock" : -214,
    "StsAssert" : -215,
    "GpuNotSupported" : -216,
    "GpuApiCallError" : -217,
    "OpenGlNotSupported" : -218,
    "OpenGlApiCallError" : -219,
    "OpenCLApiCallError" : -220,
    "OpenCLDoubleNotSupported" : -221,
    "OpenCLInitError" : -222,
    "OpenCLNoAMDBlasFft" : -223,
    "DECOMP_LU" : 0,
    "DECOMP_SVD" : 1,
    "DECOMP_EIG" : 2,
    "DECOMP_CHOLESKY" : 3,
    "DECOMP_QR" : 4,
    "DECOMP_NORMAL" : 16,
    "NORM_INF" : 1,
    "NORM_L1" : 2,
    "NORM_L2" : 4,
    "NORM_L2SQR" : 5,
    "NORM_HAMMING" : 6,
    "NORM_HAMMING2" : 7,
    "NORM_TYPE_MASK" : 7,
    "NORM_RELATIVE" : 8,
    "NORM_MINMAX" : 32,
    "CMP_EQ" : 0,
    "CMP_GT" : 1,
    "CMP_GE" : 2,
    "CMP_LT" : 3,
    "CMP_LE" : 4,
    "CMP_NE" : 5,
    "GEMM_1_T" : 1,
    "GEMM_2_T" : 2,
    "GEMM_3_T" : 4,
    "DFT_INVERSE" : 1,
    "DFT_SCALE" : 2,
    "DFT_ROWS" : 4,
    "DFT_COMPLEX_OUTPUT" : 16,
    "DFT_REAL_OUTPUT" : 32,
    "DFT_COMPLEX_INPUT" : 64,
    "DCT_INVERSE" : "DFT_INVERSE",
    "DCT_ROWS" : "DFT_ROWS",
    "BORDER_CONSTANT" : 0,
    "BORDER_REPLICATE" : 1,
    "BORDER_REFLECT" : 2,
    "BORDER_WRAP" : 3,
    "BORDER_REFLECT_101" : 4,
    "BORDER_TRANSPARENT" : 5,
    "BORDER_REFLECT101" : "BORDER_REFLECT_101",
    "BORDER_DEFAULT" : "BORDER_REFLECT_101",
    "BORDER_ISOLATED" : 16,
    "SORT_EVERY_ROW" : 0,
    "SORT_EVERY_COLUMN" : 1,
    "SORT_ASCENDING" : 0,
    "SORT_DESCENDING" : 16,
    "COVAR_SCRAMBLED" : 0,
    "COVAR_NORMAL" : 1,
    "COVAR_USE_AVG" : 2,
    "COVAR_SCALE" : 4,
    "COVAR_ROWS" : 8,
    "COVAR_COLS" : 16,
    "KMEANS_RANDOM_CENTERS" : 0,
    "KMEANS_PP_CENTERS" : 2,
    "KMEANS_USE_INITIAL_LABELS" : 1,
    "LINE_4" : 4,
    "LINE_8" : 8,
    "LINE_AA ": 16,
    "FONT_HERSHEY_SIMPLEX" : 0,
    "FONT_HERSHEY_PLAIN" : 1,
    "FONT_HERSHEY_DUPLEX" : 2,
    "FONT_HERSHEY_COMPLEX" : 3,
    "FONT_HERSHEY_TRIPLEX" : 4,
    "FONT_HERSHEY_COMPLEX_SMALL" : 5,
    "FONT_HERSHEY_SCRIPT_SIMPLEX" : 6,
    "FONT_HERSHEY_SCRIPT_COMPLEX" : 7,
    "FONT_ITALIC" : 16,
    "ROTATE_90_CLOCKWISE" : 0,
    "ROTATE_180" : 1,
    "ROTATE_90_COUNTERCLOCKWISE" : 2,
    "TYPE_GENERAL" : 0,
    "TYPE_MARKER" : 0+1,
    "TYPE_WRAPPER" : 0+2,
    "TYPE_FUN" : 0+3,
    "IMPL_PLAIN" : 0,
    "IMPL_IPP" : 0+1,
    "IMPL_OPENCL" : 0+2,
    "FLAGS_NONE" : 0,
    "FLAGS_MAPPING" : 0x01,
    "FLAGS_EXPAND_SAME_NAMES" : 0x02
};
