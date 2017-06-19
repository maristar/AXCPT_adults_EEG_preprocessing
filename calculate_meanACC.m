function [ count, Num_condition ] = calculate_meanACC( StimTwoACC, Condition,  temp_condition )
% calculates the error rate for the proactive-reactive ratio
%   Based on description by Chiew and Bravers, 2014, page 7, top.
%   Maria L. Stavrinou Fontenelle, 2016.


 %% Define the number of trials 
    Num_triggers=size(StimTwoACC); Num_triggers=Num_triggers(1);
    
        collect_ACC=[]; count=0;
        for kkt=1:Num_triggers, 
            if strcmp(Condition(kkt,1),temp_condition)==1; 
                collect_ACC=[collect_ACC, StimTwoACC(kkt,1)];
                if strcmp(StimTwoACC(kkt,1), '1')==1;
                    count=count+1;
                end
            end;
        end
        
        % Define the number of those epochs in that condition
        Num_condition=length(collect_ACC);
end

