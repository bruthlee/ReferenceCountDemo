//
//  Constants.h
//  ReferenceCountDemo
//
//  Created by bruthlee on 16/5/6.
//  Copyright © 2016年 demo.study. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#if DEBUG
#define DLOG(fmt,...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLOG(fmt,...) NSLog(fmt);
#endif

#endif /* Constants_h */
