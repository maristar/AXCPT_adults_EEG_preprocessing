%% Plotting the overplot of the P07 channel from the 
% MariaLo_AX_Pa saved variables. 

%% Path information
Raw_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/AXCPT/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 
Analyzed_Path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/';
% '/Volumes/MY PASSPORT/EEG/RVS/Analyzed_datasets/'
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/';

cd(Analyzed_Path)
% Define list of Folders - Subjects  
Name_subject_folder='Subject_101*'
listing_raw=dir(Name_subject_folder);
Num_folders=length(listing_raw);
for kk=1:Num_folders
    temp22{kk,:}=listing_raw(kk).name;
end
clear listing_raw

conditions={'AX','AY','BX','BY'};
for jjk=1:length(temp22) % For every subject - folder
    for kk=1:length(conditions)
        temp_condition=conditions(kk);
        temp_condition_char=char(temp_condition);

        % Define folder name for Analyzed and Raw for each subject 
        Folder_name=temp22{jjk,:};
        Analyzed_path_folder=[Analyzed_Path temp22{jjk,:} '/'];
        Raw_path_folder=[Raw_Path temp22{jjk,:} '/'];

        % Go the Analyzed_path_folder for each subject
        % and search for the set files for each AX, AY condition
        cd(Analyzed_path_folder)
        Search_for_folder=[Name_subject_folder 'autotriggers*set']
        listing_sets=dir(Search_for_folder);
        Num_setfiles=length(listing_sets);
        for mm=1:Num_setfiles
            temp_sets{mm,:}=listing_sets(mm).name;
        end
        clear listing_sets

        % temp_sets{kk}(1:48)
        name1=temp_sets{kk,:}(1:48);%'Subject_103_25_512_ch_DC_epochs_tr2_autotriggers'; %AX.txt;
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
            elseif strcmp(temp_condition, 'AY')==1 
                  dataAY=EEG.data;
            elseif strcmp(temp_condition, 'BX')==1
                      dataBX=EEG.data;
            elseif strcmp(temp_condition, 'BY')==1 
                dataBY=EEG.data;
              end
             
            
            %EEGdata=data.(name_data); %numchan x timepoints x numtrials
            meanEEGdata=mean(data,3);
            
            % Interesting Electrodes
            P9=meanEEGdata(24,:);
            P07=meanEEGdata(25,:);
            P03=meanEEGdata(26,:);
            O1=meanEEGdata(27,:);
            C1=meanEEGdata(12,:);
            C3=meanEEGdata(13,:);
            P10=meanEEGdata(61,:);
            P08=meanEEGdata(62,:);
            P04=meanEEGdata(63,:);
            O2=meanEEGdata(64,:);
            C2=meanEEGdata(49,:);
            C4=meanEEGdata(50,:);
            Oz=meanEEGdata(29,:);
            EOG=meanEEGdata(65,:);
            % And their names
            P9_name=EEG.chanlocs(24).labels;
            P07_name=EEG.chanlocs(25).labels;
            P03_name=EEG.chanlocs(26).labels;
            O1_name=EEG.chanlocs(27).labels;
            C1_name=EEG.chanlocs(12).labels;
            C3_name=EEG.chanlocs(13).labels;
            P10_name=EEG.chanlocs(61).labels;
            P08_name=EEG.chanlocs(62).labels;
            P04_name=EEG.chanlocs(63).labels;
            O2_name=EEG.chanlocs(64).labels;
           C2_name=EEG.chanlocs(49).labels;
           C4_name=EEG.chanlocs(50).labels;
            Oz_name=EEG.chanlocs(29).labels;
            EOG_name='EOG';
            % Make timevector and Plot
            Fs=EEG.srate;
            pre_trigger = -EEG.xmin*1000; %msec  200 700
            post_trigger = EEG.xmax*1000; %msec 1100 1600
            data_pre_trigger = floor(pre_trigger*Fs/1000);
            data_post_trigger = floor(post_trigger*Fs/1000);
            timeVec = (-(data_pre_trigger):(data_post_trigger));
            timeVec = timeVec';
            timeVec_msec = timeVec.*(1000/Fs);
            
            names_chan={'P9' 'P07' 'P03' 'O1' 'C1' 'C3' 'P10' 'P08' 'P04' '02' 'C2' 'C4' 'Oz' 'EOG'};
            
            figure(2);plot(timeVec_msec, P9);title(P9_name); legend([conditions, ]); hold on; 
            figure(3);plot(timeVec_msec, P07);title(P07_name); legend([conditions, ]); hold on; 
            figure(4);plot(timeVec_msec, P03);title(P03_name); legend([conditions, ]); hold on; 
            figure(5);plot(timeVec_msec, O1);title(O1_name); legend([conditions, ]); hold on; 
            figure(6);plot(timeVec_msec, C1);title(C1_name); legend([conditions, ]); hold on; 
            figure(7);plot(timeVec_msec, C3);title(C3_name); legend([conditions, ]); hold on; 
            figure(8);plot(timeVec_msec, P10);title(P10_name); legend([conditions, ]); hold on; 
            figure(9);plot(timeVec_msec, P08);title(P08_name); legend([conditions, ]); hold on; 
            figure(10);plot(timeVec_msec, P04);title(P04_name); legend([conditions, ]); hold on; 
            figure(11);plot(timeVec_msec, O2);title(O2_name); legend([conditions, ]); hold on; 
            figure(12);plot(timeVec_msec, C2);title(C2_name); legend([conditions, ]); hold on; 
            figure(13);plot(timeVec_msec, C4);title(C4_name); legend([conditions, ]); hold on; 
            figure(14); plot(timeVec_msec, Oz);title(Oz_name); legend([conditions, ]); hold on; 
            figure(15);plot(timeVec_msec, EOG);title(EOG_name); legend([conditions, ]); hold on; 
            end
    end% conditions
            
            cd Figures
            for mm=2:15,
            saveas(mm, names_chan{mm-1}, 'png')
            saveas(mm, names_chan{mm-1}, 'fig')
            end 
            % Now plot combined AX+AY, BX+BY
            dataAXAY=cat(3, dataAX, dataAY);
            dataBXBY=cat(3, dataBX, dataBY);
            % TODO Sum together As and Bs DONE
            meandataAXAY=mean(dataAXAY,3);
            meandataBXBY=mean(dataBXBY,3);
            
                       
            P03_As=meandataAXAY(26,:);
            P03_Bs=meandataBXBY(26,:);

            C1_Bs=meandataBXBY(12,:);
            C1_As=meandataAXAY(12,:);
            Comb_conditions={'As', 'Bs'};
            %figure(16);plot(timeVec_msec, P03_As, timeVec_msec, P03_Bs);title(P03_name); legend('As','Bs'); 
            %figure(17);plot(timeVec_msec, C1_As,timeVec_msec, C1_Bs);title(C1_name); legend('As', 'Bs');
            
            % CHECK TODO
            H1=figure(16);plot(timeVec_msec, P03_As, timeVec_msec, P03_Bs);title(P03_name); legend('As','Bs');
            SP=3000; line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
            temp_save_name_fig=[P03_name '_' Comb_conditions{1} '_' Comb_conditions{2}];
            
            saveas(16, temp_save_name_fig, 'fig')
            saveas(16, temp_save_name_fig, 'png')
            clear temp_save_name_fig
            
            temp_save_name_fig=[C1_name '_' Comb_conditions{1} '_' Comb_conditions{2}];
            H2=figure(17);plot(timeVec_msec, C1_As,timeVec_msec, C1_Bs);title(C1_name); legend('As', 'Bs');
            line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
            saveas(H2, temp_save_name_fig, 'fig')
            saveas(H2, temp_save_name_fig, 'png')
            clear temp_save_name_fig
            
end % Folders - Subjects


