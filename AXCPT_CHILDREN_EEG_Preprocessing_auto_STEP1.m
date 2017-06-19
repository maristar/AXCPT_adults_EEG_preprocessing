% STEP 1 
% Makes the 4-5 preprocesing steps automatically.
% 29_2_2016 For the Children Version
% working on 06.03.2017
% Maria Stavrinou for PSI-UiO
%% Path information
% Raw_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/AXCPT/CHILDREN_TIK/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
% Analyzed_path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/CHILDREN_TIK/';
% '/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/';
% 

clear all
close all 

Raw_Path='Y:\Prosjekt\Tune_Into_Kids_Session1\TIK\AXCPT_TIK\';
Analyzed_path='Y:\Prosjekt\Tune_Into_Kids_Session1\TIK\Analyzed_datasets\';

%% Define list of folders 
cd(Raw_Path)
listing_raw=dir('AXCPT*_TIK*');
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
end
clear kk listing_raw
%% Instruction: The folder name should be the same and as defined above
 % Lets start the mega loop
for kk=1:Num_folders
    Folder_name=temp22{kk,:};
    cd(Analyzed_path)
    mkdir(temp22{kk,:})
    
    Analyzed_path_folder=[Analyzed_path temp22{kk,:}];
    Raw_path_folder=[Raw_Path temp22{kk,:} '/'];
    cd(Raw_path_folder);
   
    % Find the EEG recordings
    listing_rawbdf=dir('*.bdf');

    Num_filesbdf=length(listing_rawbdf);
    if Num_filesbdf>1
        display('Warning, 2 data bdfs found')
    elseif Num_filesbdf==0
        display('No EEG *.bdf file found')
    end
    Name_found=listing_rawbdf.name;
    % Give a name of the subject & session 
    Name_Subject_session=[Folder_name '_S1'];
        %% Load the raw dataset 
        Raw_path_folder_data=[Raw_path_folder listing_rawbdf(1).name];
        EEG= pop_biosig(Raw_path_folder_data, 'ref',[65 66] ,'refoptions',{'keepref' 'on'});
        EEG.urchanlocs(65).label='A1';
        EEG.urchanlocs(66).label='A2';
        EEG.setname=[Name_Subject_session]; % AXCPT1_TIK_2016001001_S1 , S1 session 1
        EEG.filename=temp22{kk,:}; % AXCPT1_TIK_2016001001
        eeglab redraw
        EEG = eeg_checkset( EEG );


        EEG = pop_select( EEG,'nochannel',{'EXG3' 'EXG4' 'EXG5' 'EXG6' 'EXG7' 'EXG8'});
        EEG = eeg_checkset( EEG );
        eeglab redraw
              
        
        %% Apply DC filter 
        %  Run the DCoffset_removal_21_10_2011_a_final.m made as function
        input_data=EEG.data;
        Fs=EEG.srate;
        data_filt=DC_offset_removal(input_data, Fs);
        EEG.data=data_filt;
        clear data_filt input_data;
        % EEG.setname=[temp_setname_resample '_ch_DC']
        eeglab redraw
        
         %% Low pass filter 
        EEG  = pop_basicfilter( EEG,  1:5 , 'Boundary', 'boundary', 'Cutoff', [ 0.0253 45], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2 ); % GUI: 30-Aug-2016 15:34:37
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        
       
        %% Resample
        fs_new=256;
        EEG = pop_resample( EEG, fs_new);
        temp_setname_resample=[Name_Subject_session '_' num2str(fs_new)];
        EEG.setname=temp_setname_resample;
        EEG = eeg_checkset( EEG );
        eeglab redraw
        
        
       %% Epoch 
        temp_epochname=[Name_Subject_session '_' num2str(fs_new)];
        % TODO check if it accepts the temp_epochname below
        EEG = pop_epoch( EEG, {  '20'  }, [-1 5.0], 'newname', temp_epochname, 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-200 0]);
        EEG.setname=temp_epochname;
        EEG.filename=temp22{kk,:};
        EEG = eeg_checkset( EEG );
        eeglab redraw
        
        %% ICA here
        EEG = pop_runica(EEG, 'extended',1,'interupt','on');
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        
        %% Add channels locations 
%        EEG.chanlocs=pop_chanedit(EEG.chanlocs, 'load',{'M:\pc\Dokumenter\MATLAB\eeglab_sml_v3\eeglab_sml_v3\plugins\dipfit2.3\standard_BESA\standard-10-5-cap66biosemi.elp', 'filetype', 'autodetect'});
%           EEG.chanlocs=pop_chanedit(EEG.chanlocs, 'load',{ '/matlab/eeglab/sample_data/eeglab_chan32.locs', 'filetype',  'autodetect'});
%       
% % read the channel location file and edit the channel location information ''
%           EEG = pop_saveset( EEG, 'savemode','resave');
%         EEG = eeg_checkset( EEG );
%         eeglab redraw  
        
        
        %% Save here
        EEG = pop_saveset( EEG, 'savemode','resave');
        EEG = eeg_checkset( EEG );
        %temp_epochname=[name_file 'forICA_ICApruned'];
        %EEG = pop_saveset(EEG, 'filename', temp_epochname);
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        
        
        EEG = pop_saveset( EEG, 'filename',temp_epochname,'filepath', Analyzed_path_folder);
        EEG = eeg_checkset( EEG );
        eeglab redraw
        
end
    