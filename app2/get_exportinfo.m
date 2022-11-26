%obtiene los numero de datos del archivo export_info.csv
function numdatos = get_exportinfo(directorio_file)
    datos = readtable(directorio_file,'PreserveVariableNames',true);
    numdatos = datos.Var5(4);
end