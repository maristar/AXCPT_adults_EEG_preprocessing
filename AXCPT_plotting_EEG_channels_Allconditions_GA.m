%% To do the grandaverage of Adult experiment AXCPT
% 5 March 2016

% clear all 
% close all
%% Define path for Raw and Analyzed datasets
Raw_Path='/Volumes/EEG2_MARIA/EEG/AXCPT/Raw_datasets/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
Analyzed_Path='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/';
Local_path ='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/FiguresGA/';
%Local_path ='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/DataMat/All_channels_AX_AY_for_wavelets/';
cd(Analyzed_Path)

% Raw_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/AXCPT/';
% %'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
% Analyzed_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/';

%% Define list of Folders - Subjects  
Name_subject_folder='Subject_*';
listing_raw=dir(Name_subject_folder);
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
end
clear listing_raw

% When to do function - this to be input argument (nchan)
nchanGA=3;
ntimeGA=896; %1894; % TODO this changes depending on the type of datasets
ntrigsGA=1; % Changed from 0 to 1, 15.4.2016 MLS

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
    
    for kk=1:length(conditions) % For every condition 
        temp_condition=conditions(kk);
        temp_condition_char=char(temp_condition);

        % Define folder name for Analyzed and Raw for each subject 
        Folder_name=temp22{jjk,:};
        Analyzed_path_folder=[Analyzed_Path temp22{jjk,:} '/'];
        Raw_path_folder=[Raw_Path temp22{jjk,:} '/'];

        % Go the Analyzed_path_folder for each subject
        % and search for the set files for each AX, AY condition
        cd(Analyzed_path_folder)
        Search_for_folder=[Name_subject_folder '*auto_3_chan_filttriggers*set'];
        listing_sets=dir(Search_for_folder);
        Num_setfiles=length(listing_sets);
        for mm=1:Num_setfiles
            temp_sets{mm,:}=listing_sets(mm).name;
        end
        clear listing_sets

        % temp_sets{kk}(1:48)
        name1=temp_sets{kk,:}(1:end-13);%'Subject_103_25_512_ch_DC_epochs_tr2_autotriggers'; %AX.txt;
        name2=temp_condition_char;
        name3='.txt3ch.set';
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
            
% Interesting Electrodes
names_chan={'FZ' 'OZ' 'CZ'};

% And their names
% To bs <
FZ_name='Fz';%EEG.chanlocs(38).labels;
%CP3_name=EEG.chanlocs(18).labels;
%C2_name=EEG.chanlocs(49).labels;
OZ_name='Oz';%EEG.chanlocs(29).labels;
CZ_name='Cz'; %EEG.chanlocs(48).labels;
% FZ_name=EEG.chanlocs(38).labels;
% Cz_name=EEG.chanlocs(48).labels;
% AFZ_name=EEG.chanlocs(37).labels;
% AF3_name=EEG.chanlocs(3).labels;
% AF4_name=EEG.chanlocs(36).labels;

for jjj=1:length(conditions),
      temp_condition=conditions(jjj);
      temp_condition_char=char(temp_condition);
       switch temp_condition_char
           case 'AX'
               meanEEGdata=GA_EEGdata_AX;
               disp('AX here')
           case 'AY'
               meanEEGdata=GA_EEGdata_AY;
               disp('AY here')
           case 'BX'
           meanEEGdata=GA_EEGdata_BX;
           disp('BX here')
           case 'BY'
               meanEEGdata=GA_EEGdata_BY;
               disp('BY here')
       end
   
%     C1=meanEEGdata(12,:);
%     CP3=meanEEGdata(18,:);
% %     C2=meanEEGdata(49,:);
%     Oz=meanEEGdata(29,:);
%     CZ=meanEEGdata(48,:);
%     FZ=meanEEGdata(38,:);
%     AFZ=meanEEGdata(37,:);
%     AF3=meanEEGdata(3,:);
%     AF4=meanEEGdata(36,:);
    OZ=meanEEGdata(1,:);
    CZ=meanEEGdata(3,:);
    FZ=meanEEGdata(2,:);
    
