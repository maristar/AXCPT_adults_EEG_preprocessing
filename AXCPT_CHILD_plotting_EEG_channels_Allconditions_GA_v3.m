%% To do the grandaverage of CHild experiment AXCPT
% 5 March 2016
% 12 April 2016 for real children
% 18.4.16 problem with legends and not working (v2) trying to solve in v3
%% Path information
Raw_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/AXCPT/CHILDREN_TIK/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
Analyzed_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/CHILDREN_TIK/';

% Raw_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/AXCPT/';
% %'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
% Analyzed_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/';
% % '/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
% %'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/';

cd(Analyzed_Path)
% Define list of Folders - Subjects  
Name_subject_folder='Child*'
listing_raw=dir(Name_subject_folder);
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
end
clear listing_raw


nchanGA=66;
ntimeGA=2816;
ntrigsGA=0;

dataGA_AX=zeros(nchanGA, ntimeGA, ntrigsGA);
dataGA_AY=zeros(nchanGA, ntimeGA, ntrigsGA);
dataGA_BX=zeros(nchanGA, ntimeGA, ntrigsGA);
dataGA_BY=zeros(nchanGA, ntimeGA, ntrigsGA);

conditions={'AX','AY','BX','BY'};
for jjk=1:length(temp22) % For every subject - folder
    if jjk==1
        dataGA_AX=zeros(nchanGA, ntimeGA, ntrigsGA);
        dataGA_AY=zeros(nchanGA, ntimeGA, ntrigsGA);
        dataGA_BX=zeros(nchanGA, ntimeGA, ntrigsGA);
        dataGA_BY=zeros(nchanGA, ntimeGA, ntrigsGA);
     end
    
    for kk=1:length(conditions) % For every subject - condition 
        temp_condition=conditions(kk);
        temp_condition_char=char(temp_condition);

        % Define folder name for Analyzed and Raw for each subject 
        Folder_name=temp22{jjk,:};
        Analyzed_path_folder=[Analyzed_Path temp22{jjk,:}];
        Raw_path_folder=[Raw_Path temp22{jjk,:} '/'];

        % Go the Analyzed_path_folder for each subject
        % and search for the set files for each AX, AY condition
        cd(Analyzed_path_folder)
        Search_for_folder=[Name_subject_folder '*CHILD*autotriggers*set'];
        listing_sets=dir(Search_for_folder);
        Num_setfiles=length(listing_sets);
        for mm=1:Num_setfiles
            temp_sets{mm,:}=listing_sets(mm).name;
        end
        clear listing_sets

        % temp_sets{kk}(1:48)
        name1=temp_sets{kk,:}(1:46);%'Subject_103_25_512_ch_DC_epochs_tr2_autotriggers'; %AX.txt;
        name2=temp_condition_char;
        name3='.txt.set';
        name_file=[name1 name2 name3];
        name_data=[name1 name2];

        AreWeRight=strcmp(name_file, temp_sets{kk});
        if AreWeRight==1, 
            disp(['Working on file ' temp_sets{kk} ' for condition ' temp_condition_char]);
            EEG = pop_loadset('filename',name_file,'filepath',Analyzed_path_folder);
            EEG = eeg_checkset( EEG );
            eeglab redraw
            data=EEG.data;
            
%             TODOHERE  cat(1, arrayy1, array2)
            if strcmp(temp_condition, 'AX')==1 
                dataAX=EEG.data;
                data_temp=dataAX;
                dataGA_AX=cat(3, data_temp, dataGA_AX);
                clear data_temp dataAX
            elseif strcmp(temp_condition, 'AY')==1 
                  dataAY=EEG.data;
                  data_temp=dataAY;
                dataGA_AY=cat(3, data_temp, dataGA_AY);
                clear data_temp dataAY
            elseif strcmp(temp_condition, 'BX')==1
                  dataBX=EEG.data;
                  data_temp=dataBX;
                dataGA_BX=cat(3, data_temp, dataGA_BX);
                clear data_temp dataBX
            elseif strcmp(temp_condition, 'BY')==1 
                dataBY=EEG.data;
                data_temp=dataBY;
                dataGA_BY=cat(3, data_temp, dataGA_BY);
                clear data_temp dataBY
            end
        end
    end
% Make timevector for plotting 
Fs=EEG.srate;
pre_trigger = -EEG.xmin*1000; %msec  200 700
post_trigger = EEG.xmax*1000; %msec 1100 1600
data_pre_trigger = floor(pre_trigger*Fs/1000);
data_post_trigger = floor(post_trigger*Fs/1000);
timeVec = (-(data_pre_trigger):(data_post_trigger));
timeVec = timeVec';
timeVec_msec = timeVec.*(1000/Fs);
end

            
%For the GA
GA_EEGdata_AX=mean(dataGA_AX,3);
GA_EEGdata_AY=mean(dataGA_AY,3);
GA_EEGdata_BX=mean(dataGA_BX,3);
GA_EEGdata_BY=mean(dataGA_BY,3);

disp('Size of GA_EEGdata_AX')
disp(num2str(size(GA_EEGdata_AX)))

for jjj=1:length(conditions),
      temp_condition=conditions(jjj);
      temp_condition_char=char(temp_condition);
       switch temp_condition_char
           case 'AX'
               meanEEGdataAX=GA_EEGdata_AX;
               disp('AX here')
           case 'AY'
               meanEEGdataAY=GA_EEGdata_AY;
               disp('AY here')
           case 'BX'
           meanEEGdataBX=GA_EEGdata_BX;
           disp('BX here')
           case 'BY'
               meanEEGdataBY=GA_EEGdata_BY;
               disp('BY here')
       end
end


    chan_number=17;
    [ hb,hb2 ] = AXCPT_CHILD_make_plot(chan_number, timeVec_msec, meanEEGdataAX, meanEEGdataAY, meanEEGdataBX, meanEEGdataBY, ALLEEG);
    


%% SAVE the figures
% cd '/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/'
% cd FiguresGA_TIK
% 
% for mm=2:8,
%     temp_save_name_fig=[names_chan{mm-1} '_TIK_GA'];
% saveas(mm, temp_save_name_fig, 'png')
% saveas(mm, temp_save_name_fig, 'fig')
% end 
% %             
% 



