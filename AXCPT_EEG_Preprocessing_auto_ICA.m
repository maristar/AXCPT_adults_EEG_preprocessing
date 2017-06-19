%% Path information
Raw_Path='/Volumes/EEG2_MARIA/EEG/AXCPT/Raw_datasets/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
Analyzed_path='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/';
% '/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/';


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
for kk=3:Num_folders
    eeglab
    Folder_name=temp22{kk,:};
    Analyzed_path_folder=[Analyzed_path temp22{kk,:} '/'];
    Raw_path_folder=[Raw_Path temp22{kk,:} '/'];
    cd(Analyzed_path_folder)
    cd(Analyzed_path_folder)
    Name_to_load=[Folder_name '_512_ch_DC_epochs_tr2_auto_all_channels.set']
    EEG = pop_loadset('filename',Name_to_load,'filepath',Analyzed_path_folder);
    EEG = eeg_checkset( EEG );
    eeglab redraw
%     %% Remove extra channels
%     EEG = pop_select( EEG,'nochannel',{'EXG3' 'EXG4' 'GSR1' 'GSR2' 'Erg1' 'Erg2' 'Resp' 'Plet' 'Temp'});
%     EEG = eeg_checkset( EEG );
%     eeglab redraw
%     
%      %% Save the EEG structure 
%     %temp_epochname=[temp22{kk,:}; '_' num2str(fs_new)  '_ch_DC_epochs_tr2_auto_all_channels' ];
%     EEG = pop_saveset( EEG, 'filename',Name_to_load,'filepath', Analyzed_path_folder);
%     
% end

%     %% Add channel locations 
%     EEG=pop_chanedit(EEG, 'lookup','/Users/mstavrin/Documents/MATLAB/EEGLAB_WORKSHOP_SML/eeglab_sml_v3/eeglab_sml_v3/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     EEG = eeg_checkset( EEG );
%     eeglab redraw
    
    %% Run Runica
     %pop_editoptions( 'option_storedisk', 1, 'option_savetwofiles', 0, 'option_saveversion6', 0, 'option_single', 0, 'option_memmapdata', 0, 'option_eegobject', 0, 'option_computeica', 1, 'option_scaleicarms', 1, 'option_rememberfolder', 1, 'option_donotusetoolboxes', 0, 'option_checkversion', 0, 'option_chat', 0, 'option_cachesize', 49,00 );
      EEG = eeg_checkset( EEG );
      eeglab redraw
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    eeglab redraw
    %% Save the EEG structure with the ICA
    %temp_epochname=[temp22{kk,:}; '_' num2str(fs_new)  '_ch_DC_epochs_tr2_auto_all_channels' ];
    EEG = pop_saveset( EEG, 'filename',Name_to_load,'filepath', Analyzed_path_folder);
    
 end
% 
% 
% pop_chanedit(readlocs('biosemi_eloc.txt', 'format', { 'labels' 'sph_theta_besa' 'sph_phi_besa' }, 'skiplines', 1))