# ![](https://github.com/razeayres/parallelswatpy/blob/master/swatpy.ico) SWAT-HPC - a parallel module for the SUFI2
[![DOI:10.26848/rbgf.v.10.5.p1535-1544](https://zenodo.org/badge/DOI/10.26848/rbgf.v.10.5.p1535-1544.svg)](http://dx.doi.org/10.26848/rbgf.v.10.5.p1535-1544)
###### *Rodrigo de Queiroga Miranda, Josiclêda Domiciano Galvíncio*
###### Contact: rodrigo.qmiranda@gmail.com

### About
SWAT-HPC allows for distributed parallel calibration of SWAT model using the SWAT-CUP software (https://swat.tamu.edu/software/swat-cup/) in Microsoft® HPC clusters. The Python scripts were developed for the interpreter Python 3.6.9.

### Package usage
```r
ParallelSwatpy.bat <procs> <nodes> <sims> <UNC_path> <project_name>
```

Where ```<procs>``` is the total number of parallel processes that will be launched, ```<nodes>``` is the number of computer nodes that will receive the processes, ```<sims>``` is the number of simulations, ```<UNC_path>``` is the network path of the folder that holds the project (e.g., ```\\headnode\cluster_swatcup```), and ```<project_name>``` is name of the project (e.g., ```my_project.Sufi2.SwatCup```).
