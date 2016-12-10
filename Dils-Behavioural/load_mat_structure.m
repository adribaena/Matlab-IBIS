function load_mat_structure

clear all
clc

% definde group
group = 'Controles';

% cargar un dils_structure.mat
load('dils_structure.mat')

% pendiente de revisar y terminar

%% no terminado de comentar

indexGroup = find(strcmp(dils_data.group, group));

reactionTimeGroup = dils_data.meansRT{indexGroup};
accGroup = dils_data.ACC{indexGroup};

plot(1:21,reactionTimeGroup,'*')
hold on
plot(1:21,reactionTimeGroup)

%lower limit
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);




end