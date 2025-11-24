

CREATE PROC SP_REGISTRARUSUARIO(
@Documento varchar (50),
@NombreCompleto varchar (50),
@Correo varchar (50),
@Clave varchar (50),
@IdRol int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar (500) output
)
as
begin

set @IdUsuarioResultado = 0
set @Mensaje = ''

if not exists(select * from USUARIO where Documento = @Documento)
begin
insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado) values
(@Documento,@NombreCompleto,@Correo,@Clave,@IdRol,@Estado)

set @IdUsuarioResultado = SCOPE_IDENTITY()


end
else
set @Mensaje = 'No se puede repetir el documento para más de un usuario'

end

go

CREATE PROC SP_EDITARUSUARIO(
@Idusuario int,
@Documento varchar (50),
@NombreCompleto varchar (50),
@Correo varchar (50),
@Clave varchar (50),
@IdRol int,
@Estado bit,
@Respuesta bit output,
@Mensaje varchar (500) output
)
as
begin

set @Respuesta = 0
set @Mensaje = ''

if not exists(select * from USUARIO where Documento = @Documento and IdUsuario != @Idusuario)
begin
update USUARIO set
Documento = @Documento,
NombreCompleto = @NombreCompleto,
Correo = @Correo,
Clave = @Clave,
IdRol = @IdRol,
Estado = @Estado
where IdUsuario = @Idusuario

set @Respuesta = 1


end
else
set @Mensaje = 'No se puede repetir el documento para más de un usuario'

end

go

CREATE PROC SP_ELIMINARUSUARIO(
@Idusuario int,
@Respuesta bit output,
@Mensaje varchar (500) output
)
as
begin

set @Respuesta = 0
set @Mensaje = ''
declare @pasoreglas bit = 1

IF exists (SELECT * FROM COMPRA C
inner join USUARIO U ON U.IdUsuario = C.IdUsuario
WHERE U.IdUsuario = @Idusuario
)
BEGIN
	set @pasoreglas = 0
	set @Respuesta = 0
	set @Mensaje = @Mensaje + 'No se puede eliminar porque el usuario se encuentra relacionado a una COMPRA\n' 
END

IF exists (SELECT * FROM VENTA V
inner join USUARIO U ON U.IdUsuario = V.IdUsuario
WHERE U.IdUsuario = @Idusuario
)
BEGIN
	set @pasoreglas = 0
	set @Respuesta = 0
	set @Mensaje = @Mensaje + 'No se puede eliminar porque el usuario se encuentra relacionado a una VENTA\n' 
END

if(@pasoreglas = 1)
begin

delete from USUARIO where IdUsuario = @Idusuario
set @Respuesta = 1

end


end

go

/* ----------- PROCEDIMIENTOS PARA CATEGORIA -------------------------*/
--PROCEDIMIENTO PARA GUARDAR CATEGORIA--
CREATE PROC SP_RegistrarCategoria(
@Descripcion varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
SET @Resultado = 0
IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
begin
insert into CATEGORIA(Descripcion,Estado) values (@Descripcion,@Estado)
set @Resultado = SCOPE_IDENTITY()
end
ELSE
set @Mensaje = 'No se puede repetir la descripción de una categoría'
end

go

----PROCEDIMIENTO PARA MODIFICAR CATEGORIA----
create procedure sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(50),
@Estado bit,
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
SET @Resultado = 1
IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion and IdCategoria != @IdCategoria)
update CATEGORIA set
Descripcion = @Descripcion,
Estado = @Estado
where IdCategoria = @IdCategoria
ELSE
begin
SET @Resultado = 0
set @Mensaje = 'No se puede repetir la descripción de una categoría'
end

end

go

----PROCEDIMIENTO PARA ELIMINAR CATEGORIA----
	create procedure sp_EliminarCategoria(
	@IdCategoria int,
	@Resultado bit output,
	@Mensaje varchar(500) output
	)
	as
	begin
	SET @Resultado = 1
	IF NOT EXISTS (
	SELECT * FROM CATEGORIA c
	inner join PRODUCTO p on p.IdCategoria = c.IdCategoria
	where c.IdCategoria = @IdCategoria
	)
	begin
		delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
	end
	ELSE
	begin
	SET @Resultado = 0
	set @Mensaje = 'La categoría se encuentra relacionada a un producto'
	end

	end

	select * from PRODUCTO

/* ----------- PROCEDIMIENTOS PARA PRODUCTO -------------------------*/
CREATE PROC sp_RegistrarProducto(
@Codigo varchar(20),
@Nombre varchar(30),
@Descripcion varchar(30),
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
SET @Resultado = 0
IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Codigo = @Codigo)
begin
insert into PRODUCTO(Codigo,Nombre,Descripcion,IdCategoria,Estado) values (@Codigo,@Nombre,@Descripcion,@IdCategoria,@Estado)
set @Resultado = SCOPE_IDENTITY()
end
ELSE
SET @Mensaje = 'Ya existe un producto con el mismo código'
end 

