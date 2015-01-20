#ifndef __dbg_h__
#define __dbg_h__

#include <stdio.h>
#include <errno.h> 
#include <string.h>
#include "term_color.h"

#ifdef NDEBUG
#define debug(M, ...)
#else 
#define debug(M, ...) fprintf(stderr, "DEBUG (%s:%d:%s) " M "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__) 
#endif

#define clean_errno() (errno == 0 ? "None" : strerror(errno))
 
#define log_err(M, ...) fprintf(stderr, TERM_RED "[ERROR]" TERM_COLOR_X " (%s:%d:%s, errno: %s) " M "\n", __FILE__, __LINE__, __func__, clean_errno(), ##__VA_ARGS__) 
 
#define log_warn(M, ...) fprintf(stderr, TERM_YELLOW "[WARN]" TERM_COLOR_X " (%s:%d:%s, errno: %s) " M "\n", __FILE__, __LINE__, __func__, clean_errno(), ##__VA_ARGS__) 
 
#define log_info(M, ...) fprintf(stderr, TERM_WHITE "[INFO]" TERM_COLOR_X " (%s:%d:%s) " M "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__) 

#define check(A, M, ...) if(!(A)) { log_err(M, ##__VA_ARGS__); errno=0; goto error; } 

#define sentinel(M, ...)  { log_err(M, ##__VA_ARGS__); errno=0; goto error; } 

#define check_mem(A) check((A), "Out of memory.")
 
#define check_debug(A, M, ...) if(!(A)) { debug(M, ##__VA_ARGS__); errno=0; goto error; } 

#endif