function [medias, respGrafica] = leerficheroRS(ruta, filtroMinMS,filtroMaxMS)

% declaramos filtros de tiempo de reacción 

% definimos el nombre del sujeto, el tipo de fichero, y la ruta de dónde
% está



disp(['Leyendo ',ruta,' ....']);

%leemos el fichero, y nos quedamos con las cabeceras de los datos
[ndata, text, alldata] = xlsread(ruta);
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

[columnSumsB1, columnSumsB1ACC ] = filtrarDatosPorTiempos(columnSumsB1,columnSumsB1ACC, filtroMinMS, filtroMaxMS);
[columnSumsB2, columnSumsB2ACC ] = filtrarDatosPorTiempos(columnSumsB2, columnSumsB2ACC, filtroMinMS, filtroMaxMS);
[LastBlock, LastBlockACC ] = filtrarDatosPorTiempos(LastBlock, LastBlockACC, filtroMinMS, filtroMaxMS);


for i = 1 : 10
    clear grupo1 grupo2
    grupo1 = columnSumsB1(:,i);
    grupo1(isnan(grupo1(:))) = [];
    medias(1,i) = mean(grupo1);
   grupo2 = columnSumsB2(:,i);   
    grupo2(isnan(grupo2(:))) = [];
    medias(1,10 + i) = mean(grupo2);
end
LastBlock(isnan(LastBlock(:))) = [];
medias(1,21) =mean(LastBlock);


[numeroCorrectosB1 , numeroIncorrectosB1]= contarCorrectosEIncorrectos(columnSumsB1ACC);
[numeroCorrectosB2 , numeroIncorrectosB2] = contarCorrectosEIncorrectos(columnSumsB2ACC);
[numeroCorrectosLast , numeroIncorrectosLast] = contarCorrectosEIncorrectos(LastBlockACC);

respuestasCorrectas = [numeroCorrectosB1 , numeroCorrectosB2, numeroCorrectosLast];
respuestasInCorrectas = [numeroIncorrectosB1 , numeroIncorrectosB2, numeroIncorrectosLast];

respGrafica = [respuestasCorrectas' , respuestasInCorrectas'];
respGrafica= respGrafica';

%set(gca,'Xtick',1:21, 'XTickLabel',{'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21'});

end