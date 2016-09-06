all:
  nvcc  -arch=sm_35  --ptxas-options=-v example.cu  -O3  -o example
