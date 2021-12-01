/* clang -o solve-part2 solve-part2.c; ./solve-part2 */

#include <stdio.h>
#include <stdint.h>

#define __STDC_FORMAT_MACROS
#include <inttypes.h>

int play() {
  uint64_t nextcup[1000001];
  nextcup[0] = 0;

  uint64_t cur = 3;

  uint64_t cups[9] = {3,6,8,1,9,5,7,4,2};

  uint64_t i;
  for (i = 0; i < 8; i++) {
    nextcup[cups[i]] = cups[i+1];
  }
  nextcup[cups[8]] = 10;
  for (i = 10; i < 1000000; i++) {
    nextcup[i] = i+1;
  }
  nextcup[1000000] = 3;

  unsigned int round = 0;
  uint64_t dest;
  uint64_t picked[3];
  while (round++ < 10000000) {
    picked[0] = nextcup[cur];
    picked[1] = nextcup[picked[0]];
    picked[2] = nextcup[picked[1]];

    dest = cur - 1;

    while ((dest < 1) || (dest == cur) || (dest == picked[0]) || (dest == picked[1]) || (dest == picked[2])) {
      if (dest == 0) {
        dest = 1000000;
      } else {
        dest--;
      }
    }
    /* printf("round %u, dest: %u\n", round, dest); */

    cur = nextcup[cur] = nextcup[picked[2]];
    nextcup[picked[2]] = nextcup[dest];
    nextcup[dest] = picked[0];

  }

  cur = 1;
  for (i = 0; i < 9; i++) {
    printf(" %" PRIu64, cur);
    cur = nextcup[cur];
  }
  printf("\n");

  cur = 1;
  printf("Part 2: " "%"PRIu64 " * " "%"PRIu64 " = " "%"PRIu64 "\n",
         nextcup[cur],
         nextcup[nextcup[cur]],
         nextcup[cur] * nextcup[nextcup[cur]]);

  return 0;
}

int main() {
  play();
  return 0;
}
