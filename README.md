# BRIO
**BR**ain area **I**nput **O**utput: visualization tool based on the Allen Brain Atlas connectivity database. It outputs a 3d reconstruction (circle size represents connectivity strenght) and a histogram.

## Requirements
- MATLAB (R2018a on a Windows computer was used for all testing)
- This repository (add all folders and subfolders to your MATLAB path)
- [The Allen Mouse Brain Atlas volume and annotations](http://data.cortexlab.net/allenCCF/) (download all 4 files from this link) 
- [AllenBrainAPI](https://github.com/SainsburyWellcomeCentre/AllenBrainAPI) 
- [hex2rgb](https://www.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb) 
- [allenCCF](https://github.com/cortex-lab/allenCCF) 
- [The npy-matlab repository](http://github.com/kwikteam/npy-matlab)

## Example:
### Agranular insular area input ###
3d representation             |  histogram
:-------------------------:|:-----:
![](https://github.com/Robertooooooo/BRIO/blob/master/input%20AI.gif)  |  ![](https://github.com/Robertooooooo/BRIO/blob/master/input%20AI%20hist.png)

### Agranular insular area (dorsal) output ###
3d representation             |  histogram
:-------------------------:|:-----:
![](https://github.com/Robertooooooo/BRIO/blob/master/output%20AI.gif)  |  ![](https://github.com/Robertooooooo/BRIO/blob/master/output%20AI%20hist.png)

## General instructions ##

In both the get_input and get_output files you have to point to the location of template_volume_10um.npy, annotation_volume_10um_by_index.npy and structure_tree_safe_2017.csv (line 25 to 27)

To get output of region:
```
>> get_output(exp_id)
```
exp_id is the experiment ID (a numer like this one 	485903475).
Download of the data from the server might be quite slow (5 min), depends on your connection.

To get input of region:

do a target search [here](http://connectivity.brain-map.org/) and then download the resulting CSV file. Import this file in Matlab workspace and name it input_table. Then type:
```
>> get_input(input_table)
```
Injection located inside the area of interest are deleted automatically

- - - - 
Connectivity strength is normalized by injection volume.
Projection_density (sum of detected projection pixels / sum of all pixels in voxel) was used to determine connectivity strenght.
- - - - - - - - - - - - - - - - - - - - - - - - - - -

Thanks to [cortex-lab](https://github.com/cortex-lab) for providing such useful repositories for free!!!

Code written by Roberto De Filippo
