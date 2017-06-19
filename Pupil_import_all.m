%% 29.3.2016 Moving to a new dimension Maria L. Stavrinou
% To run it needs the function importfile_AXCPT_pupil.m
clear all
close all
Raw_Pupil='/Volumes/EEG2_MARIA/EEG/AXCPT_BaselineCorrectedPupils/';
% Real raw pupil 
%Raw_Pupil='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/AXCPT_Rawpupil/'
cd(Raw_Pupil)

listing_raw=dir('StandardAXCPT*txt'); % This is sorted!
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
%     xlsfiles={listing_raw.name};
%     xlsfiles=sort(xlsfiles);
end

% Files 6: Subject_08 and 16: Subject_18 have Nans inside the
% files, and not at the end. 
temp22(6)=[];
temp22(16)=[];


% Define the big arrays to host all the subjects
% From the experimental protocol we have these:
Num_Subjects=length(temp22);
Num_trials=300; 
timepoints=432;
%
All_pupil_data=zeros(Num_Subjects, timepoints, Num_trials);
All_pupil_data_av=zeros(Num_Subjects, 432);

for kk=1:Num_Subjects
    filename=temp22{kk,1};
    [trialtime_num, timeVec, average, time_end_dp] = importfile_AXCPT_pupil(filename, 2, inf);
    All_pupil_data(kk,:,:)=trialtime_num;
    All_pupil_data_av(kk,:)=average;
end

% Now detect the Nans and save their indices. 
% Make an array to save those indices: All_indices
% All_indices=zeros[Num_subjects, ]
for ns=1:Num_Subjects
    temp_subject=All_pupil_data(ns, :,:);
    temp_subject=squeeze(temp_subject);
    
    for ne=1:Num_trials
         temp_detect=squeeze(All_pupil_data(ns, :, ne));
         temp_indices=find(isnan(temp_detect)==1);
     
         All_indices(ns).indices(ne).coordinates(:,:)=temp_indices; 
    end
%     
%     All_indices(ns).indices(ne).coordinates=temp_indices;     
%     indices=find(isnan(temp_subject)==1);
%    [I,J]=ind2sub(size(temp_subject), indices);
%    All_indices(ns).indices=[I,J];
end
    
%     %
%     
% As from 4.05.16
mkdir('AllSubjects_raw2')
cd('AllSubjects_raw2')
save All_pupil_data All_pupil_data
save All_pupil_data_av All_pupil_data_av

% Addition 25.4.2016
%% Detect where are the nans and  