%% Find the correct limits for the plot 
    %TimeVec TODO substract 1 it is 3585 and not 3584
    % Time of baseline -500 
    time_minus500=find(timeVec_msec>-500);
    time_minus500=min(time_minus500);
    % Time of zero 0
    time_zero_idp=find(timeVec_msec==0); % 0 
    % Time after zero 
    time_after_zero_temp=find(timeVec_msec<500);% 500
    time_after_zero_idp=max(time_after_zero_temp);

% Here below limits only for around stim2
    time_before_stim2_temp=find(timeVec_msec>2850);% 2800
    time_before_stim2_idp=min(time_before_stim2_temp);
    
    time_after_stim2_temp1=find(timeVec_msec>3500);% 3500
    time_after_stim2_idp1=min(time_after_stim2_temp1);
    
    
    time_after_stim2_temp2=find(timeVec_msec>3300);% 3500
    time_after_stim2_idp2=min(time_after_stim2_temp2);
    
    time_for_Oz=time_before_stim2_idp:time_after_stim2_idp2;
    time_for_Fz=time_before_stim2_idp:time_after_stim2_idp1;
    time_for_Cz=time_for_Fz;

% end the limits only for around stim2

     figure(2);plot(timeVec_msec, CZ);title(CZ_name); legend([conditions, ]); hold on; 
%     figure(3);plot(timeVec_msec, CP3);title(CP3_name); legend([conditions, ]); hold on; 
%    hOz=figure(2);plot(timeVec_msec(time_for_Oz), Oz(time_for_Oz));title(Oz_name); legend([conditions, ]); 
%     
%   hold on;    
    %figure(5);plot(timeVec_msec, C2);title(C2_name); legend([conditions, ]); hold on;  
    figure(3);plot(timeVec_msec, FZ);title(FZ_name); legend([conditions, ]); hold on; 
    figure(4);plot(timeVec_msec, OZ);title(OZ_name); legend([conditions, ]); hold on; 
%     figure(8);plot(timeVec_msec, AFZ);title(AFZ_name); legend([conditions, ]); hold on; 
%     figure(9);plot(timeVec_msec, AF3);title(AF3_name); legend([conditions, ]); hold on; 
%     figure(10);plot(timeVec_msec, AF4);title(AF4_name); legend([conditions, ]); hold on; 
end


cd '/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/'
cd FiguresGA
%save meanEEGdata meanEEGdata

for mm=2:4,
    temp_save_name_fig=[names_chan{mm-1} '_Adult_GA_3_chans_all_time_filt'];
saveas(mm, temp_save_name_fig, 'png')
saveas(mm, temp_save_name_fig, 'fig')
end 
%             

% Now plot combined AX+AY, BX+BY
dataAXAY=cat(3, GA_EEGdata_AX, GA_EEGdata_AY);
dataBXBY=cat(3, GA_EEGdata_BX, GA_EEGdata_BY);
% TODO Sum together As and Bs DONE
meandataAXAY=mean(dataAXAY,3);
meandataBXBY=mean(dataBXBY,3);

% 
% P03_As=meandataAXAY(26,:);
% P03_Bs=meandataBXBY(26,:);
% 
% C1_Bs=meandataBXBY(12,:);
% C1_As=meandataAXAY(12,:);
% 
% P04_As=meandataAXAY(63,:);
% P04_Bs=meandataBXBY(63,:);
% 
% C2_As=meandataAXAY(49,:);
% C2_Bs=meandataBXBY(49,:);
% 
% Oz_As=meandataAXAY(29,:);
% Oz_Bs=meandataBXBY(29,:);
% 
% 
% C1_Bs=meandataBXBY(12,:);
% C1_As=meandataAXAY(12,:);
% 
% CP3_As=meandataAXAY(18,:);
% CP3_Bs=meandataBXBY(18,:);
% 
% C2_As=meandataAXAY(49,:);
% C2_Bs=meandataBXBY(49,:);

OZ_As=meandataAXAY(1,:);
OZ_Bs=meandataBXBY(1,:);

CZ_As=meandataAXAY(3,:);
CZ_Bs=meandataBXBY(3,:);

FZ_As=meandataAXAY(2,:);
FZ_Bs=meandataBXBY(2,:);

