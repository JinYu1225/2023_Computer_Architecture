#include <stdint.h>
#include <stdio.h>
    
uint32_t count_leading_zeros_32(uint32_t x)
{
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);

    x -= ((x >> 1) & 0x55555555);
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x3f)); // change 0x7f to 0x3f
}

int main(){
    // pixel test
    // 8-bit color depth for black and white photo
    uint32_t picture[5] = {20,80,128,150,231};
    uint32_t threshold = 230;
    uint32_t *pixel = &picture;

    for(int i = 0; i < 5; i++){
        uint32_t sub = threshold - *(pixel+i);
        printf("%d, ",i);
        printf("before = %d, ",*(pixel+i));
        sub = count_leading_zeros_32(sub);
        if(sub)
            *(pixel+i) = 0;
        else
            *(pixel+i) = 255;
        printf("after = %d\n",*(pixel+i));
    }

    return 0;
}