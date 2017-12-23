#include <stdio.h>

int isPrime(int num) {
  int result = 1;
  for (int d = 2; d <= num; d++) {
    for (int e = 2; e <= num; e++) {
      if (d * e == num) {
        result = 0;
      }
    }
  }
  return result;
}

int main(int argc, char* argv[]) {
  printf("Hello, world!\n");
  int a = 1, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
  // b = 105700;
  // c = 122700;
  b = 14;
  c = 1714;

  for(; b != c; b += 17) {
    if (!isPrime(b)) {
      h = h + 1;
    }
  }

  printf("Value in h: %d\n", h);
  printf("Final state of registers: a: %d, b: %d, c: %d, d: %d, e: %d, f: %d, g: %d, h: %d", a, b, c, d, e, f, g, h);
}

// 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167
