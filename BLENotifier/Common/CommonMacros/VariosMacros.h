#pragma once

// SAFE_RELEASE
#define SAFE_RELEASE(p) if (p != nil) {[p release]; p = nil;}

// ASSERT_VALID musts proceed the expression
#ifdef _DEBUG
#ifndef	_ASSERT_VALID
#define _ASSERT_VALID(exp) { if(!(exp)) { fprintf( stderr, "ASSERT - %s line %d\n", __FILE__, __LINE__ ); /*kill(getpid(), SIGSTOP);*/} }
#endif
#else
#define _ASSERT_VALID(exp) exp
#endif

// ASSERT does not proceed the expression in Release mode
#ifdef _DEBUG
#ifndef	_ASSERT
#define _ASSERT(exp) { if(!(exp)) { fprintf( stderr, "ASSERT - %s line %d\n", __FILE__, __LINE__ ); /*kill(getpid(), SIGSTOP);*/} }
#endif
#else
#define _ASSERT(exp)
#endif

#define _ASSERT_ONCE { static INT c = 0; assert(++c == 1); }