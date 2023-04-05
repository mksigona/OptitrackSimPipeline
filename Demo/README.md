# User Guide + Example Instructions
A video walkthrough of the examples are also available. 

## Ultrasound to Simulation Space Transformation (<sup>U</sup>T<sub>S</sub>) Creation
1. Create NIFTI file of transducer model using the [xdcrMask MATLAB script](Scripts/makeXdcr.m)
2. Load the saved Slicer scene from optical tracking. This can be done by opening "20200305_Optical_tracking_template.mrml". If you are having issues with opening the file, open 3D Slicer and select File -> Add Data. The files should be 
2. Import “xdcrMask.nii.gz” into 3D Slicer
3. Navigate to the “Volumes” module
4. Update “Image Spacing” to the correct resolution (set by makeXdcr.m) 
    - Note: This is required because when the transducer volume is written as a NIFTI file the header info will default to 1 mm. 
5. Create a new linear transformation for <sup>U</sup>T<sub>S</sub> and add it to the existing transformation hierarchy. A new transformation can be created from the following methods:
  1. Right clicking any item in the transform hierarchy list in the “Data” module and selecting “Insert transform”
  2. Switch to the “Transforms” module and under the “Active Transform” drop-down list select “Create a new linear transformation”
    - Note, it is recommended to create two separate transformations: 1 for the rotation and translation of the transducer model
6. First, manually rotate and translate the transducer model so that the transducer model aligns with the visible transducer surface in the T1-weighted MR image.  
7. Next, translate the transducer model so that the cube indicating the geometric focus of the transducer aligns with the predicted focus from optical tracking.  
    - Note the transducer surface may no longer align with the focus location if a bias correction was previously applied, such as in the case of the example shown. 
