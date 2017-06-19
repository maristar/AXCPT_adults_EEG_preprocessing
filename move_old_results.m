% Analyzing EEG dataset for RVS - Base - Test data. 
% 30 November 2015, Maria L. Stavrinou at PSI, UiO
% 14 January 2016, MLS
% 18 February 2016 for AXCPT, Maria L. Stavrinou
Analyzed_path='/Volumes/EEG2_MARIA/EEG/RVS/Analyzed_datasets/';
Raw_path='/Volumes/EEG2_MARIA/EEG/RVS/Raw_datasets/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 

cd(Raw_path)
% Define list of folders 
listing_raw=dir('Subject_*');
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
 
end
% test22=temp22(1,1)
clear kk listing_raw

Sessions={'Training1', 'Training2'};

for kk=2:Num_folders
    % Define on which subject we are working
    Subject_filename=temp22{kk,:}; 
    
    %Analyzed_path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/';
    Analyzed_path_folder=[Analyzed_path Subject_filename '/'];
    Raw_path_folder=[Raw_path Subject_filename '/'];
 
    
    % Load the exported edat2 file (later named Tfinal).
    cd(Analyzed_path_folder)
    delete('*clean.set')
%     
%     dir_mat=dir('*.mat');
%     if length(dir_mat)>0
%         movefile('*.mat','Uncleaned')
%     end
%     dir_set=dir('*autotrigger*set');
%     if length(dir_set)>0
%         movefile('*autotriggers*.set','Uncleaned')
%     end
end
