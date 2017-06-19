% EEGLAB history file generated on the 28-Jan-2016
% ------------------------------------------------

Raw_Path='/Volumes/MY PASSPORT/EEG/RVS/RAW_datasets/'%RVS_Subject104/Base/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
Analyzed_path='/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/';

cd(Raw_Path)
% Define list of folders 
listing_raw=dir('RVS_Subject*');
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
 
end
% test22=temp22(1,1)
clear kk listing_raw
%% 
for kk=9%1:3 %6:Num_folders
    Folder_name=temp22{kk,:};
    Analyzed_path_folder=[Analyzed_path temp22{kk,:} '/'];
    Raw_path_folder=[Raw_Path temp22{kk,:} '/'];
    cd(Raw_path_folder);
    sessions={'Base','Test'};
    for kkj=1:length(sessions)
        current_session=sessions{kkj};
        Raw_path_folder_session=[Raw_path_folder current_session '/'];
        Analyzed_path_folder_session=[Analyzed_path_folder current_session '/']
        Name_Subject_session=[Folder_name '_' sessions{kkj}]
        cd(Analyzed_path_folder_session)
        Name_to_load=[Name_Subject_session '_512_ch_DC_epochs_tr2_auto.set']
        eeglab
        EEG = pop_loadset('filename',Name_to_load,'filepath',Analyzed_path_folder_session);
        EEG = eeg_checkset( EEG );
        eeglab redraw
        % Select condition 
        cd(Raw_path_folder_session)
        cd Triggers
        temp_trials=load('double_both_corr.txt');
        if ~isempty(temp_trials)
            EEG = pop_select( EEG,'trial', temp_trials');
        
            EEG.setname='RVS_Subject105_Base_512_ch_DC_epochs_tr2_auto_double_tr_2_corr';
            EEG = eeg_checkset( EEG );
            eeglab redraw
            EEG = pop_select( EEG,'channel',{'Iz' 'Oz' 'POz' 'Pz' 'CPz' 'Fpz' 'AFz' 'Fz' 'FCz' 'Cz'});
            EEG.setname='RVS_Subject105_Base_512_ch_DC_epochs_tr2_auto_double_tr_2_corr_Z';
            EEG = eeg_checkset( EEG );
            EEG = eeg_checkset( EEG );
            eeglab redraw
            data=EEG.data;
            cd(Analyzed_path_folder_session)
            temp_Namesave=[current_session(1) num2str(Folder_name(12:end)) '.mat'];

            save data data
        else 
            disp('Trigger found empty')
        end
    end

    clear data
end
