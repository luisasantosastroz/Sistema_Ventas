create table NEGOCIO(
IdNegocio int primary key,
Nombre varchar(60),
RUC varchar(60),
Direccion varchar(60),
Logo varbinary(max) NULL
)

SELECT * FROM NEGOCIO

SELECT * FROM PRODUCTO

select IdNegocio,Nombre,RUC,Direccion from NEGOCIO where IdNegocio = 1;

INSERT INTO NEGOCIO (IdNegocio,Nombre,RUC,Direccion) VALUES (1,'Papelería Mundo Escolar','206589','Cra 6 # 14-145')

update NEGOCIO set Nombre = @nombre, RUC = @ruc, Direccion = @direccion where IdNegocio = 1