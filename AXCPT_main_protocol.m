% Main program for preprocessing of EEG datasets 
% All the individual steps are now in function form. 
% 18_5_2016
clear all 
close all 

%% Path information
Raw_Path='/Volumes/EEG2_MARIA/EEG/AXCPT/Raw_datasets/';
Analyzed_path='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/';
cd(Raw_Path)

%% Define list of folders, so list of subjects
listing_raw=dir('Subject_*');
Num_folders=length(listing_raw);

cd(Raw_Path)
% Define list of folders 
listing_raw=dir('Subject_*');
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
 
end
% test22=temp22(1,1)
clear kk listing_raw

%% Do the loading 
