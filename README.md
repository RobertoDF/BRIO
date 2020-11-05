# BRIO
**BR**ain area **I**nput **O**utput: visualization and analysis tool based on the Allen Brain Atlas connectivity database. 

Output provides 4 different metrics: projection_energy_normalized, projection_density_normalized, projection_intensity_normalized or normalized_projection_volume (for more info: https://allensdk.readthedocs.io/en/latest/unionizes.html). 

Input provides only normalized_projection_volume.

## Requirements
- MATLAB (R2018a on a Windows computer was used for all testing)
- [The Allen Mouse Brain Atlas volume and annotations](http://data.cortexlab.net/allenCCF/) (download template and annotation volume files) 
- [AllenBrainAPI](https://github.com/SainsburyWellcomeCentre/AllenBrainAPI) 
- [hex2rgb](https://www.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb) 
- [allenCCF](https://github.com/cortex-lab/allenCCF) 
- [The npy-matlab repository](http://github.com/kwikteam/npy-matlab)


### Entorhinal cortex output ###
Density            |  Intensity
:------:|:-----:
![](https://github.com/RobertoDF/BRIO/blob/master/Suppl/EC%20projection%20density.gif)  |  ![](https://github.com/RobertoDF/BRIO/blob/master/Suppl/EC%20projection%20intensity.gif)

Energy            |  Volume
:------:|:-----:
![](https://github.com/RobertoDF/BRIO/blob/master/Suppl/EC%20projection%20energy.gif)  |  ![](https://github.com/RobertoDF/BRIO/blob/master/Suppl/EC%20projection%20volume.gif)



