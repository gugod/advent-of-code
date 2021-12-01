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

size_t make_moving_sums_of_3 (int *sums, int *nums, size_t n_nums) {
  size_t j = 0;
  for (size_t i = 2; i < n_nums; ++i) {
    sums[j++] = nums[i] + nums[i-1] + nums[i-2];
  }
  return j;
}

int main () {
  FILE *fh;
  int lines = 0;
  int nums[2000];
  int sums[2000];
  size_t n_sums;

  fh = fopen("input-1", "r");
  lines = read_input_nums(fh, nums);
  if (lines > 0) {
    n_sums = make_moving_sums_of_3 (sums, nums, lines);
    if (n_sums > 0) {
      printf("%d\n", increases(sums, n_sums));
    }
  }

  fclose(fh);
  return 0;
}
