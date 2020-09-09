Use MonkeyUniv
go
-- (1) Listado con nombre de usuario de todos los usuarios y sus respectivos nombres y apellidos.
SELECT nombres, apellidos from Datos_Personales as DP
inner join Usuarios as U
ON DP.ID= U.ID


-- Lo que realiza la cláusula join en memoria

-- 2 Listado con apellidos, nombres, fecha de nacimiento y nombre del país de nacimiento. 
SELECT apellidos, nombres,nacimiento,p.Nombre from Datos_Personales as DP
inner join Paises as P
ON DP.IDPais = P.ID


-- (3) Listado con nombre de usuario, apellidos, nombres, email o celular de todos los usuarios que vivan en una domicilio cuyo nombre contenga el término 'Presidente' o 'General'. NOTA: Si no tiene email, obtener el celular.
SELECT  U.nombreUsuario, DP.Apellidos, DP.Nombres,isnull (DP.Email,DP.Celular), DP.Domicilio
from Usuarios as U
inner join Datos_Personales as DP
ON U.ID = DP.ID
WHERE DP.Domicilio like '%Presidente%' or DP.Domicilio like '%General%'

-- 4 Listado con nombre de usuario, apellidos, nombres, email o celular o domicilio como 'Información de contacto'.  NOTA: Si no tiene email, obtener el celular y si no posee celular obtener el domicilio.
SELECT U.nombreUsuario, DP.apellidos, DP.nombres, isnull (isnull (DP.email, DP.Celular),DP.domicilio) as InfoContacto 
from Usuarios as U
inner join Datos_Personales as DP
ON U.ID =DP.ID

-- (5) Listado con apellido y nombres, nombre del curso y costo de la inscripción de todos los usuarios inscriptos a cursos.  NOTA: No deben figurar los usuarios que no se inscribieron a ningún curso.
SELECT DAT.apellidos, DAT.nombres, C.nombre, I.Costo from Cursos as C
inner join Inscripciones as I
ON C.ID= I.IDCurso
inner join Usuarios as U
ON U.ID = I.IDUsuario
inner join Datos_Personales as DAT
ON U.ID = DAT.ID

-- Ejemplo de Union

-- 6 Listado con nombre de curso, nombre de usuario y mail de todos los inscriptos a cursos que se hayan estrenado en el año 2020.
SELECT C.nombre, U.nombreUsuario, DAT.Email, C.Estreno from Cursos as C
inner join Inscripciones as I
ON C.ID=I.IDCurso
Inner join Usuarios as U
ON I.IDUsuario=U.ID
Inner join Datos_Personales as DAT
ON U.ID=DAT.ID
where year (C.Estreno)=2020

-- 7 Listado con nombre de curso, nombre de usuario, apellidos y nombres, fecha de inscripción, costo de inscripción, fecha de pago e importe de pago. Sólo listar información de aquellos que hayan pagado.
SELECT C.nombre, U.nombreUsuario, DAT.apellidos +DAT.nombres as NombreyApellido, I.Fecha as FechaInscripcion, I.costo as CostoInscripcion, P.Fecha as FechaPago, P.importe as ImportePago from Cursos as C
inner join Inscripciones as I
ON c.ID=i.IDCurso
inner join Pagos as P
on I.ID = P.IDInscripcion
inner join Usuarios as U
on I.IDUsuario = U.ID
inner join Datos_Personales as DAT
on U.ID= DAT.ID
order by p.Importe asc

-- 8 Listado con nombre y apellidos, genero, fecha de nacimiento, mail, nombre del curso y fecha de certificación de todos aquellos usuarios que se hayan certificado.
SELECT DAT.Nombres +DAT.Apellidos as NombreyApellido, DAT.Genero, DAT.Nacimiento, DAT.email, C.Nombre, CT.Fecha from Cursos as C
inner join Inscripciones as I
ON C.ID=I.IDCurso
inner join Certificaciones as CT
ON I.ID= CT.IDInscripcion
inner join Usuarios as U
ON U.ID= I.IDUsuario
inner join Datos_Personales as DAT
ON U.ID=DAT.ID


-- 9 Listado de cursos con nombre, costo de cursado y certificación, costo total (cursado + certificación) con 10% de todos los cursos de nivel Principiante.
SELECT top (10) PERCENT C.Nombre,CostoCurso, C.CostoCertificacion, (C.CostoCurso+ C.CostoCertificacion) as CostoTotal from Cursos as C
join Niveles AS N
ON C.IDNivel=N.ID
where N.Nombre like 'Principiante'
--gROUP BY C.Nombre, c.CostoCurso,c.CostoCertificacion


-- 10 Listado con nombre y apellido y mail de todos los instructores. Sin repetir.
SELECT DISTINCT DAT.nombres+DAT.apellidos as NombreyApellido, DAT.email from Datos_Personales as DAT
inner join Usuarios as U
ON DAT.ID=U.ID
inner join Instructores_x_Curso as IXC
on U.ID=IXC.IDUsuario