% AFZ_As=meandataAXAY(37,:);
% AFZ_Bs=meandataBXBY(37,:);
% 
% AF3_As=meandataAXAY(3,:);
% AF3_Bs=meandataBXBY(3,:);
% 
% AF4_As=meandataAXAY(36,:);
% AF4_Bs=meandataBXBY(36,:);
% 
% Cz_As=meandataAXAY(48,:);
% Cz_Bs=meandataBXBY(48,:);

Comb_conditions={'As', 'Bs'};

H1=figure(15);
%filt_data=moving_average(FZ_As, 5);
plot(timeVec_msec, FZ_As, timeVec_msec, FZ_Bs);title(FZ_name); legend('As','Bs'); 
SP=3000; line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
temp_save_name_fig=[FZ_name '_' Comb_conditions{1} '_Adult_GA_3_chans_filt'];
saveas(15, temp_save_name_fig, 'fig')
saveas(15, temp_save_name_fig, 'png')
clear temp_save_name_fig



% H1=figure(16);
% plot(timeVec_msec, FCZ_As, timeVec_msec, FCZ_Bs);title(FCZ_name); legend('As','Bs'); 
% SP=3000; line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
% temp_save_name_fig=[FCZ_name '_' Comb_conditions{1} '_Adult_GA_all_chans'];
% saveas(16, temp_save_name_fig, 'fig')
% saveas(16, temp_save_name_fig, 'png')
% clear temp_save_name_fig

% temp_save_name_fig=[C1_name '_' Comb_conditions{2} '_Adult_GA_all_chans'];
% H2=figure(17);
% plot(timeVec_msec, C1_As,timeVec_msec, C1_Bs);title(C1_name); legend('As', 'Bs');
% line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
% saveas(H2, temp_save_name_fig, 'fig')
% saveas(16, temp_save_name_fig, 'png')
% clear temp_save_name_fig
% 
% temp_save_name_fig=[C1_name '_' Comb_conditions{2} '_Adult_GA_all_chans'];
% H2=figure(17);
% plot(timeVec_msec, C1_As,timeVec_msec, C1_Bs);title(C1_name); legend('As', 'Bs');
% line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
% saveas(H2, temp_save_name_fig, 'fig')
% saveas(16, temp_save_name_fig, 'png')
% clear temp_save_name_fig

temp_save_name_fig=[CZ_name '_' Comb_conditions{2} '_Adult_GA_3_chans_filt'];
H2=figure(23);
plot(timeVec_msec, CZ_As,timeVec_msec, CZ_Bs);title(CZ_name); legend('As', 'Bs');
line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
saveas(H2, temp_save_name_fig, 'fig')
saveas(23, temp_save_name_fig, 'png')
clear temp_save_name_fig

% temp_save_name_fig=[C1_name '_' Comb_conditions{2} '_Adult_GA_all_chans'];
% H2=figure(20);
% plot(timeVec_msec, C1_As,timeVec_msec, C1_Bs);title(C1_name); legend('As', 'Bs');
% line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
% saveas(H2, temp_save_name_fig, 'fig')
% saveas(16, temp_save_name_fig, 'png')
% clear temp_save_name_fig
% 
% temp_save_name_fig=[C2_name '_' Comb_conditions{2} '_Adult_GA_all_chans'];
% H2=figure(21);
% plot(timeVec_msec, C2_As,timeVec_msec, C2_Bs);title(C2_name); legend('As', 'Bs');
% line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
% saveas(H2, temp_save_name_fig, 'fig')
% saveas(16, temp_save_name_fig, 'png')
% clear temp_save_name_fig

temp_save_name_fig=[OZ_name '_' Comb_conditions{2} '_Adult_GA_3_chans_filt'];
H2=figure(21);
plot(timeVec_msec, OZ_As,timeVec_msec, OZ_Bs);title(OZ_name); legend('As', 'Bs');
line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
saveas(H2, temp_save_name_fig, 'fig')
saveas(21, temp_save_name_fig, 'png')
clear temp_save_name_fig
%%
%end % Folders - Subjects

save meandataAXAY3_ch meandataAXAY
save meandataBXBY3_ch meandataBXBY
save meanEEGdata3_ch meanEEGdata
save dataGA_AX dataGA_AX
save dataGA_AY dataGA_AY
save dataGA_BX dataGA_BX
save dataGA_BY dataGA_BY
save timeVector_msec timeVector_msec
