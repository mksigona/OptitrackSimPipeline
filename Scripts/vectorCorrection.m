<<<<<<< HEAD
% Last Updated: 20230407
% MATLAB Version: R2022a 
% Script created by: Michelle K. Sigona
% vectorCorrection description:
%   Reads in markups lists containing the ARFI and optically tracked focus
%   locations from 3D Slicer and creates a transformation to update the
%   transducer model's position in 3D Slicer. 

close all;
clear;
clc;

%% Load markups lists 
% Check if files exists with default filenames, otherwise prompted to 
% select file

if isfile('ARFI.fcsv')
    arfi = readcell('ARFI.fcsv','FileType','text','Delimiter',',', ...
        'NumHeaderLines',3);
else
    [arfi_fname,path] = uigetfile('*.fcsv','Select ARFI Markups List');
    arfi = readcell([path arfi_fname],'FileType','text','Delimiter',',',...
        'NumHeaderLines',3);
end

arfi_RAS = [arfi{1,2:4}];
arfi_RAS(1:2) = -arfi_RAS(1:2); 

if isfile('Optitrack.fcsv')
    optitrack = readcell('Optitrack.fcsv','FileType','text','Delimiter',...
        ',','NumHeaderLines',3);
else
    [optitrack_fname,path] = uigetfile('*.fcsv',['Select Optically ' ...
        'tracked Focus Markups List']);
    optitrack = readcell([path optitrack_fname],'FileType','text', ...
        'Delimiter',',','NumHeaderLines',3);
end

optitrack_RAS = [optitrack{1,2:4}];
optitrack_RAS(1:2) = -optitrack_RAS(1:2); 

vector = arfi_RAS - optitrack_RAS;

%% Write transform
AffineTransform_double_3_3 = zeros(12,1);
AffineTransform_double_3_3(1) = 1;
AffineTransform_double_3_3(5) = 1; 
AffineTransform_double_3_3(9) = 1;
AffineTransform_double_3_3(10:end) = vector; 

fileID = fopen('T_VectorCorrection.txt','w');
fprintf(fileID,'#Insight Transform File V1.0\n');
fprintf(fileID,'#Transform 0\n');
fprintf(fileID,'Transform: AffineTransform_double_3_3\n');
fprintf(fileID,'Parameters: ');
for i = 1:length(AffineTransform_double_3_3)
    fprintf(fileID,'%f ',AffineTransform_double_3_3(i));
end
fprintf(fileID,'\nFixedParameters: 0 0 0');
fclose(fileID);
=======
% Last Updated: 20230407
% MATLAB Version: R2022a 
% Script created by: Michelle K. Sigona
% vectorCorrection description:
%   Reads in markups lists containing the ARFI and optically tracked focus
%   locations from 3D Slicer and creates a transformation to update the
%   transducer model's position in 3D Slicer. 

close all;
clear;
clc;

%% Load markups lists 
% Check if files exists with default filenames, otherwise prompted to 
% select file

if isfile('ARFI.fcsv')
    arfi = readcell('ARFI.fcsv','FileType','text','Delimiter',',', ...
        'NumHeaderLines',3);
else
    [arfi_fname,path] = uigetfile('*.fcsv','Select ARFI Markups List');
    arfi = readcell([path arfi_fname],'FileType','text','Delimiter',',',...
        'NumHeaderLines',3);
end

arfi_RAS = [arfi{1,2:4}];
arfi_RAS(1:2) = -arfi_RAS(1:2); 

if isfile('Optitrack.fcsv')
    optitrack = readcell('Optitrack.fcsv','FileType','text','Delimiter',...
        ',','NumHeaderLines',3);
else
    [optitrack_fname,path] = uigetfile('*.fcsv',['Select Optically ' ...
        'tracked Focus Markups List']);
    optitrack = readcell([path optitrack_fname],'FileType','text', ...
        'Delimiter',',','NumHeaderLines',3);
end

optitrack_RAS = [optitrack{1,2:4}];
optitrack_RAS(1:2) = -optitrack_RAS(1:2); 

vector = arfi_RAS - optitrack_RAS;

%% Write transform
AffineTransform_double_3_3 = zeros(12,1);
AffineTransform_double_3_3(1) = 1;
AffineTransform_double_3_3(5) = 1; 
AffineTransform_double_3_3(9) = 1;
AffineTransform_double_3_3(10:end) = vector; 

fileID = fopen('T_VectorCorrection.txt','w');
fprintf(fileID,'#Insight Transform File V1.0\n');
fprintf(fileID,'#Transform 0\n');
fprintf(fileID,'Transform: AffineTransform_double_3_3\n');
fprintf(fileID,'Parameters: ');
for i = 1:length(AffineTransform_double_3_3)
    fprintf(fileID,'%f ',AffineTransform_double_3_3(i));
end
fprintf(fileID,'\nFixedParameters: 0 0 0');
fclose(fileID);
>>>>>>> d8888414b199c2166d49df0a0221fcb3d6af45f7
