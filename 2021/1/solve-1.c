#include <stdlib.h>
#include <stdio.h>

int read_input_nums (FILE *fh, int *nums) {
  int i = 0;
  int num = 0;
  while (fscanf(fh, "%d", &num) != EOF) {
    nums[i++] = num;
  }
  return i;
}

int increases (int *nums, size_t n_nums) {
  int inc = 0;

  size_t i = 0;
  for (i = 1; i < n_nums; i += 1) {
    if (nums[i] > nums[i-1]) {
      inc++;
    }
  }

  return inc;
}

int main () {
  FILE *fh;
  int lines = 0;
  int nums[2000];

  fh = fopen("input-1", "r");
  lines = read_input_nums(fh, nums);
  if (lines > 0) {
    printf("%d\n", increases(nums, lines));
  }

  fclose(fh);
  return 0;
}
