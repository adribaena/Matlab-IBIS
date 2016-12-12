clear all
clc


dataDir = 'C:\DILs_data\';
% define group
group = 'Controles';

% cargar un dils_structure.mat
load([dataDir,'dils_structure.mat']);


indexGeneral = find(strcmp(dils_data.group, group));

disp('¡¡ gogogo !!');
clear dataDir

rawdata_g = dils_data.rawdata{1,indexGeneral};
acc_g = dils_data.ACC{1,indexGeneral};
means_g = dils_data.meansRT{1,indexGeneral};
namefiles_g = dils_data.namefiles{1,indexGeneral};



% pendiente de revisar y terminar

%% no terminado ( descomentar)

figure
hold on
plot(1:21,means_g)
legend(namefiles_g)
%lower limit
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);

figure
hold on
bar(acc_g')
legend(namefiles_g)

%%





