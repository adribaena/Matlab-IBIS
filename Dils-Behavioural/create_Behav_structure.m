function create_Behav_structure
%% first to all we need to set up the parameters for the analysis.

    % you need to set a minimum time of 1, otherwise we can´t use filters
    % later
    
    filtroMinMS = 1;
    filtroMaxMS = 1000;

    dataDir = 'C:\DILs_data\';  % directory with folders which contains the excels.
    carpetaResultados  = 'C:\DILs_data\'; % output of the .mat

    % now starts the creation
    groupName = giveFoldersName(dataDir);
    
    dils_data.rawdata = [];
    
    for i = 1 : length(groupName)
        disp(['working with : ', groupName{i}]);
        [means , accs, names, rawdata]= generarMedias([dataDir,groupName{i},'\'], filtroMinMS, filtroMaxMS);
      
        dils_data.meansRT{1, i} = means;
        dils_data.group{1, i} = groupName{i};
        dils_data.ACC{1, i} = accs;
        dils_data.namefiles{1,i} = names';
        dils_data.rawdata{1,i}= rawdata;
        
    end

    filename = strcat(carpetaResultados, 'dils_structure');

    save(filename, 'dils_data', '-v7.3');
    
    disp(['done! your file dils_structure is in :  ', carpetaResultados]);

end




%% auxiliar functions

function  groupName = giveFoldersName(dataDir)
    d = dir(dataDir);
    % delete everything is not a dir
    esdir = [d.isdir];
    elemsToRemove = find(esdir == 0);
    d(elemsToRemove)= [];
    
    % we get the names and remove the actual and parent directory
    groupName = {d.name}';
    groupName(ismember(groupName,{'.','..'})) = [];
end


function [mediasGroup, accGroup, names, rawdataGroup] = generarMedias(new_route, fmin, fmax)

    rawdataGroup = [];
    mediasGroup = [];
    accGroup = [];

    d = dir(new_route);
    esdir = [d.isdir];
    elemsToRemove = find(esdir == 1);
    d(elemsToRemove)= [];
    names = {d.name};
    rts = {'Stimuli1.RT','Stimuli2.RT','Stimuli7.RT'};
    accs = {'Stimuli1.ACC','Stimuli2.ACC','Stimuli7.ACC'};
    
    for file = 1: numel(names)
        clear medias a
        routeFile = [new_route,names{file}];
        %leemos el fichero, y nos quedamos con las cabeceras de los datos
        [ndata, text, alldata] = xlsread(routeFile);
        VarName = text(2,:);
        
        timesFiltered = [];
        rawdata = [];
        
        for colStim = 1:3
            rt = find(strcmp(VarName,rts{colStim}));
            acc = find(strcmp(VarName,accs{colStim}));
            
            block_items = alldata(3:end,rt);
            block_acc = alldata(3:end,acc);
            
            block_items(isnan(cell2mat(block_items))) = [];

            block_acc(isnan(cell2mat(block_acc))) = [];

            block_items = cell2mat(reshape(block_items,[108,numel(block_items)/ 108]));
            block_acc = cell2mat(reshape(block_acc,[108,numel(block_acc)/ 108]));
            filtered_data = filterTimesByTimeAndACC(block_items,block_acc, fmin, fmax);
            timesFiltered =[ timesFiltered filtered_data];
            rawdata = [rawdata filtered_data];
        end   % end subject
    
        [items_means,accFiltered] = matrix_nanmean(timesFiltered,1);
        mediasGroup(file,:) = items_means;
        accGroup(file,:) = accFiltered;   
        rawdataGroup{file,1} = rawdata;
    end % end group

end


function [m,n] = matrix_nanmean(x,dim)
    
    nans = isnan(x);
    x(nans) = 0;
    
    if nargin == 1 
        n = sum(~nans);
        n(n==0) = NaN;
        m = sum(x) ./ n;
    else
        n = sum(~nans,dim);
        n(n==0) = NaN;
        m = sum(x,dim) ./ n;
    end

end 


function colSumT = filterTimesByTimeAndACC(times,acc,filtroMinMS, filtroMaxMS)

    %block tam filter by acc
    times = times .* acc;

    for col = 1:size(times,2)
        rt = times(:,col);    

        % replace outlier vals by NaN
        for row = 1: length(rt)
            if rt(row) < filtroMinMS | rt(row) > filtroMaxMS
                rt(row,1) = NaN;
            end
        end
        % fill columns with rt and resp values
        colSumT(:,col) = rt;
    end

end

