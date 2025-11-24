select * from USUARIO

select * from DETALLE_COMPRA where IdCompra = 1


select * from COMPRA where NumeroDocumento = '00001'

--tabla Rol--
/*
insert into ROL (Descripcion)
values ('EMPLEADO')

insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado) VALUES
('20','Edward Moreno','edward13@gmail.com','456',2,1)

*/

--tabla Permiso--
select p.IdRol,p.NombreMenu from PERMISO p
inner join ROL r on r.IdRol = p.IdRol
inner join USUARIO u on u.IdRol = r.IdRol
where u.IdUsuario = 2


select * from ROL
/*
insert into PERMISO (IdRol,NombreMenu)
values (1,'menuusuarios'),
(1,'menumantenedor'),
(1,'menuventas'),
(1,'menucompras'),
(1,'menuclientes'),
(1,'menuproveedores'),
(1,'menureportes'),
(1,'menuacercade')

insert into PERMISO (IdRol,NombreMenu) values 
(2,'menuventas'),
(2,'menucompras'),
(2,'menuclientes'),
(2,'menuproveedores'),
(2,'menuacercade')

*/

select IdCategoria,Descripcion,Estado from CATEGORIA

select u.IdUsuario,u.Documento,u.NombreCompleto,u.Correo,u.Clave,u.Estado,r.IdRol,r.Descripcion from usuario u
inner join ROL r on r.IdRol = u.IdRol
 
 update USUARIO set Estado = 0
 where IdUsuario = 2

 select * from CATEGORIA

 insert into CATEGORIA(Descripcion,Estado) values ('Útiles escolares',1)
 insert into CATEGORIA(Descripcion,Estado) values ('Papelería y escritura',1)
 insert into CATEGORIA(Descripcion,Estado) values ('Arte y manualidades',1)

 update PRODUCTO set Estado = 1

 select IdProducto,Codigo,Nombre,p.Descripcion,c.IdCategoria,c.Descripcion[DescripcionCategoria],Stock,PrecioCompra,PrecioVenta,p.Estado from PRODUCTO p
 INNER JOIN CATEGORIA c on c.IdCategoria = p.IdCategoria

 select * from PRODUCTO

 insert into PRODUCTO(Codigo,Nombre,Descripcion,IdCategoria) values
 ('101010','Cuaderno cuadriculado','100 hojas',1)

ALTER TABLE PRODUCTO
ALTER COLUMN PrecioVenta decimal(10,2) NULL;

select * from COMPRA where NumeroDocumento = '00001'

select c.IdCompra,
u.NombreCompleto,
pr.Documento, pr.RazonSocial,
c.TipoDocumento,c.NumeroDocumento,c.MontoTotal,CONVERT(char(10),c.FechaRegistro,103)[FechaRegistro]
from COMPRA c
inner join USUARIO u on u.IdUsuario = c.IdUsuario
inner join PROVEEDOR pr on pr.IdProveedor = c.IdProveedor
where c.NumeroDocumento = '00001'

select p.Nombre,dc.PrecioCompra,dc.Cantidad,dc.MontoTotal
from DETALLE_COMPRA dc
inner join PRODUCTO p on p.IdProducto = dc.IdProducto
where dc.IdCompra = 1


select * from PERMISO

SELECT * FROM PRODUCTO
select * from VENTA where NumeroDocumento = '00001'
select * from DETALLE_VENTA where IdVenta = 1

select v.IdVenta,u.NombreCompleto,
v.DocumentoCliente,v.NombreCliente,
v.TipoDocumento,v.NumeroDocumento,
v.MontoPago,v.MontoCambio,v.MontoTotal,
CONVERT(char(10),v.FechaRegistro,103)[FechaRegistro]
from VENTA v
inner join USUARIO u on u.IdUsuario = v.IdUsuario
where v.NumeroDocumento = '00001'

select p.Nombre,dv.PrecioVenta,dv.Cantidad,dv.SubTotal
from DETALLE_VENTA dv
inner join PRODUCTO p on p.IdProducto = dv.IdProducto
where dv.IdVenta = 1
