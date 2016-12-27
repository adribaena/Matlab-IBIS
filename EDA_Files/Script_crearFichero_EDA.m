clear
clc

DataDir = 'C:\Users\Antonio\Desktop\EDA_Files\';
nameFile = 'EDA_TEST.smr';
nombre_txt_salida = 'prueba_ledalab.txt';


eda_freq = 1000;    
eda_resample = 50; % OJO importante, si es 0 no hay downsampling

%% comenzamos intentando abrir el fichero

fid=fopen([DataDir, nameFile]); 
    if fid <= 0
      disp('pa tu casa')
      return;
    end;
    
%% leemos el fichero y sacamos los datos raw y eventos    
[eda,eda_header]=SONGetChannel(fid,2);

disp(['la frecuencia es : ', num2str(eda_freq),' Hz']);

wave_eda=double(eda);
event = get_eda_events (fid);


        
%% miramos si resampleamos o no con la variable eda_resample
switch eda_resample
    case 0
        % si es 0, el tiempo, los eventos, y la estructura de resultados es
        % completa
        disp('no downsampling')
        
        time = eda_header.start:eda_header.sampleinterval:eda_header.stop;
        pos_eventos = zeros(length(wave_eda),1);
        estructuraRes = [time' , wave_eda', pos_eventos ]; 
        
    otherwise
        % si no es 0, tenemos que hacer downsampling de la señal y volver a
        % calcular el tiempo con la nueva frecuencia
        disp(['downsampling a : ', num2str(eda_resample),' Hz']);
        
        % sacamos el ratio de frecuencias y lo usamos en nuestro resample
        [fs_orig, fs_res] = rat(eda_freq/eda_resample);        
        wave_eda_flt=resample(wave_eda,fs_res,fs_orig);
        
%         figure
%         subplot(3,1,1)
%         plot(wave_eda)
%         subplot(3,1,2)
%         plot(WvData_Flt)
%         subplot(3,1,3)
%         m = abs(min(WvData_Flt));
%         WvData_Flt2 = WvData_Flt + m;
%         plot(WvData_Flt2);

        time = eda_header.start:inv(eda_resample):eda_header.stop;
        pos_eventos = zeros(length(wave_eda_flt),1);
        estructuraRes = [time' , wave_eda_flt', pos_eventos ];
end

%% modificamos la estructuraRes para nuestros nuevos marcadores, que están en events
disp('creando marcadores...')


for voyPor = 1 : length(event.time)
    % cogemos el marcador, buscamos el punto que coincida en tiempo, o el
    % siguiente posterior, y sustituimos el 0 por el marcador que sea (1 - 19)
    mkr = event.time(voyPor);
    pos = find (time >= mkr,1);
    estructuraRes(pos,3) = event.nid(voyPor);

end

disp('marcadores creados')

%% hemos creado los marcadores, ahora creamos el fichero de salida y lo rellenamos


rutaCompletaSalida = [DataDir, nombre_txt_salida];
infoFicheroSalida = fopen(rutaCompletaSalida, 'w');


if infoFicheroSalida < 0
    disp('ande va tu');
    return
end

disp(['escribiendo en : ', nombre_txt_salida ])

%% escribimos en el fichero de salida de la forma que necesita Ledalab para leerlo como entrada
tic;
for lf = 1: length(estructuraRes)
    formatoLedalab = '%.4f %.0f %d\n'; % expresion regular de 4 decimales, 0 decimales y un entero
    fprintf(infoFicheroSalida,formatoLedalab,estructuraRes(lf,1),estructuraRes(lf,2),estructuraRes(lf,3));
end
toc;

%% cerramos los ficheros para usarlos más adelante y estamos listos para Ledalab
fclose(infoFicheroSalida);
fclose(fid);

disp(['¡Hecho!, tu fichero ''', nombre_txt_salida,''' está en --> ', DataDir]);

% Ledalab
