%% autores: Antonio Rodríguez Baena (IBIS), ...

clear;
clc;

%% cargar un fichero linea a linea 

% 1 ) decir la ruta del fichero, y el nombre de lo que necesitamos

frecuencia = 5000;
ruta = 'C:\Users\Antonio\Desktop\EEG\EEG SMI047\';
rutaSalida = 'C:\Users\Antonio\Desktop\';

nombreFicheroEntrada = 'DILs_SMI047_B1-5.vmrk.vmrk';  % original, no es de ningún tipo
excelDeDosColumnas = 'ficheroDeDosColumnas.xlsx';  % excel de 2 columnas

rutaCompletaEntrada = [ruta, nombreFicheroEntrada];
rutaCompletaSalida = [rutaSalida, nombreFicheroEntrada];



rutaExcel = [ruta,excelDeDosColumnas];
[datos,cabeceras,alldata] = xlsread(rutaExcel);



infoFicheroEntrada = fopen(rutaCompletaEntrada, 'r'); % pregunta, ¿qué es r y w de fopen?
infoFicheroSalida = fopen(rutaCompletaSalida, 'w');

if infoFicheroEntrada < 0
    disp('ruta mala, colega');
    return
end




%% comienza el bucle ...
for v = 1 : 12
    cabeceras = fgetl(infoFicheroEntrada);
    if v == 11
        rses = 1;
        comillas = strfind(cabeceras,'"');
        fprintf(infoFicheroSalida, cabeceras(1:comillas(1)-1));
        fprintf(infoFicheroSalida,['"','\\1']);
        fprintf(infoFicheroSalida, [cabeceras(comillas(2):end),'\n']);
    else 
        fprintf(infoFicheroSalida, [cabeceras,'\n']);
    end
end

voyPor = 1;
punteroExcel = 0;
proximaLinea = fgetl(infoFicheroEntrada);

while ischar(proximaLinea)
    lineaSeparadaPorComa = strsplit(proximaLinea,',');
    
    if strcmp(lineaSeparadaPorComa{2},'S  5') == 0 && strcmp(lineaSeparadaPorComa{2},'S  6') == 0
        
        voyPor = voyPor + 1;        
        lineaSeparadaPorComa{1,1} = ['Mk',num2str(voyPor),'=Stimulus'];
        fprintf(infoFicheroSalida, [strjoin(lineaSeparadaPorComa,','),'\n']);
        if strcmp(lineaSeparadaPorComa{2},'S  1') ~= 0 | strcmp(lineaSeparadaPorComa{2},'S  2') ~= 0 | strcmp(lineaSeparadaPorComa{2},'S  3') ~= 0 | strcmp(lineaSeparadaPorComa{2},'S  4') ~= 0
            punteroExcel = punteroExcel + 1;
            puntoDelMarcador = str2num(lineaSeparadaPorComa{1,3});
            heAcertado = datos(punteroExcel,1);
            rt = datos(punteroExcel,2);
            incremento = (rt / 1000) * frecuencia;
            puntoDelMarcador = puntoDelMarcador + incremento;
            lineaSeparadaPorComa{1,3} = num2str(puntoDelMarcador);        
            if heAcertado == 1
                lineaSeparadaPorComa{1,2} = 'S  5';
                voyPor = voyPor + 1;
                lineaSeparadaPorComa{1,1} = ['Mk',num2str(voyPor),'=Stimulus'];
                fprintf(infoFicheroSalida, [strjoin(lineaSeparadaPorComa,','),'\n']); % ¿qué es strjoin?

            else
                lineaSeparadaPorComa{1,2} = 'S  6';
                voyPor = voyPor + 1;
                lineaSeparadaPorComa{1,1} = ['Mk',num2str(voyPor),'=Stimulus'];
                fprintf(infoFicheroSalida, [strjoin(lineaSeparadaPorComa,','),'\n']); % ¿qué es strjoin? 
            end

    
        end % cierro 1 - 4
    end% cierro 5 - 6
    disp(proximaLinea);
    proximaLinea = fgetl(infoFicheroEntrada);
end
    
    

fclose(infoFicheroEntrada);  % ¿para qué sirve fclose?
fclose(infoFicheroSalida);

disp(['Hecho! tu fichero ''',nombreFicheroEntrada,'''  está en ', ruta]); % ¿ qué son esas tres comillas juntas -- > '''  ?

