% busca el archivo en la carpeta especificada Emo_Flechas.data.20XX-XX-XX--XX-XX.txt
% actualizacion: Prueba_Oficial.data20XX
function name = EmoFlechas_finder(directorio_archivo)
    patron = 'Prueba_Oficial';
    directorio_archivo = fullfile(directorio_archivo, '**');
    filelist = dir(directorio_archivo);
    name = {filelist.name};
    name = name(strncmp(name, patron, 1));
    name = char(name);
end
