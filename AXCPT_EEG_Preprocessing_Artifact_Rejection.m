%% AXCPT_EEG_Preprocessing_Artifact_Rejection
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
listing_raw=dir('Subject*');
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
 
end
% test22=temp22(1,1)
clear kk listing_raw
%% 
for kk=9%:Num_folders
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

    % For Eye artifact rejection, load the FP1,:2,:z channel
    Fp1=squeeze(EEG.data(1,:,:));
    Fp2=squeeze(EEG.data(34,:,:));
    Fpz=squeeze(EEG.data(33,:,:));
    Frontal=cat(2, Fp1,Fp2,Fpz); 
    
     % % Make the mean of frontals
    % mFrontal=mean(Frontal, 2);
    % figure; plot(mFrontal);
    % 
    % figure; plot(Fp1(4000:12000));
    % % Divide in two parts and find the two maxs

    % For muscle artifacts, good channels to check are: FT7(8), T8(52), FT8(43), 
    %       T7(15); And threshold 35-40 microVolts
    FT7=squeeze(EEG.data(8,:,:));
    T8=squeeze(EEG.data(52,:,:));
    T7=squeeze(EEG.data(15,:,:));
    FT8=squeeze(EEG.data(48,:,:));
    C1=squeeze(EEG.data(12,:,:));
    T8_all=(T8+FT8)/2;
    
    % Define number of channels,ntime points, and ntrials
    nchan=size(EEG.data, 1);
    ntrials=size(EEG.data, 3);
    ntime=size(EEG.data, 2);

    %% Define two areas of interest in time
    % 0 - 500 msec -> find the indexes (datapoints)
    % 3000 - 3500 msec -> # #

    %Define the time vector for the plots
    fs=EEG.srate;
    time_start=500; % time before the stimulus (no need for negative sign), ms
    time_end=6500; % time after the stimulus, in ms
    data_pre_trigger=floor(time_start*fs/1000);
    data_post_trigger=floor(time_end*fs/1000);
    timeVec=(-(data_pre_trigger):(data_post_trigger));
    timeVec_msec=timeVec.*(1000/fs);
    msec_to_dp=fs/1000;
    
    % TimeVec TODO substract 1 it is 3585 and not 3584
    time_minus500_idp=find(timeVec_msec-500);
    time_zero_idp=find(timeVec_msec==0); % 0 
    time_after_zero_temp=find(timeVec_msec<500);% 500
    time_after_zero_idp=max(time_after_zero_temp);
    time_before_stim2_temp=find(timeVec_msec>2800);% 2800
    time_before_stim2_idp=min(time_before_stim2_temp);
    time_after_stim2_idp=find(timeVec_msec==3500);% 3500


    time1_index=time_zero_idp:time_after_zero_idp;
    time2_index=time_before_stim2_idp:time_after_stim2_idp;
    % Time for muscle artifact detection
    time3_index=time_zero_idp:time_after_stim2_idp;
    
    % Use the 75 microvolt limit 
    % Check the Fp1 amplitude if it exceeds 75 microseconds.
    threshold = 75;
    noisy=[];
    % Decide which to use and double their precision
    % For the eye artifact 
    Fp1=double(Fp2);
    % For the Muscle artifact
    T8=double(C1);
        for jj=1:ntrials
            temp_trial=Fp1(:,jj);
            temp_trial_time1=temp_trial(time1_index, 1);
            temp_trial_time2=temp_trial(time2_index, 1);
            
            [pks1,locs1,w1,p1] = findpeaks(temp_trial_time1,fs, 'MinPeakProminence', threshold, 'MinPeakDistance', 0.200 ); 
            [pks2,locs2,w2,p2] = findpeaks(temp_trial_time2,fs, 'MinPeakProminence', threshold, 'MinPeakDistance', 0.200 ); 
            
            % Get the muscle artifact now, use the T8 electrode
            % TODO write a function to calculate the individual threshold
            % for muscle artifact
%            single_trial_numbers=[31, 72, 91, 114, 115, 121, 149, 211, 168, 228, 234, 250, 288, 295, 251:274];
 %           for kkk=1:length(single_trial_numbers)
 %               jj=single_trial_numbers(kkk);
            temp_trial_muscle=T8(time3_index, jj);
            temp_trial_muscle_diff=abs(diff(temp_trial_muscle));
            find_Gt_50=find(temp_trial_muscle_diff(:,1)>50);
            %disp(length(find_Gt_50))
      %      figure; plot(temp_trial_muscle_diff)
      %      find_muscle(jj,:)=length(find_Gt_50);
   %         end
            % This function returns the widths of the peaks as the vector w 
            % and the prominences of the peaks as the vector p.
            if (length(pks1)>0 | length(pks2)>0) | length(find_Gt_50)>0,
                noisy=[noisy, jj];
                Noisy_subj(kk).noisy=noisy;
            end
        end % End trials
        
        % Save as Noisy 
        cd(Analyzed_path_folder)
        cd('Triggers')
        save('Noisy.txt', 'noisy','-ascii' )
%         %% Remove those noisy trials 
%         goodvector=[];
%         for mm=1:ntrials,
%             if ismember(mm, noisy)==1,
%                % do nothing
%             else
%                 goodvector=[goodvector, mm];
%             end
%         end
%         
%         initial_data=EEG.data;
%         clean_data(kk).data=initial_data(:,:, goodvector);
%         
%          % Save the EEG structure 
%     temp_savename=[Name_to_load(1:end-4) '_clean'];    
%     EEG = pop_saveset( EEG, 'filename', temp_savename,'filepath', Analyzed_path_folder);
%     EEG.data=initial_data(:,:, goodvector);
% 
%     EEG = pop_saveset( EEG, 'filename', temp_savename,'filepath', Analyzed_path_folder);
%     EEG = eeg_checkset( EEG );
%     eeglab redraw
%     clear initial data temp_savename Name_to_load Analyzed_path_folder Raw_path_folder
end
        
% % Finding the threshold for muscle artifact rejection
% % Define list of noisy with muscle artifacts
% tic
% chan_index=1:6:64;
% for kkj=1:length(chan_index)
%     kk=chan_index(kkj)
%     data_channel=double(squeeze(EEG.data(kk, :,:)));%Fp1;
%     single_trial_numbers=[31, 72, 91, 114, 115, 121, 149, 211, 168, 228, 234, 250, 288, 295, 251:274];
%     [ powerHF_all, meanPowerHF, minPowerHF ] = define_threshold_muscle(data_channel, single_trial_numbers, fs, time3_index );
%     threshold_muscle(kkj,:)=minPowerHF;
%     clear minPowerHF powerHF_all meanPowerHF data_channel
% end
% toc

