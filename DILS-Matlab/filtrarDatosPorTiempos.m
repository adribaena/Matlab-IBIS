function [outputTimes, outputACC] = filtrarDatosPorTiempos(times,acc, filtroMin, filtroMax)

bloques = size(times,2);

for col = 1:bloques
    rt = times(:,col);    
    resp = acc(:,col);
    
    for row = 1: length(rt)
        if rt(row) < filtroMin | rt(row) > filtroMax
            resp(row,1) = NaN;
            rt(row,1) = NaN;
        end
    end
    
    outputTimes(:,col) = rt;
    outputACC(:,col) = resp;
end

end