#ifndef __dbg_h__
#define __dbg_h__

#include <stdio.h>
#include <errno.h>
#include <string.h>

#define TERM_RED    "\x1b[31;1m"
#define TERM_GREEN  "\x1b[32;1m"
#define TERM_YELLOW "\x1b[33;1m"
#define TERM_WHITE  "\x1b[1m"
#define TERM_COLOR_X "\x1b[m"

#ifdef NDEBUG
#define debug(MSG)
#else
#define debug(MSG) fprintf(stderr, "DEBUG (%s:%d:%s) %s\n", __FILE__, \
		__LINE__, __func__, MSG)
#endif

#define clean_errno() (errno == 0 ? "None" : strerror(errno))

#define log_err(MSG) fprintf(stderr, TERM_RED \
		"[ERROR]" TERM_COLOR_X " (%s:%d:%s, errno: %s) %s\n", \
		__FILE__, __LINE__, __func__, clean_errno(), MSG)

#define log_warn(MSG) fprintf(stderr, TERM_YELLOW \
		"[WARN]" TERM_COLOR_X " (%s:%d:%s, errno: %s) %s\n", \
		__FILE__, __LINE__, __func__, clean_errno(), MSG)

#define log_info(MSG) fprintf(stderr, TERM_WHITE \
		"[INFO]" TERM_COLOR_X " (%s:%d:%s) %s\n", \
		__FILE__, __LINE__, __func__, MSG)

#define check(A, MSG) { if (!(A)) { log_err(MSG); errno = 0; goto error; } }

#define sentinel(MSG) { log_err(MSG); errno = 0; goto error; }

#define check_mem(A) check((A), "Out of memory.")

#define check_debug(A, MSG) { if (!(A)) { debug(MSG); errno = 0; goto error; } }

#endif
