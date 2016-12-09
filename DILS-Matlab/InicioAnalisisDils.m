clear
clc

%% organizaremos aquí los parametros para guardar los resultados.


dataDir = 'C:\DILs_data\';  % el directorio donde están los Excel


carpetaResultados  = 'C:\arb\'; % la ruta de los resultados
nombreFicheroResultados = 'resultadospruebaguays.xlsx';  % el nombre del fichero de los resultados


%% ya todo es automatico

% el 1 en paciente en ON,   y el 2 en OFF
nombrePlantillas = {'Controles_v1_RS','Controles_v1_SR','Controles_v2_RS','Controles_v2_SR','EP_ON_RS','EP_ON_SR', ...
    'EP_OFF_RS','EP_OFF_SR','EP-DILS_ON_RS','EP-DILS_ON_SR', 'EP-DILS_OFF_RS','EP-DILS_OFF_SR'};

inicio = [2,2,2,2,2,2,2,2,2,2,2,2];
filename = [carpetaResultados , nombreFicheroResultados];
xlsheets(nombrePlantillas,filename);

    cabecera = {'sujeto','media b1','media b2','media b3','media b4','media b5','media b6','media b7','media b8','media b9','media b10','media b11','media b12','media b13','media b14',...
        'media b15','media b16','media b17','media b18','media b19','media b20','media b21','aciertos bloque1','aciertos bloque2','aciertos bloque3','aciertos bloque4','aciertos bloque5',...
        'aciertos bloque6','aciertos bloque7','aciertos bloque8','aciertos bloque9','aciertos bloque10','aciertos bloque11','aciertos bloque12'...
        ,'aciertos bloque13','aciertos bloque14','aciertos bloque15','aciertos bloque16','aciertos bloque17','aciertos bloque18','aciertos bloque19','aciertos bloque20','aciertos bloque21',...
        'errores bloque1','errores bloque2','errores bloque3','errores bloque4','errores bloque5'...
        ,'errores bloque6','errores bloque7','errores bloque8','errores bloque9','errores bloque10','errores bloque11','errores bloque12'...
        ,'errores bloque13','errores bloque14','errores bloque15','errores bloque16','errores bloque17','errores bloque18','errores bloque19'...
        ,'errores bloque20','errores bloque21'};
    

% declaramos filtros de tiempo de reacción
filtroMinMS = 100;
filtroMaxMS = 1000;

d = dir(dataDir);
esdir = [d.isdir];
%esdir = ~esdir;
elemsToRemove = find(esdir == 1);
d(elemsToRemove)= [];

for fich = 1: length(d)
    clear item
    
    nombreFich = d(fich).name;
    indicesLetra = find(nombreFich == '_');
    indicesSujeto = find(nombreFich == '-');
    finNombre = find(nombreFich == '.');
    
    numeroSujeto = str2num(nombreFich(indicesSujeto(1) + 1: indicesSujeto(2) - 1));
    visita = str2num(nombreFich(indicesSujeto(2) + 1: finNombre  - 1));
    
    primeraLetra = nombreFich(indicesLetra(1) + 1);
    segundaLetra = nombreFich(indicesLetra(2) + 1);
    
    if strcmp(primeraLetra,'R') == 1
        [medias, respGrafica] = leerficheroRS( [dataDir,nombreFich], filtroMinMS,filtroMaxMS); 
    else
        [medias, respGrafica] = leerficheroSR( [dataDir,nombreFich], filtroMinMS,filtroMaxMS); 
    end
    sj = ['sujeto ',num2str(numeroSujeto)];


    dummyData{1}= sj;

    for i = 1 : 21
        dummyData{1 + i} = medias(i);
        dummyData{22 + i} = respGrafica(1,i);
        dummyData{43 + i} = respGrafica(2,i);
    end
    
   if numeroSujeto < 21
       item = darNumero(visita, primeraLetra, [1,2,3,4]);
   elseif numeroSujeto < 41
       item = darNumero(visita, primeraLetra, [5,6,7,8]);       
   else
       item = darNumero(visita, primeraLetra, [9,10,11,12]);       
   end

    xlswrite(filename,cabecera,item,'A1');
    fila = ['A', num2str(inicio(item))];
    xlswrite(filename,dummyData,item,fila);
    inicio(item) = inicio(item) + 1;
end
