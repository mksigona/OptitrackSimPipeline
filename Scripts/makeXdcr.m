% Last Updated: 20230405
% MATLAB Version: R2022a 
% k-Wave Version: Version 1.4
% Script created by: Thomas J. Manuel & Michelle K. Sigona
% makeXdcr description:
%   Creates a NIFTI file of a transducer model using k-Wave functions for a
%   single-element, spherically curved transducer. This transducer model
%   can be used with the optical tracking informed simulation workflow
%   described in Sigona et al. 2023.  

close all;
clear;
clc;

%% Input parameters
% Transducer parameters
f0 = 802e3;                     % Frequency [Hz]
radius_mm = 63.2;               % Radius of curvature of transducer [mm]
diameter_mm = 64;               % Diameter of transducer [mm]

% Simulation grid parameters
dx = 0.25;                      % Grid spacing - isotropic [mm] 
PPW = 1500/f0/(dx*1e-3);        % Points per wavelength
disp(['Current points per wavelength: ' num2str(PPW,2)]);


axis_flag = 1;                  % Define transducer's axis of propagation 
                                %   1 = x-axis
                                %   2 = y-axis
                                %   3 = z-axis
bowl_flag = 1;                  % Set transducer position: 
                                %   0 = set transducer at top of the grid 
                                %   1 = set transducer at center of the
                                %   grid 
grid_flag = 1;                  % Flag to initiate prompt to set the grid 
                                % size. 
                                %   0 = grid size is already known, fill in
                                %   gridsize variable in line 41
                                %   1 = grid size is unknown and will
                                %   initiate prompt to set proper grid size
gridsize = [324,288,288];       % Fill in gridsize if desired size is known                                       

%% Create transducer model
% Determine size of transducer in pixels with current grid spacing
radius_pix = round(radius_mm/dx);
diameter_pix = round(diameter_mm/dx); 

% Diameter must be an odd number of grid points
if ~mod(diameter_pix,2)
    diameter_pix = diameter_pix + 1; 
end

% Determine grid size - choose low prime factors 
if grid_flag
    checkFactors(100,diameter_pix*2+100)
    disp([newline 'SET GRID SIZE. Choose low prime factors.' newline ...
        'Xdcr sizes: diam = ' num2str(diameter_pix) ' ROC = ' ... 
        num2str(radius_pix)]);
    gridsize = input([newline 'E.g. [128,128,256] or 128 if isotropic: ']);
end

if length(gridsize) > 1
    Nx = gridsize(1);
    Ny = gridsize(2);
    Nz = gridsize(3); 
else
    Nx = gridsize;
    Ny = gridsize; 
    Nz = gridsize;
end

% Determine bowl and fous positions 
if bowl_flag 
    bowl_pos = round([Nx/2,Ny/2,Nz/2]);
else
    % Set at top of grid with 20 pixels for PML
    if axis_flag == 1
        bowl_pos = round([Nx-20,Ny/2,Nz/2]);
    elseif axis == 2
        bowl_pos = round([Nx/2,Ny-20,Nz/2]);
    else
        bowl_pos = round([Nx/2,Ny/2,Nz-20]); 
    end
end

% Set focus position relative to the bowl
if axis_flag == 1
    focus_pos = round([bowl_pos(1)-radius_pix,bowl_pos(2),bowl_pos(3)]);
elseif axis == 2
    focus_pos = round([bowl_pos(1),bowl_pos(2)-radius_pix,bowl_pos(3)]);
else
    focus_pos = round([bowl_pos(1),bowl_pos(2),bowl_pos(3)-radius_pix]);
end

% Check if focus is within the grid and will stop execution of the script
% if it is not.
if sum(focus_pos < 1) || sum(focus_pos > max(gridsize))
    disp('WARNING: Focus not within grid.'); 
    return; 
end

% Create binary transducer model
bowl = makeBowl([Nx,Ny,Nz],bowl_pos,radius_pix,diameter_pix,focus_pos); 

% Modifying values of transducer model for visualization in 3D Slicer 
xdcr = bowl.*255;

% Create cube around focus for visualization in 3D Slicer
cs = 5;         % Cube size [pix]

% Check if cube is within the grid and will stop execution of the script
% if it is not.
if sum(focus_pos-cs < 1) || sum(focus_pos+cs > max(gridsize))
    disp('WARNING: Visualization cube is not within grid.'); 
    return; 
else
    xdcr(focus_pos(1)-cs:focus_pos(1)+cs,focus_pos(2)-cs:focus_pos(2)+cs, ...
    focus_pos(3)-cs:focus_pos(3)+cs) = 100;
end

% Set pixel to mark the focus
xdcr(focus_pos(1),focus_pos(2),focus_pos(3)) = 1; 

%% Output transducer model as compressed NIFTI file
niftiwrite(xdcr,'xdcrMask.nii','Compressed',true);
