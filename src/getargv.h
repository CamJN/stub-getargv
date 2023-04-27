#ifndef GETARGV_H_
#define GETARGV_H_

/*-
 * Copyright: see LICENSE file
 */
#include "../include/libgetargv.h"

#include <errno.h> /* provides errno macro and the E... constants */
#include <stdio.h> /* provides FILE, stdout, fwrite, printf, fprintf, stderr, perror */
#include <stdlib.h> /* provides malloc, free, exit, EXIT_* macros, strtoul for c89,  */
#include <string.h> /* provides memcpy, memchr */
#include <sys/sysctl.h> /* provides sysctl, ARG_MAX, CTL_KERN, KERN_ARGMAX, KERN_PROCARGS2 */
#include <unistd.h> /* provides extern char* optarg; and getpgid */
#include <stdalign.h>

#define export __attribute__((visibility("default")))

int32_t get_arg_max(void);
bool print_argv_of_pid_to(const char *start_pointer, const char *end_pointer, FILE *outstream);
#define succeed() return true
#define error_pre_malloc() return false
#define error_post_malloc(result)                                              \
  do {                                                                         \
    free(result->buffer);                                                      \
    result->buffer = NULL;                                                     \
    result->start_pointer = NULL;                                              \
    result->end_pointer = NULL;                                                \
    return false;                                                              \
  } while (false)
#define error_post_malloc2(result)                                             \
  do {                                                                         \
    free(result->buffer);                                                      \
    free(result->argv);                                                        \
    result->buffer = NULL;                                                     \
    result->argv = NULL;                                                       \
    result->argc = 0;                                                          \
    return false;                                                              \
  } while (false)

#endif /* GETARGV_H_ */
