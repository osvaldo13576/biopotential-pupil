% funcion que regresa un valor logico si un archivo esta en el directorio
function valor = isarchivo(directorio,file)
    d = dir(directorio);
    nameFiles = {d.name}';
    valor = any(strcmp(nameFiles,file));
end