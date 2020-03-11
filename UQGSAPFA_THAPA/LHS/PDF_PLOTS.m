%%%POST PROCESSING: 
%% PLOT THE PDFS
clc
close all
load('LHSMAIN_OUTPUTMAIN.mat')

color=rand(4,3);
for respcount=1:4
    [flhs_data(:,respcount),xlhs_data(:,respcount)]=ksdensity(LHSMAIN_OUTPUTMAIN(:,respcount));
    
    figure(respcount)
    ax=gca;
    set(ax,'FontName','Times','Fontsize',18,'FontWeight','bold');
    set(gcf,'color',[1 1 1])   %to make the backgroung white
    hold all
    plot(xlhs_data(:,respcount),flhs_data(:,respcount),'-','Linewidth',3,'Color',color(respcount,:) )
    if respcount==1
        xlabel('\delta_{FPF}')
        ylabel('PDF of \delta_{FPF}')
    elseif respcount==2
        xlabel('P_{FPF}')
        ylabel('PDF of P_{FPF}')
    elseif respcount==3
        xlabel('\delta_{LPF}')
        ylabel('PDF of \delta_{LPF}')
    elseif respcount==4
        xlabel('P_{LPF}')
        ylabel('PDF of P_{LPF}')
    end
    
    %xlim([0 maxdim+1])
    %ylim([0 maxorder+1])
    grid on
    hold off
end
save('xlhs_data.mat','xlhs_data'); save('xlhs_data.dat','xlhs_data','-ascii');
save('flhs_data.mat','flhs_data'); save('flhs_data.dat','flhs_data','-ascii');

