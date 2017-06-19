[filtered_data] = moving_average(data, n_mov_av);
wing=floor(n_mov_av/2);

for kk=1:Num_subjects
    % Load each subject's raw data.
    raw_data=data;
    
    num_chan=size(raw_data,2);
    timepoints=size(raw_data,1);
    
    % Filtered_data initialization.
    filtered_data=zeros(timepoints-wing, num_chan);
    
    % Load each channel.
    for nn=1:num_chan
        % Take a channel
        chan_temp=raw_data(:,nn);
        
        temp=zeros(timepoints-(n_mov_av-1), 1);
        
        for jj=(wing+1):(timepoints-wing)
            for jjk=-wing:wing
                temp(jj)=0;
                temp(jj)=temp(jj) + chan_temp(jj+jjk);
            end
            temp(jj)=temp(jj)/n_mov_av;
        end
        
        filtered_data(:,nn)=temp;
        %figure; plot(chan_temp(1:500), 'r');hold on; plot(temp(1:500), 'b');
    end
end
    