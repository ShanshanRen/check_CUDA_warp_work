# check_CUDA_warp_work
A very simple exmaple to see how threads in different warps work when there is a two-layer loop and the loop control variables are different for each warp.

In the example, the loop control variables of warp 0 and warp 1 are not same. 
Warp 0 finishes inner loop earlier than Warp 1; Warp 0 finishes outer loop earlier than Warp 1.
Warp 0 finish the two-layer loops earlier than warp 1. 

use clock() to calculate the time used by each warp.


clock() is the device function so that we can use it in the device function.
