function create_Behav_structure
clear
clc

%% organizaremos aquí los parametros para guardar los resultados.


filtroMinMS = 100;
filtroMaxMS = 1000;

dataDir = 'C:\DILs_data\';  % el directorio donde están los Excel

carpetaResultados  = 'C:\DILs_data\'; % la ruta de los resultados

% declaramos filtros de tiempo de reacción


d = dir(dataDir);
groupName = {d.name}';
groupName(ismember(groupName,{'.','..'})) = [];


dils_data.meansRT = [];
dils_data.group = [];
dils_data.ACC = [];

for i = 1 : length(groupName)
    
    grupo = groupName{i};
    new_route = [dataDir,grupo,'\'];
    [means accs]= generarMedias(new_route, filtroMinMS, filtroMaxMS);
    
    dils_data.meansRT{1, i} = means;
    dils_data.group{1, i} = grupo;
    dils_data.ACC{1, i} = accs;
    
end

filename = strcat(carpetaResultados, 'dils_structure');

save(filename, 'dils_data', '-v7.3');

disp(['hecho! tu fichero dils_structure está en :  ', carpetaResultados]);

end




%% auxiliar functions

function [mediasGroup, accGroup] = generarMedias(new_route, fmin, fmax)

        mediasGroup = [];
        accGroup = [];

    d = dir(new_route);
    esdir = [d.isdir];
    elemsToRemove = find(esdir == 1);
    d(elemsToRemove)= [];
    names = {d.name};
    
    for file = 1: numel(names)
        clear medias a
        routeFile = [new_route,names{file}];
        %leemos el fichero, y nos quedamos con las cabeceras de los datos
        [ndata, text, alldata] = xlsread(routeFile);
        VarName = text(2,:);

        ColNum.FirstBlock = find(strcmp(VarName,'Stimuli1.RT'));
        ColNum.SecondBlock = find(strcmp(VarName,'Stimuli2.RT'));
        ColNum.LastBlock = find(strcmp(VarName,'Stimuli7.RT'));

        ColNum.FirstBlockACC = find(strcmp(VarName,'Stimuli1.ACC'));
        ColNum.SecondBlockACC = find(strcmp(VarName,'Stimuli2.ACC'));
        ColNum.LastBlockACC = find(strcmp(VarName,'Stimuli7.ACC'));

        FirstBlock = alldata(3:end,ColNum.FirstBlock);
        SecondBlock = alldata(3:end,ColNum.SecondBlock);
        LastBlock = alldata(3:end,ColNum.LastBlock);

        FirstBlockACC = alldata(3:end,ColNum.FirstBlockACC);
        SecondBlockACC = alldata(3:end,ColNum.SecondBlockACC);
        LastBlockACC = alldata(3:end,ColNum.LastBlockACC);


        FirstBlock(isnan(cell2mat(FirstBlock))) = [];
        SecondBlock(isnan(cell2mat(SecondBlock))) = [];
        LastBlock(isnan(cell2mat(LastBlock))) = [];

        FirstBlockACC(isnan(cell2mat(FirstBlockACC))) = [];
        SecondBlockACC(isnan(cell2mat(SecondBlockACC))) = [];
        LastBlockACC(isnan(cell2mat(LastBlockACC))) = [];

        columnSumsB1ACC = cell2mat(reshape(FirstBlockACC,[108,10]));
        columnSumsB2ACC = cell2mat(reshape(SecondBlockACC,[108,10]));


        columnSumsB1 = cell2mat(reshape(FirstBlock,[108,10]));
        columnSumsB2 = cell2mat(reshape(SecondBlock,[108,10]));

        LastBlock = cell2mat(LastBlock);
        LastBlockACC = cell2mat(LastBlockACC);
        medias = zeros(1,21);
        
        [columnSumsB1, columnSumsB1ACC ] = filtrarDatosPorTiempos(columnSumsB1,columnSumsB1ACC, fmin, fmax);
        [columnSumsB2, columnSumsB2ACC ] = filtrarDatosPorTiempos(columnSumsB2, columnSumsB2ACC, fmin, fmax);
        [LastBlock, LastBlockACC ] = filtrarDatosPorTiempos(LastBlock, LastBlockACC, fmin, fmax);

        for i = 1 : 10
            clear grupo1 grupo2
            grupo1 = columnSumsB1(:,i);
            grupo1(isnan(grupo1(:))) = [];
            medias(1,i) = mean(grupo1);
            % ACC counter 
            
            grupo1ACC = columnSumsB1ACC(:,i);
            grupo1ACC(isnan(grupo1ACC(:))) = [];
            a(1,i) = length(find (grupo1ACC == 1));
            % group 2
            grupo2 = columnSumsB2(:,i);   
            grupo2(isnan(grupo2(:))) = [];
            medias(1,10 + i) = mean(grupo2);

            grupo2ACC = columnSumsB2ACC(:,i);
            grupo2ACC(isnan(grupo2ACC(:))) = [];
            a(1,10 + i) = length(find (grupo2ACC == 1));            
            
        end
        LastBlock(isnan(LastBlock(:))) = [];
        medias(1,21) =mean(LastBlock);
    
        LastBlockACC(isnan(LastBlockACC(:))) = [];
        a(1,21) = length(find (LastBlockACC == 1));   
        
        mediasGroup(file,:) = medias;
        accGroup(file,:) = a;
        
        
    end

end




function [colSumT, colSumACC ] = filtrarDatosPorTiempos(times,acc,filtroMinMS, filtroMaxMS)

    %block tam
    bloques = size(times,2);

    for col = 1:bloques
        rt = times(:,col);    
        resp = acc(:,col);

        for row = 1: length(rt)
            if rt(row) < filtroMinMS | rt(row) > filtroMaxMS | resp(row) == 0
                resp(row,1) = NaN;
                rt(row,1) = NaN;
            end
        end

        colSumT(:,col) = rt;
        colSumACC(:,col) = resp;
    end

end
