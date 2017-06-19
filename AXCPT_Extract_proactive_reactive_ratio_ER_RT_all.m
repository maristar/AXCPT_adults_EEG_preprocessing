% Analyzing EEG dataset for RVS - Base - Test data. 
% 30 November 2015, Maria L. Stavrinou at PSI, UiO
% 14 January 2016, MLS
% 25 May 2016 for AXCPT, Maria L. Stavrinou
clear all 
close all 

Analyzed_path='/Volumes/EEG2_MARIA/EEG/AXCPT/Analyzed_datasets/';
Raw_path='/Volumes/EEG2_MARIA/EEG/AXCPT/Raw_datasets/';
%'/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/RAW_datasets/'; 

cd(Raw_path)
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
    % Define on which subject we are working
    Subject_filename=temp22{kk,:}; 
    
    %Analyzed_path='/Users/mstavrin/Documents/A_SettingEEG_lab/A_RECORDINGS/Analyzed_datasets/AXCPT/';
    Analyzed_path_folder=[Analyzed_path Subject_filename '/'];
    Raw_path_folder=[Raw_path Subject_filename '/'];
 
    % Load the exported edat2 file (later named Tfinal).
    cd(Raw_path_folder)
    listing_raw2=dir('*matlab.txt');
    Edat2file=listing_raw2(1).name;
    FileName=Edat2file;

    T = readtable((FileName),...
    'Delimiter','\t','ReadVariableNames',false);
    clear Filename
    
    % Find which row in the T table is Condition, and the StimTwoACC.
    % Find it iteratively:
    all_headers=T(1,:);
    all_headers2=table2cell(all_headers);
    
    % Find for the Condition
    for jjj=1:length(all_headers2)
        a=strcmp(all_headers2{1,jjj}, 'Condition');
        if a==1
            indexCondition=jjj;
        end
    end
    clear a jjj 
    
    % Find for the StimTwo.ACC
    for jjj=1:length(all_headers2)
        a=strcmp(all_headers2{1,jjj}, 'StimTwo.ACC');
        if a==1
            indexStimTwoACC=jjj;
        end
    end
     clear a jjj 
        
    StimTwoACC_table=T(2:end, indexStimTwoACC); % 131 for JackLoe, tested first!
    StimTwoACC=table2cell(StimTwoACC_table);
     
         % Find for the StimTwo.RT
    for jjj=1:length(all_headers2)
        a=strcmp(all_headers2{1,jjj}, 'StimTwo.RT');
        if a==1
            indexStimTwoRT=jjj;
        end
    end
     clear a jjj 

    StimTwoRT_table=T(2:end, indexStimTwoRT);
    StimTwoRT=table2cell(StimTwoRT_table);
    
    %% Define the 4 conditions
    conditions={'AX','AY','BX','BY'};
    
    % Load the Condition for every stimulus AX; AY; BX; BY
    Condition_table=T(2:end, indexCondition);
    Condition=table2cell(Condition_table);
    clear Condition_table StimTwoRT_table StimTwoACC_table
   %% Start!!
    for jj=1:length(conditions)
        temp_condition=conditions(jj); % For example, AX
        temp_condition_char=char(temp_condition);
        % Calculate the error (1-ccuracy) for each condition 
        [ count, Num_condition ] = calculate_meanACC( StimTwoACC, Condition,  temp_condition );
        ACC=count;
        MeanACC=(count/Num_condition);
        MeanACC_all.(Subject_filename).(temp_condition_char)=MeanACC;
        ACC_all.(Subject_filename).(temp_condition_char)=ACC;
        
        error_temp=1-(count/Num_condition);
        if error_temp==0
            error_temp=1-((count+0.5)/(Num_condition+1));
        end
        error.(Subject_filename).(temp_condition_char)=error_temp;
        clear MeanACC Num_condition count error_temp
        
        % Calculate the mean RT for each condition.
        % StimTwoRT is a cell and should be transformed to array 
        [ collectRTs] = calculate_meanRT( StimTwoRT, Condition,  temp_condition );
        
        meanRT_temp=median(collectRTs,1);
        RT_all.(Subject_filename).(temp_condition_char)=meanRT_temp;
        clear meanRT_temp 
       end

% Now we calculate the ratio PROA-REA for this subject
condition={'AY'};
a=error.(Subject_filename).AY;
a_RT=RT_all.(Subject_filename).AY;

condition={'BX'};
b=error.(Subject_filename).BX;
b_RT=RT_all.(Subject_filename).BX;

% Ratio from errors
ratioE=(a-b)/(a+b);

% Ratio for RTs
ratioRT=((a_RT)-(b_RT))/((a_RT)+(b_RT));

% Ratio for errors+RTs
a2=a+a_RT;
b2=b+b_RT;

ratio_E_RT=(a2-b2)/(a2+b2);

MeanACC_all.(Subject_filename).PRO_REA_E=ratioE;
RT_all.(Subject_filename).PRO_REA_RT=ratioRT;
RT_all.(Subject_filename).ratio_E_RT=ratio_E_RT;
 clear Subject_filename a a2 a_RT b b2 b_RT ratioRT ratio_E_RT ratioE 
end % for every subject 

% Save the results 
cd(Analyzed_path);
mkdir('Accuracy_results');
cd('Accuracy_results');
save MeanACC_all MeanACC_all;
save error error
save RT_all RT_all
% Display on the screen
for kk=1:Num_folders
    % Define on which subject we are working
    Subject_filename=temp22{kk,:};
    ratioE=MeanACC_all.(Subject_filename).PRO_REA_E;
    ratioRT=RT_all.(Subject_filename).PRO_REA_RT;
    ratio_E_RT=RT_all.(Subject_filename).ratio_E_RT;
    disp([(Subject_filename) ' : ' num2str(ratioE) ', ratioRT: ' num2str(ratioRT) ', ratio ERT: ' num2str(ratio_E_RT)]) 
end
disp('DONE')

% 
% %% 
% [ collectRTsAX] = calculate_meanRT( StimTwoRT, Condition,  'AX' );
% 
% [ collectRTsAY] = calculate_meanRT( StimTwoRT, Condition,  'AY' );
% 
% [ collectRTsBX] = calculate_meanRT( StimTwoRT, Condition,  'BX' );
% 
% [ collectRTsBY] = calculate_meanRT( StimTwoRT, Condition,  'BY');