-- 11 Listado con nombre y apellido de todos los usuarios que hayan cursado algún curso cuya categoría sea 'Historia'.
SELECT DAT.Nombres+ DAT.apellidos as NombreyApellido from Datos_Personales AS DAT
INNER JOIN Usuarios as U
ON DAT.ID= U.ID
INNER JOIN Inscripciones AS I
ON U.ID= I.IDUsuario
INNER JOIN CURSOS AS C
ON I.IDCurso=C.ID
inner join Categorias_x_Curso as CXC
ON C.ID=CXC.IDCurso
inner join Categorias as CAT
ON CXC.IDCategoria=CAT.ID
WHERE CAT.Nombre='HISTORIA'

-- (12) Listado con nombre de idioma, código de curso y código de tipo de idioma. Listar todos los idiomas indistintamente si no tiene cursos relacionados.
SELECT I.nombre, CXI.IDcurso, CXI.IDidioma FROM Idiomas as I
LEFT JOIN Idiomas_x_Curso as CXI
ON I.ID=CXI.IDIdioma

-- 13 Listado con nombre de idioma de todos los idiomas que no tienen cursos relacionados.
SELECT I.nombre from Idiomas as I


-- 14 Listado con nombres de idioma que figuren como audio de algún curso. Sin repeticiones.
SELECT DISTINCT I.Nombre From Cursos as C
Inner join Idiomas_x_Curso as IXC
On C.ID= IXC.IDCurso
Inner Join Idiomas as I
On IXC.IDIdioma=I.ID


-- (15) Listado con nombres y apellidos de todos los usuarios y el nombre del país en el que nacieron. Listar todos los países indistintamente si no tiene usuarios relacionados.

Select DAT.nombres+DAT.apellidos as NombresyApellidos, P.nombre From Datos_Personales as DAT
Right Join Paises as P
On P.ID=DAT.IDPais


-- 16 Listado con nombre de curso, fecha de estreno y nombres de usuario de todos los inscriptos. Listar todos los nombres de usuario indistintamente si no se inscribieron a ningún curso.
SELECT C.Nombre, C.Estreno, U.NombreUsuario from Cursos as C
Inner Join Inscripciones as I
ON C.ID= I.IDCurso
Right Join Usuarios as U
On I.IDUsuario=U.ID


-- 17 Listado con nombre de usuario, apellido, nombres, género, fecha de nacimiento y mail de todos los usuarios que no cursaron ningún curso.
SELECT DISTINCT U.NombreUsuario, DAT.apellidos, DAT.nombres, DAT.genero, DAT.nacimiento, DAT.email from Cursos as C
inner join Inscripciones as I
ON C.ID = I.IDCurso
Right Join Usuarios as U
ON  U.ID= I.IDUsuario 
inner join Datos_Personales as DAT
ON U.ID = DAT.ID
where I.ID is NULL

-- 18 Listado con nombre y apellido, nombre del curso, puntaje otorgado y texto de la reseña. Sólo de aquellos usuarios que hayan realizado una reseña inapropiada.
SELECT DAT.nombres+DAT.apellidos as NombreyApellido, C.Nombre, R.puntaje, R.Observaciones from Cursos as C
inner join Inscripciones as I
ON C.ID=I.IDCurso
inner join Usuarios as U
ON U.ID=I.IDUsuario
inner join Datos_Personales as DAT
ON U.ID=DAT.ID
Left join Reseñas as R
ON R.IDInscripcion=I.ID
where R.Inapropiada=1

-- 19 Listado con nombre del curso, costo de cursado, costo de certificación, nombre del idioma y nombre del tipo de idioma de todos los cursos cuya fecha de estreno haya sido antes del año actual. 
--Ordenado por nombre del curso y luego por nombre de tipo de idioma. Ambos ascendentemente.
SELECT C.nombre, C.CostoCurso, C.CostoCertificacion, I.Nombre, TI.nombre as NombreTipoIdioma from Cursos as C
inner join Idiomas_x_Curso as IXC
ON IXC.IDCurso = C.ID
inner join Idiomas as I
ON IXC.IDIdioma = I.ID
inner join TiposIdioma as TI
ON IXC.IDTipo = TI.ID
where year (C.Estreno) <2020
Order by C.Nombre, NombreTipoIdioma asc


-- 20 Listado con nombre del curso y todos los importes de los pagos relacionados.
Select C.nombre, P.Importe From Cursos as C
Inner join Inscripciones as I
On C.ID = I.IDCurso
Inner Join Pagos as P
On I.ID = P.IDInscripcion

-- 21 Listado con nombre de curso, costo de cursado y una leyenda que indique "Costoso" si el costo de cursado es mayor a $ 15000, 
--"Accesible" si el costo de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y $2499 y "Gratis" si el costo es $0.

SELECT Nombre, CostoCurso,
 Case
When CostoCurso > 15000 then 'Costoso'
When CostoCurso >= 2500 and CostoCurso<=15000 then 'Accesible'
When CostoCurso >=1 and CostoCurso <=2499 then 'Barato'
Else 'Gratis'
End As Leyenda
From Cursos
