%% Data analysis using wavelets,
% for github, 28 11 2014
% Make sample M-channel signal, here we have 3 channels
% Maria L. Stavrinou 
tic

%Raw_Path='/Volumes/MY PASSPORT/EEG/RVS/RAW_datasets/'%RVS_Subject104/Base/';
Raw_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
%Analyzed_path='/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
Analyzed_path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/FiguresGA/dataAX_aY_etc/';
Datasaved_path ='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/DataMat/All_channels_AX_AY_for_wavelets/';
cd(Datasaved_path)
Analyzed_Path=Analyzed_path;

Fs=512;
dt=1/Fs;

listing_raw=dir('dataGA*mat');
Num_data=length(listing_raw);
for kk=1:Num_data;
    temp22{kk,:}=listing_raw(kk).name;
 
end
% test22=temp22(1,1)
clear kk listing_raw

% Load the data 
% for kk=1:Num_data
kk=1
dataGA_X=load(temp22{kk,:})
%load('BaseGA.mat')
dataGA_X=dataGA_X.dataGA_AX;

Mean_Base_Ch=mean(dataGA_X,3);
MeanBase=mean(dataGA_X, 3);
clear dataGA

% % Load Test
% load('TestGA.mat')
% dataGA_Test=dataGA;
% Mean_Test_Ch=mean(dataGA_Test,3);
% MeanTest=mean(dataGA,3);
% clear dataGA

% Define necessities 
[nchan ntime]=size(MeanBase);
Fs=512;
pre_trigger = 500; %msec  200 700
post_trigger = 6500; %msec 1100 1600
data_pre_trigger = floor(pre_trigger*Fs/1000);
data_post_trigger = floor(post_trigger*Fs/1000);
timeVec = (-(data_pre_trigger):(data_post_trigger-1));
timeVec = timeVec';
timeVec_msec = timeVec.*(1000/Fs);
% old mistaken? names_chan={'Iz', 'Oz', 'POZ', 'Pz', 'CPZ', 'FPZ', 'FCZ', 'CZ', 'AFZ', 'FZ'}
names_chan={ 'Oz', 'Fz', 'Cz'};
sessions={'AX'};

for kkj=1:1
    current_session=sessions{kkj};
    
%     switch kkj 
%         case 1 % Base
%             data_all=dataGA_Base;
%             name='probe'
%         case 2
%             data_all=dataGA_Test;
%             name='TestGA'
%     end
    %data_all=data; 
    %data_all= zeros(ntimepoints, nchan, ntrig);
        data=dataGA_X;
%     ndata=1;
%     collect_chans_L=data_all;
%     data=data_all;
    % The general form  of the input data will be [ntimepoints x nchan x ntrig]
    [nchan ntimepoints ntrig]=size(dataGA_X);
    % General form of timevector 
%     timeVec=(1:length(data)).*1/Fs;
%     %timeVec=t;
ndata=1
%% Analysis starts:

    %% analysis characteristics %%%%
    freqN = input('frequency to start?        ');
    repeats = input('For how many times -subsequent frequency bands?   ');
    tic
    %% Define frequencies
    for q = 1:repeats
        freq1=freqN;
        freqN=freq1+30;  
        step=1;
        freqVec =freq1:step:freqN; % 2:0.05:16
        disp(freq1)
        disp(freqN)
        width=7;
        for k=1:ndata;
            TFR_array=zeros(length(freqVec), length(timeVec), nchan);
            RHO=0;
            for n=1:nchan  %start for every source - channel
            % Lets select the single trials and detrend them
                collect_sts=zeros(ntimepoints, ntrig-1);   
                collect_sts=data(n,:,:);
                collect_sts=squeeze(collect_sts);
                collect_sts=collect_sts'; % ntrig x ntimepoints

                for m=1:ntrig,
                    buffer=collect_sts(m, :);
                    buffer2=detrend(buffer(:));
                    collect_sts(m,:)=buffer2;
                    clear buffer buffer2
                end

                B = zeros(length(freqVec), ntimepoints); %% freqVec x timeLength
                PH = zeros(length(freqVec), ntimepoints); %% freqVec x timeLength
                TFR=[]; % empties the variable TFR
                for r=1:ntrig,  % for every single trial     
                    for j=1:length(freqVec)  % for every frequency
                        % TODO why it does not take from the collect_sts(r,:)
                        a=squeeze(data(n,:,r))';
                          enrg= energyvec(freqVec(j), collect_sts(r,:),Fs, width);
                          %PH(j,:)=ph;
                          B(j,:)=enrg +B(j,:);
                          %B(j, :) = (energyvec(freqVec(j), a, Fs, width)) + B(j,:);
                          %clear a
                    end % for every frequency
                    clear j
                    %temp(r,n,:,:)=PH(:,:);
                end % for every trigger
                clear r
                TFR = B/ntrig;  % TFR is mean value of B

                % or minus one 3marzo2004
                TFR_array(:,:,n) = TFR;
            end   % end for every source -channel
            clear n
      %TFR_all:  ndatasets x nfreqs x ntimepoints x nchan
      TFR_all(k,:,:,:)=TFR_array;
        end % for every data
        clear TFR
        x_array=zeros(ndata, length(timeVec));
        recon_array = zeros(length(freqVec), length(timeVec), nchan);
        for d = 1:nchan
            for f = 1:(length(freqVec))
                x_array = TFR_all(:,f,:,d);  % or TFR_all(k,f,:,d)
                mx_array = mean(x_array, 1);
                recon_array(f,:,d) = mx_array;
            end
            clear f
        end
        clear d
        %end % for repeats
    clear q
