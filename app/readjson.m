% leer un archivo json
function data = readjson(directorio_archivo)
    fileName = directorio_archivo;
    str = fileread(fileName);
    data = jsondecode(str);
end
