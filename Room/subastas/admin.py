from django.contrib import admin

from .models import Artista, Comprador, Obra, Puja, Sala, Usuario, Vendedor

# Register your models here.
admin.site.register(Artista)
admin.site.register(Usuario)
admin.site.register(Vendedor)
admin.site.register(Comprador)
admin.site.register(Obra)
admin.site.register(Puja)
admin.site.register(Sala)