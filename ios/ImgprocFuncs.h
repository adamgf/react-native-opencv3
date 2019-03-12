//
//  ImgprocFuncs.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 3/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#ifndef ImgprocFuncs_h
#define ImgprocFuncs_h

extern std::vector<std::string> Imgproc;

extern std::vector<std::string> iptypes;

typedef enum ipfns {
    CVTCOLOR
} ipfns;

Mat cvtColorW(std::vector<ocvtypes>& ps);

#endif /* ImgprocFuncs_h */
