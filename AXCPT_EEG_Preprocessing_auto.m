% Makes the 4-5 preprocesing steps automatically.
% 18_2_2016 
% Now it is just for subj 19 (Hugues, so to change that) 4.5.2016
% 18_5_2016
clear all 
close all 

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
%% Instruction: The folder name should be the same and as defined above
 % Lets start the mega loop
for kk=1:Num_folders
    Folder_name=temp22{kk,:};
    cd(Analyzed_path)
    mkdir(temp22{kk,:})
    Analyzed_path_folder=[Analyzed_path temp22{kk,:} '/'];
    Raw_path_folder=[Raw_Path temp22{kk,:} '/'];
    cd(Raw_path_folder);
    listing_rawbdf=dir('*.bdf');
    
    Num_filesbdf=length(listing_rawbdf);
    if Num_filesbdf>1
        display('Warning, 2 data bdfs found')
    end
    Name_Subject_session=Folder_name;
        %% Load the raw dataset 
        
        [ALLEEG EEG CURRENTSET ALLCOM]=eeglab;
        %EEG= pop_biosig(); % '/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/MariaLoizou/Maria1.bdf', 'ref',[65 66] ,'refoptions',{'keepref' 'off'});
        % 'ref',[65 66] ,'refoptions',{'keepref' 'off'});
        Raw_path_folder_data=[Raw_path_folder listing_rawbdf(1).name];
        EEG= pop_biosig(Raw_path_folder_data, 'ref',[65 66] ,'refoptions',{'keepref' 'off'});
        EEG.setname=Name_Subject_session;
        eeglab redraw
        EEG = eeg_checkset( EEG );

%         %% Detect noisy channels
%         hfigure=pop_eegplot( EEG, 1, 1, 1);
%         f=warndlg('Scroll the data and select the noisy channels. Close this window only when you are done to continue', 'A warning dialog');
%         disp('This prints immediately');
%         drawnow
%         waitfor(f);
%         disp('This prints when you finished closing the window');
       % EEG = pop_select( EEG,'nochannel',{'EXG5' 'EXG6' 'EXG7' 'EXG8' 'EXG3' 'EXG4' 'GSR1' 'GSR2' 'Erg1' 'Erg2' 'Resp' 'Plet' 'Temp'});

        %EEG = pop_select( EEG,'nochannel',{'EXG5' 'EXG6' 'EXG7' 'EXG8' 'EXG3' 'EXG4','GSR1','GSR2','Erg1','Erg2','Resp','Plet','Temp','EXG1','EXG2'});
        EEG = pop_select( EEG,'channel',{'Fz' 'Cz' 'Oz'});
        EEG = eeg_checkset( EEG );
        eeglab redraw
        %% TODO to run the DC offset filter -i run it after

        %% Resample
        fs_new=512;
        EEG = pop_resample( EEG, fs_new);
        temp_setname_resample=[Name_Subject_session '_' num2str(fs_new)];
        EEG.setname=temp_setname_resample;
        EEG = eeg_checkset( EEG );
        eeglab redraw
        
        %% Apply DC filter 
        %  Run the DCoffset_removal_21_10_2011_a_final.m made as function
        input_data=EEG.data;
        data_filt=DC_offset_removal(input_data);
        EEG.data=data_filt;
        clear data_filt input_data;
        EEG.setname=[temp_setname_resample '_ch_DC']
        eeglab redraw
        
%         % TODO - Add filtering 0.1 - 100 Hz
%         data_filt_smoot=eegfilt(EEG.data, fs_new, 1, 1);
%         EEG.data=data_filt_smooth;
        % Epoch
        temp_epochname=[Name_Subject_session '_' num2str(fs_new)  '_ch_DC_epochs_tr2_auto_3_channels' ];
        % TODO check if it accepts the temp_epochname below
        EEG = pop_epoch( EEG, {  '2'  }, [2.8 6.5], 'newname', temp_epochname, 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [2800 2850]);
        EEG.setname=temp_epochname;
        eeglab redraw
        %EEG = pop_saveset( EEG, 'filename',temp_epochname,'filepath', Analyzed_path_folder);
        %% TODO to put here artifact removal . 11 May 2016.
%        TODO put electrode locations 
%         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','Subject_03_JacLoe_512_ch_DC_epochs_tr2_auto_all_channels64','savenew','/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/Subject_03_JacLoe/Subject_03_JacLoe_512_ch_DC_epochs_tr2_auto_all_channels64.set','overwrite','on','gui','off'); 
%         %
%         EEG=pop_chanedit(EEG, 'lookup','/Users/mstavrin/Documents/MATLAB/EEGLAB_WORKSHOP_SML/eeglab_sml_v3/eeglab_sml_v3/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
%         [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%         EEG = eeg_checkset( EEG );
%         
         EEG = pop_saveset( EEG, 'filename',temp_epochname,'filepath', Analyzed_path_folder);

end
    