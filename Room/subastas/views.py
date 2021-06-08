from django.db import connection
from django.shortcuts import render
from django.urls import reverse
from django.http import HttpResponseRedirect
from django.contrib.auth.decorators import login_required

from datetime import datetime

# Create your views here.

from subastas.models import Artista, Sala, Obra, Puja, Comprador, Vendedor

def index(request):
    salas = Sala.objects.all()
    return render(request,'subastas/index.html', {
        "artistas": Artista.objects.all(),
        "salas": salas
    })

def sala(request,sala_id):
    sala = Sala.objects.get(pk=sala_id)
    pujas = Puja.objects.filter(obra=sala.articulo)
    compradores = Comprador.objects.all()
    return render(request,'subastas/sala.html',{
        "sala": sala,
        "pujas": pujas,
        "compradores": compradores
    })

def artista_info(request,artista_id):

    owner_obj = Artista.objects.get(pk=artista_id)
    context = {
        "artista": owner_obj
    }

    return render(request,"subastas/artista_info.html",context)

# def registro(request):
#     if request.method == "POST":
#         nombre = request.POST["nombre"]
#         apellido_materno = request.POST["apellido_materno"]
#         apellido_paterno = request.POST["apellido_paterno"]
#         correo = request.POST["correo"]
#         celular = request.POST["celular"]
#         direccion = request.POST["direccion"]
#         colonia = request.POST["colonia"]
#         cp_zip = request.POST["cp_zip"]

#         with connection.cursor() as cursor:
#             cursor.callproc('aniadir_usuario', [id, nombre,apellido_paterno,apellido_materno,correo,celular,direccion,colonia,cp_zip])

#         return render(request,"subastas/index.html")

@login_required
def bid(request,sala_id):
    sala = Sala.objects.get(pk=sala_id)
    # pujas = Puja.objects.all()
    # ultima = pujas.latest('id')
    
    if request.method == "POST":
        obra_sala = sala.articulo
        cliente_sala =int(request.POST["cliente"])
        comprador=Comprador.objects.get(pk=cliente_sala)
        hora_puja = datetime.now()
        monto_puja = int(request.POST["monto"])  
        pujas = Puja.objects.filter(obra=obra_sala.id)
        ultima_puja = pujas.last()
        if(monto_puja<=ultima_puja.monto):
            return HttpResponseRedirect(reverse('sala', args=(sala.id,)))
        Puja.objects.create(obra=obra_sala,cliente=comprador,hora=hora_puja,monto=monto_puja)

        # with connection.cursor() as cursor:
        #     cursor.callproc('inserta_puja', [ultima.id+1,hora,monto,cliente,obra])  
        #     #cursor.execute("CALL aniadir_puja('%s',%s,%s,%s,%s)",[ultima.id+1,hora,monto,obra,cliente])
    
    return HttpResponseRedirect(reverse('sala', args=(sala.id,)))

def corrientes(request):
    with connection.cursor() as cursor:
        cursor.callproc(' muestra_corriente_de_obras')
        corrientes=cursor.fetchall()
        return render(request,"subastas/corrientes.html",{
            "corrientes": corrientes
        })

@login_required
def crear_sala(request):
    obras=Obra.objects.all()
    sala=Sala.objects.last()
    if request.method == "POST":
        obra = request.POST["obra"]
        articulo=Obra.objects.get(nombre=obra)
        hora_sala = datetime.now()
        duenio = Comprador.objects.get(pk=articulo.duenio.id)
        costo_inicial = request.POST["costo_inicial"]
        fecha_cierre= request.POST["fecha_cierre"]
        hora_puja = datetime.now()
        Puja.objects.create(obra=articulo,cliente=duenio,hora=hora_puja,monto=costo_inicial)
        Sala.objects.create(articulo=articulo,apertura=hora_sala,costo_inicial=costo_inicial,fecha=fecha_cierre)
        return HttpResponseRedirect(reverse('index'))
    
    return render(request,"subastas/crear_sala.html",{
        "obras":obras,
        })

@login_required
def crear_obra(request):
    artistas = Artista.objects.all()
    duenios = Vendedor.objects.all()
    if request.method == "POST":
        nombre = request.POST["nombre"]
        artista = request.POST["artista"]
        artista_obra = Artista.objects.get(nombre=artista)
        duenio = request.POST["duenio"]
        duenio_obra = Vendedor.objects.get(pk=duenio)
        Obra.objects.create(nombre=nombre, artista=artista_obra,duenio=duenio_obra)
        return HttpResponseRedirect(reverse('crear_sala'))
    
    return render(request,"subastas/crear_obra.html",{
        "artistas": artistas,
        "duenios":duenios,
    })

@login_required
def crear_artista(request):
    if request.method == "POST":
        nombre = request.POST["nombre"]
        apellidos = request.POST["apellidos"]
        nacionalidad = request.POST["nacionalidad"]
        corriente = request.POST["corriente"]
        Artista.objects.create(nombre=nombre,apellidos=apellidos,nacionalidad=nacionalidad,corriente=corriente)
        return HttpResponseRedirect(reverse('crear_obra'))

    return render(request, "subastas/crear_artista.html")
