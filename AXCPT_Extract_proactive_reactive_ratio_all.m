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
    
    %% Define the 4 conditions
    conditions={'AX','AY','BX','BY'};
    
    % Load the Condition for every stimulus AX; AY; BX; BY
    Condition_table=T(2:end, indexCondition);
    Condition=table2cell(Condition_table);
   
   %% Start!!
       for jj=1:length(conditions)
        temp_condition=conditions(jj); % For example, AX
        temp_condition_char=char(temp_condition);
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
        clear temp_condition temp_condition_char MeanACC Num_condition count error_temp
       end

% Now we calculate the ratio PROA-REA for this subject
condition={'AY'};
a=error.(Subject_filename).AY;
condition={'BX'};
b=error.(Subject_filename).BX;
 
ratio=(a-b)/(a+b);

MeanACC_all.(Subject_filename).PRO_REA=ratio;

 clear Subject_filename
end

% Save the results 
cd(Analyzed_path);
mkdir('Accuracy_results');
cd('Accuracy_results');
save MeanACC_all MeanACC_all;
save error error

% Display on the screen
for kk=1:Num_folders
    % Define on which subject we are working
    Subject_filename=temp22{kk,:};
    ratio=MeanACC_all.(Subject_filename).PRO_REA;
    disp([(Subject_filename) ' : ' num2str(ratio)]) 
end
disp('DONE')