% crea una lista de archivos con la extension y directorio dados
% ejemplo '*.csv'
function lista = listaArchivos(directorio, extension)
    fileList = dir(fullfile(directorio, extension));
    lista = {fileList.name}';
end
