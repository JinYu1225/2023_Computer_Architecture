// This code is modify from yptang5488.
// Try to implement CLZ through out the whole hamming distance code.

# ifndef __GNUC__
# define __asm__ asm
# endif

#include <stdio.h>

typedef unsigned long long uint64_t;
typedef unsigned short uint16_t;
uint64_t test1_x0 = 0x0000000000100000;
uint64_t test1_x1 = 0x00000000000FFFFF;
uint64_t test2_x0 = 0x0000000000000001;
uint64_t test2_x1 = 0x7FFFFFFFFFFFFFFE;
uint64_t test3_x0 = 0x000000028370228F;
uint64_t test3_x1 = 0x000000028370228F;

uint16_t count_leading_zeros(uint64_t x) {
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    x |= (x >> 32);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x5555555555555555);
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);

    return (64 - (x & 0x7f));
}

int HammingDistance(uint64_t x1, uint64_t x2) {
    int Hdist = 0;
    uint64_t c1 = x1 ^ x2;
    uint16_t clz_count = 0;
    // stop when there is no different between x1 and x2
    while(c1 != 0) {
        // find biggest different bit by clz
        clz_count = count_leading_zeros(c1);
        c1 = c1 << clz_count + 1;
        Hdist += 1;
    }
    return Hdist;
}

unsigned long get_cycle_count(void) {
    unsigned long cycle;
    asm volatile ("rdcycle %0" : "=r" (cycle));
    return cycle;
}

int main() {
    unsigned long start_cycle, end_cycle;

    start_cycle = get_cycle_count();
    HammingDistance(test1_x0, test1_x1);
    end_cycle = get_cycle_count();
    printf("Cycle Count: %lu\n", end_cycle - start_cycle);
    // printf("Hamming Distance = %d\n", HammingDistance(test1_x0, test1_x1));
    // printf("Hamming Distance = %d\n", HammingDistance(test2_x0, test2_x1));
    // printf("Hamming Distance = %d\n", HammingDistance(test3_x0, test3_x1));
    return 0;
}
