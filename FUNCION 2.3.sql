-- (1)  Listado con la cantidad de cursos.
Select count (*) as CantidadCursos From Cursos

-- 2  Listado con la cantidad de usuarios.
Select count (*) as CantidadUsuarios From Usuarios

-- (3)  Listado con el promedio de costo de certificación de los cursos.
Select AVG (C.costocertificacion) as PromCostoCertificacion From Cursos as C

-- 4  Listado con el promedio general de calificación de reseñas.
Select AVG (R.puntaje) as PromCalificacionRes From Reseñas as R

-- (5)  Listado con la fecha de estreno de curso más antigua.
Select top 1 C.Estreno From Cursos as C
Order by Estreno asc

Select min (C.Estreno) as EstrenoMasAntiguo From Cursos as C

-- 6  Listado con el costo de certificación menos costoso.
Select min (C.costoCertificacion) as MenorCostoCertificacion From Cursos as C

-- (7)  Listado con el costo total de todos los cursos.
Select sum (C.CostoCurso) as CostoTotalCursos From Cursos as C

-- 8  Listado con la suma total de todos los pagos.
Select sum (P.importe) as SumaTotalPagos From Pagos as P

-- 9  Listado con la cantidad de cursos de nivel principiante.
Select Count (*) as CantCursosPrincipiante From Cursos as C
inner Join Niveles as N
On C.IDNivel=N.ID
Where  N.Nombre like 'Principiante'

-- 10  Listado con la suma total de todos los pagos realizados en 2019.
Select sum (P.Importe) as SumaPagos2019 From Pagos as P
Where year (P.Fecha) = 2019

-- (11)  Listado con la cantidad de usuarios que son instructores.

Select count (distinct IDUsuario) as UsuariosDistintos
from Instructores_x_Curso


-- Listado de usuarios distintos de Instructores_x_curso
Select distinct IDUsuario From Instructores_x_Curso


-- 12  Listado con la cantidad de usuarios distintos que se hayan certificado.
Select count (distinct IDUsuario) as UsuariosDistintos From Usuarios as U
Inner Join Inscripciones as I
On U.ID=I.IDUsuario
Inner Join Certificaciones as C
On I.ID=C.IDInscripcion


-- (13)  Listado con el nombre del país y la cantidad de usuarios de cada país.
Select  P.Nombre, count (DAT.ID) as UsuarioPais From Paises as P
Left Join Datos_Personales as DAT
On P.ID=DAT.IDPais 
Group by P.Nombre
Order By 2 desc

-- (14)  Listado con el apellido y nombres del usuario y el importe más costoso abonado como pago.
--Sólo listar aquellos que hayan abonado más de $7500.
Select DAT.Nombres+ DAT.Apellidos as NombreyApellido, max (P.importe) From Datos_Personales as DAT
Inner Join Usuarios as U
On DAT.ID = U.ID
Inner Join Inscripciones as I
On U.ID=I.IDUsuario
Inner Join Pagos as P
On I.ID=P.IDInscripcion
Group by DAT.Nombres, DAT.Apellidos
Having max (P.Importe)>7500


-- 15  Listado con el apellido y nombres de usuario y el importe más costoso de curso al cual se haya inscripto.
Select DAT.Apellidos, U.NombreUsuario, max (C.costocurso) From Datos_Personales as DAT
Inner Join Usuarios as U
On DAT.ID= U.ID
Inner Join Inscripciones as I
On U.ID= I.IDUsuario
Inner Join Cursos as C
On I.IDCurso= C.ID
Group by DAT.Apellidos, U.NombreUsuario

-- 16  Listado con el nombre del curso, nombre del nivel, cantidad total de clases y duración total del curso en minutos.
Select C.Nombre, N.Nombre as Nivel, count (CS.ID) as CantTotalClases, sum (CS.duracion) as DuracionTotalMinutos From cursos as C
Inner join Niveles as N
On C.IDNivel= N.ID
Inner Join Clases as CS
On CS.IDCurso= C.ID
Group by C.Nombre, N.Nombre

-- 17  Listado con el nombre del curso y cantidad de contenidos registrados. 
--Sólo listar aquellos cursos que tengan más de 10 contenidos registrados.

Select C.Nombre, count (CON.ID) as ContenidoRegistrado From Cursos as C
Inner Join Clases as CS
On C.ID= CS.IDCurso
Inner Join Contenidos as CON
On CS.ID= CON.IDClase
Group by C.Nombre
Having count (CON.ID)>10

-- 18  Listado con nombre del curso, nombre del idioma y cantidad de tipos de idiomas.

Select C.Nombre, I.Nombre, count (TI.ID) as CantidadTipoIdimoas From Cursos as C
Inner Join Idiomas_x_Curso as IXC
On C.ID= IXC.IDCurso
Inner Join Idiomas as I
On IXC.IDIdioma= I.ID
Inner Join TiposIdioma as TI
On IXC.IDTipo=TI.ID
Group by C.Nombre,I.Nombre

-- 19  Listado con el nombre del curso y cantidad de idiomas distintos disponibles.

Select C.nombre, count (I.ID) as CantIdiomasDistintos From Cursos as C
Inner Join Idiomas_x_Curso as IXC
On C.ID= IXC.IDCurso
Inner Join Idiomas as I
On IXC.IDCurso = I.ID
Group by C.Nombre

