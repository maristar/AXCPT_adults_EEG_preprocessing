function [ hb,hb2 ] = AXCPT_CHILD_make_plot(chan_number, text_condition, timeVec_msec, meanEEGdataAX, meanEEGdataAY, meanEEGdataBX, meanEEGdataBY, ALLEEG);
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%chan_number=12;
Chan_name=ALLEEG.chanlocs(chan_number).labels;

    C1_AX=meanEEGdataAX(chan_number,:);
    C1_AY=meanEEGdataAY(chan_number,:);
    C1_BX=meanEEGdataBX(chan_number,:);
    C1_BY=meanEEGdataBY(chan_number,:);
    
    C1_As=(meanEEGdataAX(chan_number,:)+meanEEGdataAY(chan_number,:))*0.5;
    C1_Bs=(meanEEGdataBX(chan_number,:)+meanEEGdataBY(chan_number, :))*0.5;
    
    fig1=figure;
    set(gca, 'fontsize', 22);
    hb=plot(timeVec_msec, C1_AX,'r', timeVec_msec, C1_AY, 'm', timeVec_msec, C1_BX,'g',timeVec_msec, C1_BY,'b');
    title_string=[ text_condition ' -All Conditions Channel ' Chan_name]
    title(title_string);
    legend_handle=legend('AX','AY','BX', 'BY'); 
    SP=2000;line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
    SP0=0; line([SP0 SP0], get(gca, 'ylim'), 'Color', [0 0 1]);
    saveas(fig1,title_string, 'fig');
    close(fig1)
    
    fig2=figure;
    set(gca, 'fontsize', 22);
    hb2=plot(timeVec_msec, C1_As, 'r', timeVec_msec, C1_Bs, 'b');
    title_string=[ text_condition 'As vs Bs Channel ' Chan_name]
    title(title_string);
    legend_handle2=legend('As', 'Bs');
    SP=2000;line([SP SP], get(gca, 'ylim'), 'Color', [0 0 1]);
    SP0=0; line([SP0 SP0], get(gca, 'ylim'), 'Color', [0 0 1]);
    saveas(fig2,title_string, 'fig');
    close(fig2)
end