% crea una lista de Folders con el directorio dado
function lista = listaFolders(directorio) 
    d = dir(directorio);
    isub = [d(:).isdir];
    lista = {d(isub).name}';
    %lista(ismember(lista,{'.','..'})) = [];
end