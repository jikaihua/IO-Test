#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include "stdio.h"
#include "stdlib.h"
#include "math.h"
#include "time.h"


#define Nx			510		    // Dimension X
#define Ny			510			// Dimension Y
#define Nz			510			// Dimension Z

//Mapping function
#define STRIDE			((Ny+2)*(Nz+2))
#define WIDTH			(Nz+2)
#define pos(x,y,z)		(STRIDE*(x)+WIDTH*(y)+(z))

#define LENMAX		256
#define REAL		double

////////////////////////////
// CPU I/O function
////////////////////////////
void Init(REAL *P1,REAL *U1);
void WriteFields(REAL *P,REAL *U);


////////////////////////////////////////////////
//              Main CPU program              //
////////////////////////////////////////////////
int main(int argc, char **argv)
{

	size_t SizeGrid = (Nx+2)*(Ny+2)*(Nz+2);
	REAL *h_Psi=(REAL*)malloc(SizeGrid*sizeof(REAL)) ;	
	REAL *h_U=(REAL*)malloc(SizeGrid*sizeof(REAL)) ;	
	

	clock_t begin=clock();

    printf("Initializing...\n");
	Init(h_Psi,h_U);
	WriteFields(h_Psi,h_U);
	
	clock_t end=clock();
	REAL CompTime=(end-begin)/CLOCKS_PER_SEC;
    printf("\n\nThe time of writing binary files (2 GB) is %d s\n", int(CompTime));
    

	free(h_Psi) ;
	free(h_U) ;
	
	return EXIT_SUCCESS;
}


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Initialization //////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
void Init(REAL *P1,REAL *U1)
{
	REAL r=((REAL) rand() / (RAND_MAX));
	for (int i=0;i<Nx+2;i++) {
		for (int j=0;j<Ny+2;j++) {
			for (int k=0;k<Nz+2;k++) {
				    
					P1[pos(i,j,k)]=r;
					U1[pos(i,j,k)]=r*r;	
			}
		}
	}
}


/////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Output /////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
void WriteFields(REAL *P,REAL *U)
{
	//================================================
	// Output dat file
	//================================================
	char FileName1[256];
	FILE *OutFile1;	
    sprintf(FileName1,"File1.dat");
    OutFile1=fopen(FileName1,"w");
    
    for(int i=0; i<Nx+2; i++) {
        for(int j=0; j<Ny+2; j++) {
            for(int k=0; k<Nz+2; k++) {
                
                REAL d = P[pos(i,j,k)];
                
                fwrite((char*)&d,sizeof(REAL),1,OutFile1);
                
            }
        }
    }
    fclose(OutFile1);
    printf("Written File1.dat \n");	
	
	char FileName2[256];
	FILE *OutFile2;	
    sprintf(FileName2,"File2.dat");
    OutFile2=fopen(FileName2,"w");
    
    for(int i=0; i<Nx+2; i++) {
        for(int j=0; j<Ny+2; j++) {
            for(int k=0; k<Nz+2; k++) {
                
                REAL d = U[pos(i,j,k)];
                
                fwrite((char*)&d,sizeof(REAL),1,OutFile2);
                
            }
        }
    }
    fclose(OutFile2);
	printf("Written File2.dat \n");	    
}