-- 20  Listado de categorías de curso y cantidad de cursos asociadas a cada categoría. Sólo mostrar las categorías con más de 5 cursos.
Select CAT.Nombre, count (CXC.IDCategoria) as CantCursosCat From Categorias as CAT
Inner Join Categorias_x_Curso as CXC
On CAT.ID= CXC.IDCategoria


-- 21  Listado con tipos de contenido y la cantidad de contenidos asociados a cada tipo. Mostrar aquellos tipos que 
--no hayan registrado contenidos con cantidad 0.
Select TC.ID, count (C.ID) From TiposContenido as TC
Inner Join Contenidos as C
On TC.ID= C.IDTipo
Group by TC.ID
Having count (C.ID) !=0


-- 22  Listado con Nombre del curso, nivel, año de estreno y el total recaudado en concepto de inscripciones. 
--Listar aquellos cursos sin inscripciones con total igual a $0.
Select C.Nombre, C.IDNivel, C.estreno, sum (P.Importe) From cursos as c
Inner join Inscripciones as I
On C.ID= I.IDCurso
Inner Join Pagos as P
On I.ID= P.IDInscripcion
Group by C.Nombre, C.IDNivel, C.estreno
Having sum (P.importe) !=0

-- 23  Listado con Nombre del curso, costo de cursado y certificación y cantidad de usuarios distintos 
--inscriptos cuyo costo de cursado sea menor a $10000 y cuya cantidad de usuarios inscriptos sea menor a 5. 
--Listar aquellos cursos sin inscripciones con cantidad 0.

Select C.Nombre, C.costocurso, C.costocertificacion, count (distinct I.IDUsuario)as CantInscrip From Cursos as C
Inner Join Inscripciones as I
On C.ID= I.IDCurso
Where C.costocurso <10000
Group by C.Nombre, C.costocurso, C.costocertificacion
having count (I.IDUsuario) <5 

-- 24  Listado con Nombre del curso, fecha de estreno y nombre del nivel del curso que más recaudó en concepto de certificaciones.
Select Top 1 C.Nombre, C.Estreno, N.Nombre as NombreNivel, sum (C.costocertificacion) as Recaudacion From Cursos as C
Inner Join Niveles as N
On C.IDNivel= N.ID 
Group by C.Nombre, C.Estreno, N.Nombre


-- 25  Listado con Nombre del idioma del idioma más utilizado como subtítulo.
Select top 1 max (I.Nombre) as IdiomaMasUtilizado From Idiomas as I
Inner join Idiomas_x_Curso as IXC
On I.ID= IXC.IDIdioma
Inner Join TiposIdioma as TI
On IXC.IDTipo= TI.ID
Group by I.Nombre

-- 26  Listado con Nombre del curso y promedio de puntaje de reseñas apropiadas.
Select C.Nombre, AVG (R.puntaje) as Promedio From Cursos as C
Inner Join Inscripciones as I
On C.ID= I.IDCurso
Inner Join Reseñas as R
On I.ID= R.IDInscripcion
Group by C.Nombre


-- 27  Listado con Nombre de usuario y la cantidad de reseñas inapropiadas que registró.
Select U.NombreUsuario, count (R.Inapropiada) as ReseInapropiada From Usuarios as U
Inner Join Inscripciones as I
On U.ID=I.IDCurso
Inner Join Reseñas as R
On I.ID = R.IDInscripcion
Group by U.NombreUsuario


-- 28  Listado con Nombre del curso, nombre y apellidos de usuarios y la cantidad de veces que dicho usuario realizó dicho curso.
-- No mostrar cursos y usuarios que contabilicen cero.

Select C.Nombre as NombreCurso, DAT.Nombres+DAT.Apellidos as NombreyApellido, count (U.ID) as UsuarioCurso From Cursos as C
Inner Join Inscripciones as I
On C.ID = I.IDCurso
Inner Join Usuarios as U
On I.IDUsuario= U.ID
Inner Join Datos_Personales as DAT
On U.ID= DAT.ID
Group by C.Nombre, DAT.Nombres+DAT.Apellidos


-- 29  Listado con Apellidos y nombres, mail y duración total en concepto de clases de cursos a los que se haya inscripto.
-- Sólo listar información de aquellos registros cuya duración total supere los 400 minutos.

Select DAT.Apellidos+DAT.Nombres as ApellidoYNombre, DAT.email, Sum (CC.duracion) as DuracionTotal From Datos_Personales as DAT
Inner Join Usuarios as U
On DAT.ID = U.ID
Join Inscripciones as I
On U.ID = I.IDUsuario
Join Cursos as C
On I.IDCurso = C.ID
Join Clases as CC
On C.ID= CC.IDCurso
Group by DAT.Apellidos+DAT.Nombres, DAT.email
Having Sum (CC.Duracion) > 400

-- 30  Listado con nombre del curso y recaudación total. La recaudación total consiste en la sumatoria de costos de inscripción y
--de certificación. Listarlos ordenados de mayor a menor por recaudación.

Select C.Nombre, sum (C.costocurso+C.costocertificacion) as RecaudacionTotal From Cursos as C
Group by C.Nombre
Order by RecaudacionTotal desc