%% Forming the general name of the dataset 
   %pathname1='C:\Users\Maria\Desktop\1stdatas';
    filename1=temp22{kk,:};
    len_1 = length(filename1); 
    save_name=[filename1 '_ANALYSIS_'];    
    stemp1 = [save_name '_' num2str(freq1) '_' num2str(freqN) '_' 'step' num2str(step) '_' 'recon_array_width' num2str(width) '_22Mai']; 
    stempext = ('.mat'); 
    stemp2 = [stemp1 stempext]; 
    pathname_save=Analyzed_path; % Or any other path 
    cd(pathname_save)%
    mkdir('Wavelet_figures')
    cd Wavelet_figures
    mkdir(stemp1); % 
    cd(stemp1); % 
    eval(['save ' stemp2 ' recon_array freqVec timeVec step filename1 stemp1 ndata nchan names_chan'])
    
    end
    
    %% TODO put here the saving the figures 
      % to test if good to test here
     for kk=1:length(names_chan)
        H=figure;
        set(gca,'FontSize',24)
        Btemp=recon_array(:,:,kk);
        imagesc(timeVec_msec, freqVec, Btemp(:,:,:));colorbar;
        title_name=['AX' '-' names_chan{kk}];
        title(title_name, 'FontSize', 24);
        xlabel('time (msec)', 'FontSize', 24);
        ylabel('frequency (Hz)', 'FontSize', 24);
        v(kk, :, :) = caxis;
        cd(Analyzed_path)
        cd Wavelet_figures
        cd(stemp1)
        names_wave=['AX' '_' names_chan{kk} '_wavelet']
        saveas(H, names_wave, 'png')
        saveas(H, names_wave, 'fig')
        clear Btemp H names_wave
        
        min1=min(v(:,:,1));
        max1=max(v(:,:,2));
        clim(kkj,:,:)=[min1, max1];
     end
  %clim= [0.3773 14.6386];
  clim_min=min(clim(:,:,1));
  clim_max=max(clim(:,:,2));
  clim1=[clim_min clim_max];
  % % Base 3: as POZ (3o channel) [0.3773 14.6386]. Base and test [0.55 25] 
  for kk=1:length(names_chan)
        H=figure;
        set(gca,'FontSize',24)
        Btemp=recon_array(:,:,kk);
        imagesc(timeVec_msec, freqVec, Btemp(:,:,:), clim1); 
        colorbar;
        title_name=['AX' '-' names_chan{kk}];
        title(title_name, 'FontSize', 24);
        xlabel('time (msec)', 'FontSize', 24);
        ylabel('frequency (Hz)', 'FontSize', 24);
        set(gca, 'FontName', 'TimesNewRoman', 'FontSize', 18); % axis ticks
        cd(Analyzed_path)
        cd Wavelet_figures
        cd(stemp1)
        names_wave=['AX' names_chan{kk} '_wavelet_norm'];
        saveas(H, names_wave, 'png')
        saveas(H, names_wave, 'fig')
        clear Btemp H names_wave
          end
end % for sessions
    %% to test if good to put here


toc  
%     %% Visualize results
%     figure;
%     for kk=1:nchan,
%         subplot(nchan, 1, kk);
%         Btemp=recon_array(:,:,kk);
%         imagesc(timeVec, freqVec, Btemp);
%         xlabel('time (sec)');
%         ylabel('frequency (Hz)');
%         clear Btemp
%     end
    
%       
%     
%         for kk=1:nchan,
%         figure;
%         set(gca,'FontSize',24)
%         Btemp=recon_array(:,:,kk);
%         imagesc(timeVec, freqVec, Btemp);
%         title(names_chan{kk}, 'FontSize', 24);
%         xlabel('time (sec)', 'FontSize', 24);
%         ylabel('frequency (Hz)', 'FontSize', 24);
% %         cd Analyzed_path
% %         cd figures
%         cd '/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/figures/TestGA_ANALYSIS__6_26_step0.2_recon_array_width6/'
%         names_wave=['Base_' names_chan{kk} '_wavelet']
%         saveas(kk, names_wave, 'png')
%         saveas(kk, names_wave, 'fig')
%         clear Btemp
%     end
%     % xlabel('time (ms)', 'FontSize', 24);
%     % channel 5 is F3, and i see beta. 
%     Btemp=recon_array(15:end,100:end,5);
%     figure; imagesc(timeVec(200:end), freqVec(15:end), Btemp)
%     clear kk
%     cd(pathname_save)
% 
%     %%if we had multiple repeats and datasets here would be the end of
%     %%%the first loop
%   
% 
% 
