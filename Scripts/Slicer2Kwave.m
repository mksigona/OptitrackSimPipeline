% Last Updated: 20230406
% MATLAB Version: R2022a 
% k-Wave Version: Version 1.4
% Script created by: Thomas J. Manuel & Michelle K. Sigona
% makeXdcr description:
%   Loads in resampled image files and transducer model to run the k-Wave
%   simulation. Here, the RMS pressure is recorded. Used with the pipeline 
%   described in Sigona et al. 2023. 

close all;
clear;
clc;

%% Input parameters
% Set output filename
fnout = 'prms_output'; 

% Set transducer properties
f0 = 802e3;               % Frequency [Hz]
Amp = 282100;             % Amplitude at element surface

gpu_flag = 1;             % Flag for GPU-accelerated simulations
                          %     0 = Run on CPU
                          %     1 = Run on GPU

%% Load files
% Load CT volume. If filename is changed it will prompt to select the
% correct file. 
if isfile('CTsimspace.nii.gz')
    ct.data = niftiread('CTsimspace.nii.gz');
    ct.info = niftiinfo('CTsimspace.nii.gz'); 
else
    [ct_fname,path] = uigetfile('*.nii.gz');
    ct.data = niftiread([path ct_fname]); 
    ct.info = niftiinfo([path ct_fname]); 
end

% Load transducer model. If filename is changed it will prompt to select 
% correct file. 
if isfile('xdcrMask_Hardened.nii.gz')
    xdcr = niftiread('xdcrMask_Hardened.nii.gz'); 
else
    [xdcr_fname,path] = uigetfile('*.nii.gz');
    xdcr = niftiread([path xdcr_fname]); 
end

%% Setup medium properties
% There are severeal methods to convert from HU -> medium properties and we
% recommended filling in this section with methods and values that seem 
% fit. The function we used in this work can be found under Scripts 
% (getAcousticProperties.m). Here, we load previously converted medium 
% properties. 
load('demo_medium.mat');

%% Setup k-Wave parameters
dim = ct.info.ImageSize;
vox = 1e-3.*ct.info.PixelDimensions;            % [mm->m]

% Create kgrid
kgrid = kWaveGrid(dim(1), vox(1), dim(2), vox(2), dim(3), vox(3));
[kgrid.t_array, ~] = makeTime(kgrid, medium.sound_speed);

% Create pressure vector
source.p = createCWSignals(kgrid.t_array, f0, Amp, 0);

% Setup source
source.p_mask = (xdcr == 255);

% Find focus from NIFTI file
I = find(xdcr == 1); 
[l, m, n] = ind2sub(dim,I);
focus_pos = [l, m, n];

% Setup Sensor
sensor.mask = ones(dim);
sensor.record = {'p_rms'};   

%% Run simulation
if gpu_flag
    sensor_data = kspaceFirstOrder3DG(kgrid,medium,source,sensor);
else
    sensor_data = kspaceFirstOrder3D(kgrid,medium,source,sensor);
end

% Reshape sensor_data
pout_rms = reshape(sensor_data.p_rms,[kgrid.Nx,kgrid.Ny,kgrid.Nz]); 

% Visualize results at the geometric focus 
figure;
tiledlayout(1,3); 

nexttile;
imagesc(kgrid.z_vec*1e3,kgrid.y_vec*1e3, ...
    squeeze(pout_rms(focus_pos(1),:,:)));
axis image;
title('Prms - X slice');
xlabel('Z [mm]');
ylabel('Y [mm]');

nexttile;
imagesc(kgrid.z_vec*1e3,kgrid.x_vec*1e3, ...
    squeeze(pout_rms(:,focus_pos(2),:)));
axis image;
title('Pzrms - Y slice');
xlabel('Z [mm]');
ylabel('X [mm]');

nexttile;
imagesc(kgrid.y_vec*1e3,kgrid.x_vec*1e3, ...
    squeeze(pout_rms(:,:,focus_pos(3))));
axis image;
title('Prms - Z slice');
xlabel('Y [mm]');
ylabel('X [mm]');

%% Write output file
% Select file for header info. Recommended to use non-hardened transducer 
% volume.
if isfile('xdcrMask.nii.gz')
    info = niftiinfo('xdcrMask.nii.gz'); 
else
    [xdcr_fname,path] = uigetfile('*.nii.gz','Select file for header info');
    info = niftiinfo([path xdcr_fname]); 
end

% Update header info
info.Datatype = 'single';

% Write volume
niftiwrite(pout_rms,fnout,info,'Compressed',true); 
