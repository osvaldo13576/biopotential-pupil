% busca el archivo en la carpeta especificada XXXXXXXXX_data.txt
function name = EEGdata_finder(directorio_archivo)
    patron = 'data.txt';
    directorio_archivo = fullfile(directorio_archivo, '**');
    filelist = dir(directorio_archivo);
    name = {filelist.name};
    TF = contains(name,patron);
    name = char(name(TF));
end
