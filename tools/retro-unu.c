/* retro-unu.c

   This is a tool to extract code blocks from a RETRO-flavored
   Markdown source file.

   Code blocks start and end with ~~~ and test blocks start
   and end with ```, though this does support setting them
   from the command line.

   Copyright (c) 2017-2020 Charles Childers
*/


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

char code_start[33], code_end[33], test_start[33], test_end[33];

typedef void (*Handler)(char *);

void read_line(FILE *file, char *line_buffer) {
  int ch = getc(file);
  int count = 0;
  while ((ch != '\n') && (ch != EOF)) {
    line_buffer[count] = ch;
    count++;
    ch = getc(file);
  }
  line_buffer[count] = '\0';
}

int fence_boundary(char *buffer, int tests_enabled) {
  int flag = 1;
  if (strcmp(buffer, code_start) == 0) { flag = -1; }
  if (strcmp(buffer, code_end) == 0)   { flag = -1; }
  if (tests_enabled == 0) { return flag; }
  if (strcmp(buffer, test_start) == 0) { flag = -1; }
  if (strcmp(buffer, test_end) == 0)   { flag = -1; }
  return flag;
}

void unu(char *fname, int tests_enabled, Handler handler) {
  int inBlock = 0;
  char buffer[4096];
  FILE *fp;
  fp = fopen(fname, "r");
  if (fp == NULL) {
    printf("Unable to load file\n");
    exit(2);
  }
  while (!feof(fp)) {
    read_line(fp, buffer);
    if (fence_boundary(buffer, tests_enabled) == -1) {
      if (inBlock == 0) {
        inBlock = 1;
      } else {
        inBlock = 0;
      }
    } else {
      if (inBlock == 1) {
        handler(buffer);
      }
    }
  }
  fclose(fp);
}

void display(char *buffer) {
  printf("%s\n", buffer);
}

int arg_is(char *arg, char *value) {
  return (strcmp(arg, value) == 0);
}

int main(int argc, char **argv) {
  int tests = 0;
  int i = 1;
  strcpy(code_start, "~~~");
  strcpy(code_end,   "~~~");
  strcpy(test_start, "```");
  strcpy(test_end,   "```");
  if (argc > 1) {
    while (i < argc) {
      if (arg_is(argv[i], "--code-start") || arg_is(argv[i], "-cs")) {
        i++;
        strcpy(code_start, argv[i]);
      } else if (arg_is(argv[i], "--code-end") || arg_is(argv[i], "-ce")) {
        i++;
        strcpy(code_end, argv[i]);
      } else if (arg_is(argv[i], "--test-start") || arg_is(argv[i], "-ts")) {
        i++;
        strcpy(test_start, argv[i]);
      } else if (arg_is(argv[i], "--test-end") || arg_is(argv[i], "-te")) {
        i++;
        strcpy(test_end, argv[i]);
      } else if (arg_is(argv[i], "--include-tests") || arg_is(argv[i], "-t")) {
        tests = -1;
      } else {
        unu(argv[i], tests, &display);
      }
      i++;
    }
  }
  else {
    printf("err: no file specified\n");
  }
  return 0;
}
