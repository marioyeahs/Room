from django.urls import path

from . import views

urlpatterns = [
    path("",views.index,name="index"),
    path("artista/<int:artista_id>/", views.artista_info,name="artista_info"),
    path("salas/<int:sala_id>/", views.sala, name="sala"),
    path("salas/<int:sala_id>/puja", views.bid, name="bid"),
    path("salas/corrientes",views.corrientes, name="corrientes"),
    path("crear_sala/", views.crear_sala,name="crear_sala"),
    path("crear_obra",views.crear_obra,name="crear_obra"),
    path("crear_artista",views.crear_artista,name="crear_artista"),

]