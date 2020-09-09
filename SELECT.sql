
--Ejercicio


--1 Listado de todos los idiomas.
select * from Idiomas

--2 Listado de todos los cursos.
SELECT * FROM Cursos

--3 Listado con nombre, costo de inscripción, costo de certificación y fecha de estreno de todos los cursos.
SELECT nombre, CostoCurso, CostoCertificacion, estreno from Cursos

--4 Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea menor a $ 5000.
SELECT ID,nombre, CostoCurso,IDNivel from Cursos
where CostoCertificacion <5000

--5 Listado con ID, nombre, costo de inscripción e ID de nivel de todos los cursos cuyo costo de certificación sea mayor a $ 1200.
select ID, nombre, CostoCurso, IDNivel from Cursos
where CostoCertificacion > 1200

--6 Listado con nombre, número y duración de todas las clases del curso con ID número 6.
SELECT nombre,Numero, Duracion from Clases
where IDCurso=6

--7 Listado con nombre, número y duración de todas las clases del curso con ID número 10.
SELECT nombre, numero, duracion from clases
where IDCurso=10

--8 Listado con nombre y duración de todas las clases con ID número 4. Ordenado por duración de mayor a menor.
SELECT nombre, duracion from Clases
where IDCurso=4
order by Duracion Desc

--9 Listado con nombre, fecha de estreno, costo del curso, costo de certificación ordenados por fecha de estreno de manera creciente.
select Nombre,Estreno,CostoCurso,CostoCertificacion  from Cursos
order by estreno asc

-- 10 Listado con nombre, fecha de estreno y costo del curso de todos aquellos cuyo ID de nivel sea 1, 5, 9 o 10.
SELECT nombre, estreno, CostoCurso,IDNivel from Cursos
where IDNivel IN (1, 5,9,10)

--11 Listado con nombre, fecha de estreno y costo de cursado de los tres cursos más caros de certificar.
SELECT TOP 3 with ties nombre, estreno, costocurso from Cursos
order by CostoCertificacion asc

--12 Listado con nombre, duración y número de todas clases de los cursos con ID 2, 5 y 7. Ordenados por ID de Curso ascendente y luego por número de clase ascendente.
SELECT nombre, duracion, numero from Clases
where IDCurso IN (2,5,7)
Order by IDCurso ASC

--13 Listado con nombre y fecha de estreno de todos los cursos cuya fecha de estreno haya sido en el primer semestre del año 2019.
SELECT nombre, estreno from Cursos
where month (Estreno) <=6 and Year (Estreno)= 2019

--14 Listado de cursos cuya fecha de estreno haya sido en el año 2020.
SELECT * from Cursos
where year (Estreno) =2020 

--15 Listado de cursos cuya mes de estreno haya sido entre el 1 y el 4.
SELECT * from Cursos
where MONTH (Estreno) in (1,2,3,4)

--16 Listado de clases cuya duración se encuentre entre 15 y 90 minutos.
select * from Clases
where Duracion > 15 and Duracion <90

--17 Listado de contenidos cuyo tamaño supere los 5000MB y sean de tipo 4 o sean menores a 400MB y sean de tipo 1.
SELECT * from Contenidos
where (Tamaño > 5000 and IDTipo=4)or (Tamaño <400 and IDTipo=1)

--18 Listado de cursos que no posean ID de nivel.
SELECT Nombre, IDNivel from Cursos
where IDNivel is NULL

--19 Listado de cursos cuyo costo de certificación corresponda al 20% o más del costo del curso.
SELECT * from Cursos
where CostoCertificacion >= (CostoCurso*20)/100 

--20 Listado de costos de cursado de todos los cursos sin repetir y ordenados de mayor a menor.
SELECT DISTINCT CostoCurso from Cursos 
Order by CostoCurso desc

-- Extra Listado nombre, duracion y costo de curso de todos aquellos cursos cuyo id nivel no sea 1,5,9,10
SELECT max (Cl.duracion), c.Nombre,CostoCurso from Cursos as C
Inner Join Clases as Cl 
on C.ID = Cl.IDCurso
where IDNivel not in (1,5,9,10) 
group by c.nombre, c.CostoCurso,cl.Duracion