GO

create procedure sp_ModificarProducto(
@IdProducto int,
@Codigo varchar(20),
@Nombre varchar(30),
@Descripcion varchar(30),
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
SET @Resultado = 1
IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Codigo = @Codigo and IdProducto != @IdProducto)
update PRODUCTO set
Codigo = @Codigo,
Nombre = @Nombre,
Descripcion = @Descripcion,
IdCategoria = @IdCategoria,
Estado = @Estado
where IdProducto = @IdProducto
ELSE
begin
 SET @Resultado = 0
 SET @Mensaje = 'Ya existe un producto con el mismo código'
 end
 end

 go

 create PROC SP_EliminarProducto(
 @IdProducto int,
 @Respuesta bit output,
 @Mensaje varchar(500) output
 )
 as
 begin
 set @Respuesta = 0
 set @Mensaje = ''
 declare @pasoreglas bit = 1

 IF EXISTS (SELECT * FROM DETALLE_COMPRA dc
 INNER JOIN PRODUCTO p ON p.IdProducto = dc.IdProducto
 WHERE p.IdProducto = @IdProducto)
 BEGIN
 set @pasoreglas = 0
 set @Respuesta = 0
 set @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado a una COMPRA\n'
 END

 IF EXISTS (SELECT * FROM DETALLE_VENTA dv
 INNER JOIN PRODUCTO p ON p.IdProducto = dv.IdProducto
 WHERE p.IdProducto = @IdProducto
 )
 BEGIN
 set @pasoreglas = 0
 set @Respuesta = 0
 set @Mensaje = @Mensaje + 'No se puede eliminar porque se encuentra relacionado a una VENTA\n'
 END

 if(@pasoreglas = 1)
 begin
 delete from PRODUCTO where IdProducto = @IdProducto
 set @Respuesta = 1
 end

 end
 
 go

 /* ----------- PROCEDIMIENTOS PARA CLIENTE -------------------------*/
 CREATE PROC sp_RegistrarCliente(
 @Documento varchar(50),
 @NombreCompleto varchar(50),
 @Correo varchar(50),
 @Telefono varchar(50),
 @Estado bit,
 @Resultado int output,
 @Mensaje varchar(500) output
 )as
 begin
 SET @Resultado = 0
 DECLARE @IDPERSONA INT
 IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Documento = @Documento)
 begin
 insert into CLIENTE(Documento,NombreCompleto,Correo,Telefono,Estado) values (
 @Documento,@NombreCompleto,@Correo,@Telefono,@Estado)

 set @Resultado = SCOPE_IDENTITY()
 end
 else
 set @Mensaje = 'El numero de documento ya existe'
 end
 go

 create PROC sp_ModificarCliente(
 @IdCliente int,
 @Documento varchar(50),
 @NombreCompleto varchar(50),
 @Correo varchar(50),
 @Telefono varchar(50),
 @Estado bit,
 @Resultado bit output,
 @Mensaje varchar(500) output
 )as
 begin
 SET @Resultado = 1
 DECLARE @IDPERSONA INT
 IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Documento = @Documento and IdCliente != @IdCliente)
 begin
 update CLIENTE set
 Documento = @Documento,
 NombreCompleto = @NombreCompleto,
 Correo = @Correo,
 Telefono = @Telefono,
 Estado = @Estado
 where IdCliente = @IdCliente
 end
 else
 begin
 SET @Resultado = 0
 set @Mensaje = 'El numero de documento ya existe'
 end
 end

 GO

  /* ----------- PROCEDIMIENTOS PARA CLIENTE -------------------------*/

 create PROC sp_RegistrarProveedor(
 @Documento varchar(50),
 @RazonSocial varchar(50),
 @Correo varchar(50),
 @Telefono varchar(50),
 @Estado bit,
 @Resultado int output,
 @Mensaje varchar(500) output
 )as
 begin
 SET @Resultado = 0
 DECLARE @IDPERSONA INT
 IF NOT EXISTS (SELECT * FROM PROVEEDOR WHERE Documento = @Documento)
 begin
 insert into PROVEEDOR(Documento,RazonSocial,Correo,Telefono,Estado) values (
 @Documento,@RazonSocial,@Correo,@Telefono,@Estado)

 set @Resultado = SCOPE_IDENTITY()
 end
 else
 set @Mensaje = 'El numero de documento ya existe'
 end

 GO

 CREATE PROC sp_ModificarProveedor(
 @IdProveedor int,
 @Documento varchar(50),
 @RazonSocial varchar(50),
 @Correo varchar(50),
 @Telefono varchar(50),
 @Estado bit,
 @Resultado bit output,
 @Mensaje varchar(500) output
 )as
 begin
 SET @Resultado = 1
 DECLARE @IDPERSONA INT
 IF NOT EXISTS (SELECT * FROM PROVEEDOR WHERE Documento = @Documento and IdProveedor != @IdProveedor)
 begin
 update PROVEEDOR set
 Documento = @Documento,
 RazonSocial = @RazonSocial,
 Correo = @Correo,
 Telefono = @Telefono,
 Estado = @Estado
 where IdProveedor = @IdProveedor
 end
 else
 begin
 SET @Resultado = 0
 set @Mensaje = 'El numero de documento ya existe'
 end
 end

 go

 create procedure sp_EliminaProveedor(
 @IdProveedor int,
 @Resultado bit output,
 @Mensaje varchar(500) output
 )
 as
 begin
 SET @Resultado = 1
 IF NOT EXISTS (
 select * from PROVEEDOR p
 inner join COMPRA c on p.IdProveedor = c.IdProveedor
 where p.IdProveedor = @IdProveedor
 )
 begin
 delete top(1) from PROVEEDOR where IdProveedor = @IdProveedor
 end
 ELSE
 begin 
 SET @Resultado = 0
 SET @Mensaje = 'El proveedor se encuentra relacionado a una compra'
 end
 end

 GO

 /* PROCESOS PARA REGISTRAR UNA COMPRA */

 CREATE TYPE [dbo].[EDetalle_Compra] AS TABLE(
 [IdProducto] int NULL,
 [PrecioCompra] decimal(18,2) NULL,
 [PrecioVenta] decimal(18,2) NULL,
 [Cantidad] int NULL,
 [MontoTotal] decimal(18,2) NULL
 )

 go

 

 CREATE PROCEDURE sp_RegistrarCompra(
 @IdUsuario int,
 @IdProveedor int,
 @TipoDocumento varchar(500),
 @NumeroDocumento varchar(500),
 @MontoTotal decimal(18,2),
 @DetalleCompra [EDetalle_Compra] READONLY,
 @Resultado bit output,
 @Mensaje varchar(500) output
 )
 as
 begin

 begin try
 declare @idcompra int = 0
 set @Resultado = 1
 set @Mensaje = ''

	 begin transaction registro

	insert into COMPRA(IdUsuario,IdProveedor,TipoDocumento,NumeroDocumento,MontoTotal)
	values(@IdUsuario,@IdProveedor,@TipoDocumento,@NumeroDocumento,@MontoTotal)

	set @idcompra = SCOPE_IDENTITY()
	insert into DETALLE_COMPRA(IdCompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal)
	select @idcompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal from @DetalleCompra

	update p set p.Stock = p.Stock + dc.Cantidad,
	p.PrecioCompra = dc.PrecioCompra,
	p.PrecioVenta = dc.PrecioVenta
	from PRODUCTO p
	inner join @DetalleCompra dc on dc.IdProducto = p.IdProducto

	 commit transaction registro

 end try
 begin catch
	 set @Resultado = 0
	 set @Mensaje = ERROR_MESSAGE()
	 rollback  transaction registro
 end catch

 end

 go

 /* PROCESOS PARA REGISTRAR UNA VENTA */

 CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE(
 [IdProducto] int NULL,
 [PrecioVenta] decimal(18,2) NULL,
 [Cantidad] int NULL,
 [SubTotal] decimal(18,2) NULL
 )

 go

 CREATE PROCEDURE sp_RegistrarVenta(
 @IdUsuario int,
 @TipoDocumento varchar(500),
 @NumeroDocumento varchar(500),
 @DocumentoCliente varchar(500),
 @NombreCliente varchar(500),
 @MontoPago decimal(18,2),
 @MontoCambio decimal(18,2),
 @MontoTotal decimal(18,2),
 @DetalleVenta [EDetalle_Venta] READONLY,
 @Resultado bit output,
 @Mensaje varchar(500) output
 )
 as
 begin

 begin try
		 declare @idventa int = 0
		 set @Resultado = 1
		 set @Mensaje = ''

	 begin transaction registro

	insert into VENTA(IdUsuario,TipoDocumento,NumeroDocumento,DocumentoCliente,NombreCliente,MontoPago,MontoCambio,MontoTotal)
	values(@IdUsuario,@TipoDocumento,@NumeroDocumento,@DocumentoCliente,@NombreCliente,@MontoPago,@MontoCambio,@MontoTotal)

	set @idventa = SCOPE_IDENTITY()
	insert into DETALLE_VENTA(IdVenta,IdProducto,PrecioVenta,Cantidad,SubTotal)
	select @idventa,IdProducto,PrecioVenta,Cantidad,SubTotal from @DetalleVenta

	 commit transaction registro

 end try
 begin catch
	 set @Resultado = 0
	 set @Mensaje = ERROR_MESSAGE()
	 rollback  transaction registro
 end catch

 end

