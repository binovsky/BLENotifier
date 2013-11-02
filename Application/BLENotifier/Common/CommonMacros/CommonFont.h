#pragma once

// FONT
extern CGFloat  const  DEFAULT_FONT_SIZE;
extern NSString *const DEFAULT_FONT_NAME;
extern NSString *const DEFAULT_BOLD_FONT_NAME;
extern NSString *const DEFAULT_ITALIC_FONT_NAME;

extern UIFont* GET_DEFAULT_FONT(NSString* strFontName, int nSize);

#define FONT_REGULAR(fontSize)              GET_DEFAULT_FONT(DEFAULT_FONT_NAME,fontSize)
#define FONT_BOLD(fontSize)                 GET_DEFAULT_FONT(DEFAULT_BOLD_FONT_NAME,fontSize)
#define FONT_ITALIC(fontSize)               GET_DEFAULT_FONT(DEFAULT_ITALIC_FONT_NAME,fontSize)
