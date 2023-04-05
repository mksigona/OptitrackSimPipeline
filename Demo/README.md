# User Guide + Example Instructions
A video walkthrough of the examples are also available here. 

## Ultrasound to Simulation Space Transformation (<sup>U</sup>T<sub>S</sub>) Creation
1. Create NIFTI file of transducer model using the [xdcrMask MATLAB script](Scripts/makeXdcr.m) (makeXdcr.m)
2. Load all files in "\Transform Creation Example\Optical Tracking Data\" folder into Slicer. Under "Transform Hierarchy" of the data module, arrange the linear transformations into the correct hierarchy shown here: 
<p align="center">
  <img src="https://user-images.githubusercontent.com/54997782/230182433-cdd3009e-9d7d-477f-a7d6-d6af62a336de.png?raw=true" alt="Screenshot of the transformation hierarchy in 3D Slicer for an optical tracking dataset."/>
</p>
3. Import “xdcrMask.nii.gz” into 3D Slicer
4. Navigate to the “Volumes” module
5. Update “Image Spacing” to the correct resolution (set by makeXdcr.m). For this example this is 0.25 mm.  
    - **Note:** This is required since the transducer volume is written as a NIFTI file without header info, it defaults to 1 mm
6. Create a new linear transformation for <sup>U</sup>T<sub>S</sub> and add it to the existing transformation hierarchy. A new transformation can be created from the following methods:
  - Right clicking any item in the transform hierarchy list in the “Data” module and selecting “Insert transform”
  - Switch to the “Transforms” module and under the “Active Transform” drop-down list select “Create a new linear transformation”
    - **Note:** it is recommended to create two separate transformations for the rotation and translation of the transducer model
7. Add the transducer model to the transform hierarchy and manually rotate and translate the transducer model so that the transducer model aligns with the visible transducer surface in the T1-weighted MR image  

8. Translate the transducer model so that the cube indicating the geometric focus of the transducer aligns with the predicted focus from optical tracking 
    - **Note:** the transducer surface may no longer align with visible surface from the MR image if a bias correction was applied to the translation between the ultasound focus location and the transducer tracker, which is the case for this example dataset
9. If two separate transformations were created, move the two transforms outside of the hierarchy and harden the innermost transformation. 

Example of <sup>U</sup>T<sub>S</sub> are included in the "\Transform Creation Example\" folder. 
- "T_SimulationToUltrasound_Rot.h5" and "T_SimulationToUltrasound_Trans.h5" are the two transformations used to manually align the transducer model to the T1-weighted image
- "T_SimulationToUltrasound.h5" is the final combined transformation 

## Pipeline Demonstration using an *ex vivo* Skull Cap Dataset
1. Load all files in "\Exvivo Dataset\Optical Tracking Data\" folder into Slicer. Under "Transform Hierarchy" of the data module, arrange the linear transformations into the hierarchy: 
<p align="center">
  <img src="https://user-images.githubusercontent.com/54997782/230182156-9a60b2a9-25cd-4710-8ae2-f40617b6be12.png?raw=true" alt="Screenshot of the transformation hierarchy in 3D Slicer for the ex vivo optical tracking dataset."/>
</p>
