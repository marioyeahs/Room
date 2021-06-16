from django.db import connection
from django.http import HttpResponseRedirect
from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from django.urls import reverse
from django.contrib.auth.models import User
from datetime import datetime
import statistics

from subastas.models import Artista, Sala, Obra, Puja, Comprador, Vendedor

def index(request):
    salas = Sala.objects.all()
    return render(request,'subastas/index.html', {
        "artistas": Artista.objects.all(),
        "salas": salas
    })

def sala(request,sala_id):
    sala = Sala.objects.get(pk=sala_id)
    now = datetime.now()
    tiempo = now.time().hour #entero, hora actual en el servidor
    pujas = Puja.objects.filter(obra=sala.articulo)
    compradores = Comprador.objects.all()
    if (sala.fecha_cierre <= now.date() and sala.hora_cierre <= now.time()):
        mensaje = "Lo sentimos, la sala se ha cerrado",
        ultima_puja = Puja.objects.filter(obra=sala.articulo).last()
        return render(request,'subastas/sala.html',{
        "sala": sala,
        "pujas": pujas,
        "compradores": compradores,
        "mensaje":mensaje,
        "now":now,
        "ultima_puja": ultima_puja,
        })
    
    return render(request,'subastas/sala.html',{
        "sala": sala,
        "pujas": pujas,
        "compradores": compradores,
    })

def artista_info(request,artista_id):

    owner_obj = Artista.objects.get(pk=artista_id)
    context = {
        "artista": owner_obj
    }

    return render(request,"subastas/artista_info.html",context)


@login_required
def bid(request,sala_id):
    sala = Sala.objects.get(pk=sala_id)
    # pujas = Puja.objects.all()
    # ultima = pujas.latest('id')
    
    if request.method == "POST":
        obra_sala = sala.articulo
        comprador=Comprador.objects.get(usuario_comprador=request.user)
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

    vendedor = Vendedor.objects.get(usuario_vendedor=request.user)
    obras=Obra.objects.filter(duenio=vendedor)
    # sala=Sala.objects.last()
    if request.method == "POST":
        articulo = request.POST["obra"]
        obra=Obra.objects.get(nombre=articulo)
        hora_sala = datetime.now()
        duenio = Comprador.objects.get(usuario_comprador=request.user)
        costo_inicial = request.POST["costo_inicial"]
        fecha_cierre= request.POST["fecha_cierre"]
        hora_cierre = request.POST["hora_cierre"]
        hora = datetime.now()
        Puja.objects.create(obra=obra,cliente=duenio,hora=hora,monto=costo_inicial)
        Sala.objects.create(articulo=obra,apertura=hora_sala,costo_inicial=costo_inicial,fecha_cierre=fecha_cierre,hora_cierre=hora_cierre)
        return HttpResponseRedirect(reverse('index'))
    
    return render(request,"subastas/crear_sala.html",{
        "obras":obras,
        })

@login_required
def crear_obra(request):
    artistas = Artista.objects.all()
    if request.method == "POST":
        nombre = request.POST["nombre"]
        artista_obra = request.POST["artista"]
        artista = Artista.objects.get(nombre=artista_obra)
        duenio = Vendedor.objects.get(usuario_vendedor=request.user)
        Obra.objects.create(nombre=nombre, artista=artista,duenio=duenio)
        return HttpResponseRedirect(reverse('crear_sala'))
    
    return render(request,"subastas/crear_obra.html",{
        "artistas": artistas,
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

@login_required
def mis_ofertas(request):
    usuario = request.user.id
    cliente = Comprador.objects.get(pk=usuario)
    ofertas = Puja.objects.filter(cliente=cliente.id)
    return render(request,"subastas/mis_ofertas.html",{
        "ofertas":ofertas,
    })

@login_required
def mis_obras(request):
    usuario = request.user.id
    cliente = Vendedor.objects.get(pk=usuario)
    obras = Obra.objects.filter(duenio=cliente.id)
    
    return render(request,"subastas/mis_obras.html",{
        "obras": obras,
    })

def registro(request):
    if request.method == "POST":
        nombre = request.POST["nombre"]
        apellidos = request.POST["apellidos"]
        usuario = request.POST["usuario"]
        email = request.POST["email"]
        contrasenia1 = request.POST["contrasenia1"]
        contrasenia2 = request.POST["contrasenia2"]
        if (contrasenia1!=contrasenia2):
            mensaje="Por favor verifica las contraseñas"
            return render(request,"subastas/registro.html",{"mensaje":mensaje})
        
        user=User.objects.create_user(usuario,email,contrasenia1)
        user.first_name = nombre    
        user.last_name = apellidos
        user.save()
        return HttpResponseRedirect(reverse('mis_ofertas'))
    
    return render(request,"subastas/registro.html")

@login_required
def editar_perfil(request):
    if request.method == "POST":
        user = User.objects.get(username=request.user.username)
        nombre = request.POST["nombre"]
        apellidos = request.POST["apellidos"]
        password = request.POST["password"]
        user.first_name = nombre
        user.last_name = apellidos
        user.set_password(password)
        user.save()
        return HttpResponseRedirect(reverse('mis_ofertas', args=(user,)))
    
    return render(request,"subastas/editar_perfil.html")

def contacto(request):
    return render(request,"subastas/contacto.html")

def articulos_mayores(request):
    articulos = Sala.objects.filter(costo_inicial__gt=statistics.mean(costo_inicial))
    usuarios=User.objects.filter(nombre="Leo",nombre="Diego")
    pujas = Puja.objects.filter(monto__lt=statistics.mean(monto))