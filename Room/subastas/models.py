from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Artista(models.Model):
    nombre = models.CharField(max_length=100)
    apellidos = models.CharField(max_length=255)
    nacionalidad = models.CharField(max_length=255)
    corriente = models.CharField(max_length=255)

    def __str__(self):
        return f" {self.id}: {self.nombre} {self.apellidos}"

class Usuario(models.Model):
    nombre = models.CharField(max_length=255)
    apellido_paterno = models.CharField(max_length=255)
    apellido_materno = models.CharField(max_length=255)
    correo = models.EmailField()
    celular = models.IntegerField()
    direccion = models.CharField(max_length=255)
    colonia = models.CharField(max_length=255)
    cp_zip = models.IntegerField()
    def __str__(self):
        return f" {self.id}: {self.nombre}, {self.correo}"

# on_delete, atributo que determina que pasara si se elimina el objeto al que se está referenciando

class Comprador(models.Model):
    # si se elimina un usuario, el comprador tambien se elimina
    usuario_comprador = models.OneToOneField(Usuario, on_delete=models.CASCADE, related_name="compradores")
    def __str__(self):
        return f"ID comprador:  {self.usuario_comprador}"


class Vendedor(models.Model):
    usuario_vendedor = models.OneToOneField(Usuario, on_delete=models.CASCADE, related_name="vendedores")
    def __str__(self):
        return f"ID vendedor:   {self.usuario_vendedor}"

class Obra(models.Model):
    nombre = models.CharField(max_length=255, default="Obra")
    artista = models.ForeignKey(Artista, on_delete=models.DO_NOTHING, related_name="personaje")
    duenio = models.ForeignKey(Vendedor, on_delete=models.CASCADE, related_name="propietario")
    def __str__(self):
        return f" {self.id} :  {self.nombre}, {self.artista}"

class Puja (models.Model):
    #foreignKey = One-to-Many (una obra puede tener muchas pujas)
    obra = models.ForeignKey(Obra, on_delete=models.CASCADE, related_name="pieza")
    #foreignKey = One-to_many (un cliente pude hacer muchas pujas)
    cliente = models.ForeignKey(Comprador,on_delete=models.CASCADE, related_name="pujador")
    hora = models.TimeField()
    monto = models.IntegerField()
    def __str__(self):
        return f" {self.id}: ${self.cliente} ${self.monto}.00 mxn , {self.obra}"

class Sala(models.Model):
    articulo = models.OneToOneField(Obra,on_delete=models.CASCADE, related_name="objeto")
    apertura = models.DateField()
    costo_inicial = models.IntegerField()
    fecha = models.DateTimeField()
    def __str__(self):
        return f" {self.id}: {self.articulo}"




