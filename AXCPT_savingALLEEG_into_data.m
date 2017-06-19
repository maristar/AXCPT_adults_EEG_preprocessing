% 22 March saving the datasets of all subjects AXCPT 
% MLS
Raw_Path='/Volumes/EEG2_MARIA/EEG/AXCPT/Raw_datasets/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
Analyzed_path='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/';
% '/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/';

Analyzed_path_savedataMat='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/DataMat/';

cd(Raw_Path)
% Define list of folders 
listing_raw=dir('Subject_*');
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
 
end
% test22=temp22(1,1)
clear kk listing_raw
nchanGA=15;
ntimeGA=3584;
ntrigsGA=300;

for kk=1:(Num_folders)
    Folder_name=temp22{kk,:};
    if kk==1
        dataGA=zeros(nchanGA, ntimeGA, ntrigsGA);
    end
    cd(Analyzed_path)
    Analyzed_path_folder=[Analyzed_path temp22{kk,:} '/'];
    filename_set=[temp22{kk,:} '_512_ch_DC_epochs_tr2_auto.set'];
    EEG = pop_loadset('filename',filename_set,'filepath',Analyzed_path_folder);
    data=EEG.data;
    name_save=temp22{kk,:};
    cd(Analyzed_path_savedataMat)
    eval(['save ' name_save ' data']);
    clear data
%     % Make a mega array
%     dataGA=cat(3, data, dataGA); 
%     
%     name_save=['All_conditions_GA']; % TestGA
%     cd(Analyzed_path)
%     eval(['save ' name_save ' dataGA']);
    clear Analyzed_path_folder filename_set
end
