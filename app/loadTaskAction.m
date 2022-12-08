% carga datos relacionados con el erchivo Emo_Flechas
% variables emoflechasload 
function [numPart_Duracion, strAction] = loadTaskAction(indices,emoflechas)
    indices = indices - indices(1,1) +1;
    numdata = indices(end,2) - indices(1,1) +1;
    numPart_Duracion = ones(numdata,2);
    numPart_Duracion(:,2) = 0;
    strAction = cell(numdata,1);strAction(1:end)={'---'};
    for i = 1:length(indices(:,1))
        %numPart_Duracion(indices(i,1):indices(i,2),1) = emoflechas.Var3(i);
        numPart_Duracion(indices(i,1):indices(i,2),2) = emoflechas.Var1(i);
        strAction(indices(i,1):indices(i,2)) = emoflechas.Var2(i); 
    end

    %cond1 = emoflechas.Var3 == 1;
    cond2 = emoflechas.Var3 == 2;
    %startOne = indices(cond1,1);%finishOne = indices(cond1,2);
    startTwo = indices(cond2,1);finishTwo = indices(cond2,2);
    %numPart_Duracion(startOne(1):startTwo(1)-1,1) = 1;
    numPart_Duracion(startTwo(1):finishTwo(end),1) = 2;
end