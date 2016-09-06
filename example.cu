#include <iostream>
#include <stdio.h>
#include <time.h>
#include <cuda.h>


using namespace std;

struct Address
{
    int numa;
    int numb;
};

__global__ void  pairhmm( Address * address, int * result_d)
{

    clock_t start_time=clock();
    int warp_index=threadIdx.x/32;
    int numa=address[warp_index]. numa;
    int numb=address[warp_index]. numb;
    int result=0;
 
    int round=0;
   for(round=0;round<2;round++)
  {   
    for(int i=0;i<numa;i++)
    {
 	if(threadIdx.x%32==0) printf("round=%d   warp %d  numa=%d  i=%d \n",round,  warp_index, numa,i);       
        for(int j=0;j<numb;j++)
        {
        
 	if(threadIdx.x%32==0) printf("warp %d            numb=%d  j=%d \n", warp_index, numb,j);       
        
    	result+=i+j*2;    
        }
    }
  
    if(threadIdx.x%32==0) printf("round=%d  warp %d endendend \n",round,  warp_index);       
    result_d[threadIdx.x]=result;
  }
    clock_t finish_time=clock();  
    int time=(int)( finish_time-start_time);	
    if(threadIdx.x%32==0)  	printf("%d\n", time);

}

int main()
{

    Address * address;
    address=(Address *)malloc(sizeof(Address)* 4);
    address[0].numa=2;
    address[0].numb=2;
  
    address[1].numa=4;
    address[1].numb=4;
    
    address[2].numa=6;
    address[2].numb=6;
    
    address[3].numa=8;
    address[3].numb=8;
    Address * address_d;

    cudaMalloc( (Address **)&address_d,sizeof(int) *100 );
    cudaMemcpy(address_d,address,4*sizeof(Address), cudaMemcpyHostToDevice);
    
    int blocksize=64;
    int gridsize=1;
    
    int *result_h;
    int *result_d;
    
    result_h=(int *) malloc( sizeof(int)* 128);
    cudaMalloc( (int **)&result_d,sizeof(int) *128);
    pairhmm<<<gridsize,blocksize>>>(address_d,result_d);
    cudaMemcpy(result_h,result_d,128*sizeof(int), cudaMemcpyDeviceToHost);
    
   // for(int i=0;i<128;i++)
   //   printf("index= %d %d\n", i, result_h[i]);
    
    cudaDeviceSynchronize();


    return 0;
}
