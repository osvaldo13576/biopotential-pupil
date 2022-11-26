% busca el archivo en la carpeta especificada
function name = file_finder(directorio_archivo,patron)
    directorio_archivo = fullfile(directorio_archivo, '**');
    filelist = dir(directorio_archivo);
    name = {filelist.name};
    name = name(strncmp(name, patron, 1));
    name = char(name);
end
