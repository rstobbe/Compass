//======================================================
// QueryReset
//======================================================

struct cudastruct {
    const char *Name;
    int Gblmem;
};

extern "C" void QueryReset(cudastruct* CUDA, char* ErrString);

//======================================================
// QueryReset
//====================================================== 
void QueryReset(cudastruct* CUDA, char* ErrString){

const char* ErrString0;
int device,deviceNum;
struct cudaDeviceProp deviceProp; 
cudastruct CUDA0;

cudaDeviceReset();

cudaGetDeviceCount(&deviceNum);
if (deviceNum < 1) {
    ErrString0 = "No Cuda Device";
    strcpy(ErrString,ErrString0);
    return;
}

cudaGetDevice(&device);
cudaGetDeviceProperties(&deviceProp,device);
CUDA0.Name = deviceProp.name;
CUDA0.Gblmem = deviceProp.totalGlobalMem;    
*CUDA = CUDA0;    

}