function event = get_eda_events(fid) 

%% usaremos un marcador que empieza en 1 y se incrementa en 2 por cada evento, como en eprime
n_ev = 1;

%  nombre_eventos = {'Ev0.10' 'Ev0.15' 'Ev0.20' 'Ev0.25' 'Ev0.40' 'Ev0.45' 'Ev0.50' 'Ev0.55' 'Ev0.70' 'Ev0.80'}

puntero = 0;

    for index = 1: 10 

        % cargamos a partir del canal 5
        [marcadores,header]=SONGetChannel(fid,index+4);
        
        % generamos nuestra estructura event
        event.time(puntero + 1 : puntero + length(marcadores),1) = marcadores;
        event.nid(puntero + 1 : puntero + length(marcadores),1) = repmat(n_ev,length(marcadores),1);
        event.name(puntero + 1 : puntero + length(marcadores),1) = repmat({num2str(n_ev)},length(marcadores),1);

        % incrementamos nuestro numero de evento en 2, para que vayamos de
        % impar en impar
        
        n_ev = n_ev  + 2 ;
        puntero = puntero + length(marcadores);

    end

end