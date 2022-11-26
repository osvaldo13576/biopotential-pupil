% carga los archivos Emo_Flechas.data.20XX-XX-XX--XX-XX.txt
function data = loadEmoFlechas(directorio_archivo)
    data = readtable(directorio_archivo);
end
