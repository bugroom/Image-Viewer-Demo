//
//  Config.h
//  Image viewer
//
//  Created by ZC on 2016/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#ifndef Config_h
#define Config_h

//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)


#define kMainPageUrlString @"http://service.picasso.adesk.com/v1/wallpaper/wallpaper?limit=30&adult=false&first=1&order=new&skip=%ld"
#define kClassUrlString @"http://service.picasso.adesk.com/v1/wallpaper/category?adult=false&first=1"

#define kHotUrlString @"http://service.picasso.adesk.com/v3/homepage?limit=30&skip=%ld&adult=false&did=866184024497864&first=1&order=hot"

#define kHotSearchUrlString @"http://service.picasso.adesk.com/v1/push/keyword"
#define kSearchResultUrlString @"http://so.picasso.adesk.com/v1/search/wallpaper/resource/%@?limit=30"


#endif /* Config_h */
