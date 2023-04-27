#include "getargv.h"

export bool print_argv_of_pid(const char *start_pointer,
                              const char *end_pointer) {
  // irrelevant to bug
  return true;
}

export bool get_argv_of_pid(const struct GetArgvOptions *options,
                            struct ArgvResult *result) {
  int mib[3] = {CTL_KERN, KERN_PROCARGS2, 0};
  size_t size = 0;
  unsigned long argmax = 1024 * 1024;
  mib[2] = options->pid;

  result->buffer = (char *)malloc(argmax);
  if (result->buffer == NULL) {
    error_pre_malloc();
  }
  size = (size_t)argmax;
  if (sysctl(mib, 3, result->buffer, &size, NULL, 0) == -1) {
    errno = (getpgid(options->pid) < 0) ? ESRCH : EPERM;
    error_post_malloc(result);
  }
  // remainder removed, irrelevant
  return true;
}

export void free_ArgvArgcResult(struct ArgvArgcResult *result) {
  // irrelevant to bug
}
export void free_ArgvResult(struct ArgvResult *result) {
  // irrelevant to bug
}

export bool get_argv_and_argc_of_pid(pid_t pid, struct ArgvArgcResult *result) {
  int mib[3] = {CTL_KERN, KERN_PROCARGS2, 0};
  size_t size = 0;
  unsigned long argmax = 1024 * 1024;
  mib[2] = pid;

  result->buffer = (char *)malloc(argmax);
  if (result->buffer == NULL) {
    result->argv = NULL;
    result->argc = 0;
    error_pre_malloc();
  }
  size = (size_t)argmax;
  if (sysctl(mib, 3, result->buffer, &size, NULL, 0) == -1) {
    errno = (getpgid(pid) < 0) ? ESRCH : EPERM;
    result->argv = NULL;
    error_post_malloc2(result);
  }
  // remainder removed, irrelevant
  return true;
}
