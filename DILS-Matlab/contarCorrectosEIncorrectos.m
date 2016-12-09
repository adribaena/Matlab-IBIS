function [numeroCorrectos , numeroIncorrectos]= contarCorrectosEIncorrectos(bloque)

[filas ,columnas] =size(bloque);

for c = 1 : columnas
    b = bloque (:,c);
    numeroCorrectos(c) = length(find (b == 1)); 
    numeroIncorrectos(c) = length(find (b == 0));    
end

end
