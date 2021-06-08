from django.http.response import HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.urls import reverse

# Create your views here.

def index(request):
    if not request.user.is_authenticated:
        return HttpResponseRedirect(reverse('login'))
    return render(request,"users/user.html")

def login_view(request):
    if request.method == 'POST':
        usuario = request.POST["usuario"]
        contrasenia = request.POST["contrasenia"]
        user = authenticate(request, username=usuario,password=contrasenia)
        if user is not None:
            login(request,user)
            return HttpResponseRedirect(reverse("index"))
        else:
            return render(request,"users/login.html",{"mensaje":"Ingrese credenciales validas"})

    return render(request, 'users/login.html')

def logout_view(request):
    logout(request)
    return render(request, 'users/login.html',{
        "mensaje":"Sesión cerrada"
    })