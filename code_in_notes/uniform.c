// file: uniform.c
#include<stdio.h>
#include<stdlib.h> // 使用标准库<stdlib.h>，包含rand()
int main(int argc, char const *argv[]) {
  // 打印出rand()所生成的最大整数
  printf("%d\n",RAND_MAX);
  // 设置seed
  srand(505);
  // 生成(0,1)上的10个随机数
  int i;
  for (i=0; i<5; ++i){
    double x=(double)rand()/RAND_MAX;
    printf("%f  ",x);
  }
  printf("\n");
  // 如果每次都设置seed生成(0,1)上的5个随机数
  //那么每次生成的随机数都相同
  for (i=0; i<5; ++i){
    srand(505);
    double x=(double)rand()/RAND_MAX;
    printf("%f  ",x);
  }
  printf("\n");
  return 0;
}
