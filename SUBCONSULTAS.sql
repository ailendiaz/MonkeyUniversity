-- (1)  Listado con apellidos y nombres de los usuarios que no se hayan inscripto a cursos durante el año 2019.
Select Nombres,Apellidos From Datos_Personales where id not in (Select distinct IDUsuario From Inscripciones where year (Fecha)=2019)


-- 2  Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero no hayan realizado ningún pago.
Select Nombres, Apellidos From Datos_Personales where id not in (select idInscripcion From Pagos)

Select Nombres, Apellidos From Datos_Personales where id not in (Select I.ID From Inscripciones as I Inner Join Pagos as P On I.ID= P.IDInscripcion)

-- 3  Listado de países que no tengan usuarios relacionados.
Select P.Nombre From Paises as P where id not in (select distinct IDPais From Datos_Personales)

-- (4)  Listado de clases cuya duración sea mayor a la duración promedio. 
Select * From Clases where Duracion> (select avg (duracion) From Clases)

-- (5)  Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los contenidos de tipo 'Audio de alta calidad'.
    Select * From Contenidos
    Where Tamaño > (
    Select Max(Tamaño) From Contenidos as C
    Inner Join TiposContenido as TC ON TC.ID = C.IDTipo
    Where TC.Nombre = 'Audio de alta calidad')


-- 6  Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido de tipo 'Audio de alta calidad'. ///VERIFICAR
    Select * From Contenidos Where Tamaño < (
    Select top 1 Tamaño From Contenidos as C
    Inner Join TiposContenido as TC ON TC.ID = C.IDTipo
    Where TC.Nombre = 'Audio de alta calidad')

-- (7)  Listado con nombre de país y la cantidad de usuarios de género masculino y la cantidad de usuarios de género femenino que haya registrado.

   Select P.Nombre, 
(
    Select Count(*) From Datos_Personales Where Genero = 'F' And IDPais = P.ID
) As CantF, 
(
    Select Count(*) From Datos_Personales Where Genero = 'M' And IDPais = P.ID
) as CantM
From Paises as P


-- 8  Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones realizadas 
--en el 2019 y la cantidad de inscripciones realizadas en el 2020.

Select DAT.Apellidos, DAT.Nombres, (Select count (*) From Inscripciones as I
inner join Usuarios as U
On I.IDUsuario= I.ID
where year (Fecha)=2019) as CantIns2019,
(Select count (*) From Inscripciones as I
inner join Usuarios as U
On I.IDUsuario= I.ID
where year (Fecha)=2020) as CantIns2020
From Datos_Personales as DAT 
inner Join Usuarios as U
ON DAT.ID = u.ID


-- 9  Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la cantidad de idiomas de audio,
--la cantidad de subtítulos y la cantidad de texto de video.

Select C.Nombre,
(Select count (IDTipo) From Idiomas_x_Curso inner join TiposIdioma as TI
On IDTipo=TI.ID where Nombre = 'Audio' and C.ID= IDCurso )as CantAudio,
(Select count (IDTipo) From Idiomas_x_Curso as ID inner Join TiposIdioma AS TI
On ID.IDTipo= TI.ID 
where Nombre = 'Subtítulo' and C.ID= IDCurso) as CantSubt,
(Select count (IDTipo) From Idiomas_x_Curso as ID inner Join TiposIdioma AS TI
On ID.IDTipo= TI.ID
where Nombre = 'Texto del Video' and C.ID= IDCurso) as CantVideo
From Cursos as C


-- 10  Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de cursos de nivel 'Principiante'
--que realizó y cantidad de cursos de nivel 'Avanzado' que realizó.

Select DAT.Apellidos + DAT.Nombres as 'Nombre y Apellido', U.NombreUsuario,
(Select count (*) From Inscripciones as I inner join Cursos as C On I.IDCurso= C.ID
inner Join Niveles as N
On C.IDNivel= N.ID
Where N.Nombre= 'Principiante' and U.ID= I.IDUsuario)as InscPrinc,
(Select count (*) From Inscripciones as I inner join Cursos as C On I.IDCurso= C.ID
inner Join Niveles as N
On C.IDNivel= N.ID
Where N.Nombre= 'Avanzado' and U.ID= I.IDUsuario)as InsAvan
From Datos_Personales as DAT inner Join Usuarios as U
On DAT.ID = U.ID

-- 11  Listado con nombre de los cursos y la recaudación de inscripciones de usuarios de género femenino que se inscribieron y
--la recaudación de inscripciones de usuarios de género masculino.

Select C.Nombre, (Select isnull (sum (I.Costo),0) from Inscripciones as I inner join Datos_Personales as DAT
On I.IDUsuario= DAT.ID
where DAT.Genero = 'F' and C.ID= I.IDCurso) as RecInscFem,
(Select sum (I.Costo) from Inscripciones as I inner join Datos_Personales as DAT
On I.IDUsuario= DAT.ID
where DAT.Genero = 'M' and C.ID= I.IDCurso) as RecInsMas
From Cursos as C 


-- 12  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino.

Select * From (
    Select P.Nombre, 
    (
        Select Count(*) From Datos_Personales Where Genero = 'F' And IDPais = P.ID
    ) As CantF, 
    (
        Select Count(*) From Datos_Personales Where Genero = 'M' And IDPais = P.ID
    ) as CantM
    From Paises as P
) as AUX
Where AUX.CantM > Aux.CantF

-- 13  Listado con nombre de país de aquellos que hayan registrado más usuarios de género masculino que de género femenino pero 
--que haya registrado al menos un usuario de género femenino.


Select * From (
    Select P.Nombre, 
    (
        Select Count(*) From Datos_Personales Where Genero = 'F' And IDPais = P.ID
    ) As CantF, 
    (
        Select Count(*) From Datos_Personales Where Genero = 'M' And IDPais = P.ID
    ) as CantM
    From Paises as P
) as AUX
Where AUX.CantM > Aux.CantF  and AUX.CantF !=0


-- 14  Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que de subtítulos. //DUDAS
Select * From (Select Distinct C.Nombre, 
(Select count (*) From TiposIdioma as TI where TI.Nombre= 'Audio' and C.ID= IC.IDCurso) as CantAudio,
(Select count (*) From TiposIdioma as TI where TI.Nombre= 'Subtítulo' and  C.ID= IC.IDCurso) as CantSub
From Cursos as C inner join Idiomas_x_Curso as IC
On C.ID= IC.IDCurso) as AUX
where AUX.CantAudio = AUx.CantSub


-- 15  Listado de usuarios que hayan realizado más cursos en el año 2018 que en el 2019 y a su vez más cursos en el año 2019 que en el 2020.
Select AUX.NombreUsuario From(Select U.nombreUsuario,
(Select count (*)From Inscripciones as I where year (I.fecha)=2018 and I.IDUsuario= U.ID) as Cant2018, 
(Select count (*)From Inscripciones as I where year (I.fecha)=2019 and I.IDUsuario= U.ID) as Cant2019,
(Select count (*)From Inscripciones as I where year (I.fecha)=2020 and I.IDUsuario= U.ID) as Cant2020
 From Usuarios as U) as AUX
 where AUX.Cant2018>AUX.Cant2019 and AUX.Cant2019>AUX.Cant2020

-- 16  Listado de apellido y nombres de usuarios que hayan realizado cursos pero nunca se hayan certificado
Select DAT.Apellidos +DAT.Nombres as 'Apellido y Nombre' From Datos_Personales AS DAT 
where DAT.ID in
(
	select I.IDUsuario from Inscripciones as I
	where I.ID not in
	(
		select C.IDInscripcion from Certificaciones as C
	)
)

