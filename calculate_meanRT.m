function [ collect_RTs] = calculate_meanRT( StimTwoRT, Condition,  temp_condition )
%%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here 
%   calculates the error rate for the proactive-reactive ratio
%   Based on description by Chiew and Bravers, 2014, page 7, top.
%   Maria L. Stavrinou Fontenelle, 2016.


 %% Define the number of trials 
    Num_triggers=size(StimTwoRT); 
    Num_triggers=Num_triggers(1);
    
        collect_RTs=[]; 
        count=0;
        for kkt=1:Num_triggers, 
            if strcmp(Condition(kkt,1),temp_condition)==1; 
                count=count+1;
                temp=cellstr(StimTwoRT(kkt,1));
                temp2=str2num(temp{:});
                collect_RTs(count,:)=temp2;
                clear temp2 temp
            end;
        end
        
        % Define the number of those epochs in that condition
        Num_condition=count;
end


