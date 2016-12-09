function   item = darNumero(visita, primeraLetra, lista)

if visita == 1
    if strcmp(primeraLetra,'R') ==1
        item = lista(1);
    else
        item = lista(2);
    end
else
    if strcmp(primeraLetra,'R') ==1
        item = lista(3);
    else
        item = lista(4);
    end    
end
end