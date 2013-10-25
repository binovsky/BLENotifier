#pragma once

// FONT
extern CGFloat  const  DEFAULT_FONT_SIZE;
extern NSString *const DEFAULT_FONT_NAME;
extern NSString *const DEFAULT_BOLD_FONT_NAME;
extern NSString *const DEFAULT_ITALIC_FONT_NAME;

extern UIFont* GET_DEFAULT_FONT(NSString* strFontName, int nSize);

#define DEFAULT_FONT(fontSize)              GET_DEFAULT_FONT(DEFAULT_FONT_NAME,fontSize)
#define DEFAULT_BOLD_FONT(fontSize)         GET_DEFAULT_FONT(DEFAULT_BOLD_FONT_NAME,fontSize)
#define DEFAULT_SEMIBOLD_FONT(fontSize)     GET_DEFAULT_FONT(DEFAULT_SEMIBOLD_FONT_NAME,fontSize)
#define DEFAULT_ITALIC_FONT(fontSize)       GET_DEFAULT_FONT(DEFAULT_ITALIC_FONT_NAME,fontSize)
#define DEFAULT_LIGHT_FONT(fontSize)        GET_DEFAULT_FONT(DEFAULT_LIGHT_FONT_NAME,fontSize)
#define DEFAULT_ICONS_FONT(fontSize)        GET_DEFAULT_FONT(DEFAULT_SPECIAL2_FONT_NAME,fontSize)

#define SEARCHFIELD_FONT                    GET_DEFAULT_FONT(DEFAULT_FONT_NAME,13)
