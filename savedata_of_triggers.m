function savedata_of_triggers( Raw_path, Analyzed_path, listing_raw, input_args, Name_to_load )
% savedata_of_triggers, saves .set of dataset in 4 conditions
%   
% Input arguments
%   Raw_path, a string containing the path of the raw data
%   Analyzed_path, a string containing the path of the analysis data
%   listing_raw, a string containing what to look for in the Raw_path,
%           'Subject_*'.
%   text_to_load, a string containing the extension of the set file. For
%   example, 
%   Name_to_load=[Folder_name '_128_ch_DC_epochs_tr2_auto_3_chan_filt.set']
%   thus, text_to_load='_128_ch_DC_epochs_tr2_auto_3_chan_filt.set'
% Output arguments
%   

% EEGLAB history file generated on the 28-Jan-2016
% Maria L Stavrinou working on it 19.2.16 for AXCPT
clear all
close all

% ------------------------------------------------
Raw_Path='/Volumes/EEG2_MARIA/EEG/AXCPT/Raw_datasets/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
Analyzed_path='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/';


% Raw_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/AXCPT/';
% %'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
% Analyzed_path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/';
% % '/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
% %'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/';

cd(Raw_Path)
% Define list of folders 
listing_raw=dir('Subject_*');
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
 
end
% test22=temp22(1,1)
clear kk listing_raw
%% 
for kk=1:Num_folders
    eeglab
    Folder_name=temp22{kk,:};
    Analyzed_path_folder=[Analyzed_path temp22{kk,:} '/'];
    Raw_path_folder=[Raw_Path temp22{kk,:} '/'];
%         cd(Analyzed_path_folder)
%         Name_to_load=[Folder_name '_512_ch_DC_epochs_tr2_auto.set']
%         eeglab
%         EEG = pop_loadset('filename',Name_to_load,'filepath',Analyzed_path_folder);
%         EEG = eeg_checkset( EEG );
%         eeglab redraw
        % Select condition 
        cd(Analyzed_path_folder)
        cd Triggers
        %% Find triggers
        listing_raw=dir('triggers*txt');
        Num_files=length(listing_raw);
        for kkm=1:Num_files
             temp23{kkm,:}=listing_raw(kkm).name;
        end
        clear kkm
        %% End finding triggers
        
        %% Loop to extract each type of trigger's single trials
        for kkj=1:length(temp23);
            % Load the triggers
            trial_type_temp=temp23{kkj};
            temp_trials=load(trial_type_temp);
            if ~isempty(temp_trials)
                % Load the original EEG set that we need  
                cd(Analyzed_path_folder)
                Name_to_load=[Folder_name '_128_ch_DC_epochs_tr2_auto_3_chan_filt.set']
                EEG = pop_loadset('filename',Name_to_load,'filepath',Analyzed_path_folder);
                EEG = eeg_checkset( EEG );
                eeglab redraw
                % End loading the original EEG set that we need
                
                % Start selecting the trials we need
                EEG = pop_select( EEG,'trial', temp_trials');
                temp_setname=[EEG.setname temp23{kkj} '3ch'];
                EEG.setname=temp_setname; %'RVS_Subject105_Base_512_ch_DC_epochs_tr2_auto_double_tr_2_corr';
                EEG = eeg_checkset( EEG );
                eeglab redraw
                
                % Saving the dataset
                Name_to_save=[temp_setname '.set'];
                EEG = pop_saveset( EEG, 'filename',Name_to_save,'filepath',Analyzed_path_folder);
                EEG = eeg_checkset( EEG );
                eeglab redraw
                % Select channels - to be commented
                % EEG = pop_select( EEG,'channel',{'Iz' 'Oz' 'POz' 'Pz' 'CPz' 'Fpz' 'AFz' 'Fz' 'FCz' 'Cz'});
                % EEG.setname='RVS_Subject105_Base_512_ch_DC_epochs_tr2_auto_double_tr_2_corr_Z';
                % EEG = eeg_checkset( EEG );
                % eeglab redraw
                % Save Matlab array for further processing.
                data=EEG.data;
                temp_Namesave=[Folder_name '_' temp23{kkj} '.mat'];
                %save temp_Namesave data
                eval(['save ' temp_Namesave ' data Name_to_save'])
        else 
            disp('Trigger found empty')
        end
        cd(Analyzed_path_folder)
        cd Triggers
    end

    clear data
end


end

