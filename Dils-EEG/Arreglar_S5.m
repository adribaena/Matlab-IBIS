% autores: Antonio Rodríguez Baena (IBIS), ...

clear;
clc;

%% cargar un fichero linea a linea 

% 1 ) decir la ruta del fichero, y el nombre de lo que necesitamos

ruta = 'C:\Users\Antonio\Desktop\EEG\';

nombreFicheroEntrada = 'Marcadores047-B1-5(sin 5)';  % original, no es de ningún tipo
nombreFicheroSalida = 'paco';   % salida
excelDeDosColumnas = 'ficheroDeDosColumnas.xlsx';  % excel de 2 columnas

% 2 ) juntar la ruta y el nombre, y eso se hace con los corchetes. Se pegan
% los textos que metes dentro de los corchetes si los separas por coma.

rutaCompletaEntrada = [ruta, nombreFicheroEntrada];
rutaCompletaSalida = [ruta, nombreFicheroSalida ];

% 3 ) leemos el Excel, y tenemos 3 cosas: los datos, las cabeceras y los
% datos junto a las cabeceras (fíjate en el orden de lo que nos devuelve
% xlsread.

rutaExcel = [ruta,excelDeDosColumnas];
[datos,cabeceras,alldata] = xlsread(rutaExcel);


% vamos a preparar un código para leer linea a línea un fichero. Esto lo
% usaremos para cuando vayamos a modificar un valor de dentro del fichero,
% o crear otro en que guardemos un resultado.

infoFicheroEntrada = fopen(rutaCompletaEntrada, 'r'); % pregunta, ¿qué es r y w de fopen?
infoFicheroSalida = fopen(rutaCompletaSalida, 'w');

% si no podemos abrir un fichero sin extension el programa termina con return ( los que no son txt, pdf,
% ...), tienes que saber que si los intentamos abrir y no se pueden, devuelve un número negativo.

if infoFicheroEntrada < 0
    disp('ruta mala, colega');
    return
end


% una vez que hemos abierto el fichero de entrada, con la función fgetl,
% nos da una linea entera del fichero de texto, pero todo junto. 
%  Para más info leete  https://es.mathworks.com/help/matlab/ref/fgetl.html

% Cada vez que hagamos fgetl sobre un fichero, nos irá dando línea tras línea. Esto es peligroso
% porque nos irá dando líneas infinitamente, hasta que lo paremos de alguna
% forma. Como curiosidad, si pedimos una línea, y ya hemos llegado al
% final, se lanza un error porque Matlab no está muy preparado para
% trabajar con ficheros, leer lineas, ....  Esto se usa más en otros
% lenguajes como Python o C, pero para lo que queremos nos vale.

primeraLinea = fgetl(infoFicheroEntrada);

% otra cosa importante, con fprintf, imprimimos en un fichero, lo que
% queramos.
% Si buscas por internet, verás que se puede hacer write o print sobre un
% fichero. Write no machaca lo que hubiera antes en la misma línea, y
% fprint si. La f de fprint es de un fichero.

% Yo suelo usar fprint en vez de write, porque supongo que cada vez que
% escriba en un fichero, es como si estuviera vacío, o tuviera que machacar
% lo que había antes.

% Una cosa que tienes que saber, es que [primeraLinea,'\n'] junta la línea que leimos del fichero de 
% entrada con \n.

% \n es el salto de línea, es como si se pulsara la tecla Enter.

% lo que hace la línea de abajo es imprimir en un fichero de resultados
% la línea línea del primer fichero que nos dió fgetl, y luego se "pinta" un \n, así que saltamos a la 
% línea de abajo y estamos listos para la siguiente.

fprintf(infoFicheroSalida, [primeraLinea,'\n']); % pregunta : ¿ qué pasa si lo quitamos?

% si no se pusiera lo de \n, es como si escribiéramos en una sola línea
% todo, y eso no queremos, ¿verdad?


% si recuerdas, primera línea era algo así como 

% primera línea  --->  " Sampling rate: 5000Hz, SamplingInterval: 0.20ms "

% la primera línea contiene la frecuencia de muestreo, y se encuentra,
% dentro de esa línea, entre las letras 16 y 19.

% Por ejemplo, es 5000, 2500, ..... pero si sacamos lo que está en primera línea entre las
% posiciones 16 a la 19, eso es una palabra, no un número. 

% Te recuerdo que si leemos algo de un fichero, es una palabra, pero
% tenemos que pasarlo a número para usarlo más abajo en el bucle.

frecuencia= str2num(primeraLinea(16:19)); % pregunta : ¿ qué hace str2num?  ¿ y num2str?

% disp nos sirve para mostrar en el command window lo que hemos creado.
disp(['la frecuencia es : ', num2str(frecuencia)]);




%% comienzan los deberes ...

cabeceras = fgetl(infoFicheroEntrada);
fprintf(infoFicheroSalida, cabeceras);


voyPor = 1;
proximaLinea = fgetl(infoFicheroEntrada);
while ischar(proximaLinea)
    lineaSeparadaPorComa = strsplit(proximaLinea,', ');  % ¿ qué es strsplit?
    lineaSeparadaPorComa{1,2} = 'S  5';
    puntoDelMarcador = str2num(lineaSeparadaPorComa{1,3});
    heAcertado = datos(voyPor,1);
    rt = datos(voyPor,2);
    incremento = (rt / 1000) * frecuencia;
    puntoDelMarcador = (puntoDelMarcador + incremento) * heAcertado;
    if puntoDelMarcador > 0
        lineaSeparadaPorComa{1,3} = num2str(puntoDelMarcador);        
        fprintf(infoFicheroSalida,'\n');
        fprintf(infoFicheroSalida, strjoin(lineaSeparadaPorComa,',')); % ¿qué es strjoin?
    end
    disp(proximaLinea);
    voyPor = voyPor + 1;
    proximaLinea = fgetl(infoFicheroEntrada);
end
    

fclose(infoFicheroEntrada);  % ¿para qué sirve fclose?
fclose(infoFicheroSalida);

disp(['Hecho! tu fichero ''',nombreFicheroSalida,'''  está en ', ruta]); % ¿ qué son esas tres comillas juntas -- > '''  ?

