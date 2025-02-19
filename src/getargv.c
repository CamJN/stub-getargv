#include "../include/libgetargv.h"

bool print_argv_of_pid(const char *start_pointer, const char *end_pointer) {
  return true;
}

bool get_argv_of_pid(const struct GetArgvOptions *options,
                     struct ArgvResult *result) {
  return true;
}

void free_ArgvArgcResult(struct ArgvArgcResult *result) {}
void free_ArgvEnvpResult(struct ArgvEnvpResult* result) {}
void free_ArgvResult(struct ArgvResult *result) {}

bool get_argv_and_argc_of_pid(pid_t pid, struct ArgvArgcResult *result) {
  return true;
}

int32_t get_arg_exact_size(pid_t pid) { return 0; }

bool print_argv_of_pid_to(const char *start_pointer, const char *end_pointer,
                          FILE *outstream) {
  return true;
}

bool get_argv_of_pid_no_malloc(const struct GetArgvOptions *options,
                               struct ArgvResult *retVal, size_t argsize) {
  return true;
}

bool get_argv_and_envp_of_pid(pid_t pid, struct ArgvEnvpResult* result){
  return true;
}
