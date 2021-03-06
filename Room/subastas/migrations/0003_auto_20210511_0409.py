# Generated by Django 3.1.4 on 2021-05-11 04:09

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('subastas', '0002_auto_20210427_0432'),
    ]

    operations = [
        migrations.CreateModel(
            name='Comprador',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
        ),
        migrations.CreateModel(
            name='Obra',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('artista', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='subastas.artista')),
            ],
        ),
        migrations.CreateModel(
            name='Usuario',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre', models.CharField(max_length=255)),
                ('apellido_paterno', models.CharField(max_length=255)),
                ('apellido_materno', models.CharField(max_length=255)),
                ('correo', models.EmailField(max_length=254)),
                ('celular', models.IntegerField()),
                ('direccion', models.CharField(max_length=255)),
                ('colonia', models.CharField(max_length=255)),
                ('cp_zip', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='Vendedor',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('usuario_id', models.OneToOneField(null=True, on_delete=django.db.models.deletion.SET_NULL, to='subastas.usuario')),
            ],
        ),
        migrations.CreateModel(
            name='Sala',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('apertura', models.DateField()),
                ('costo_inicial', models.IntegerField()),
                ('fecha', models.DateTimeField()),
                ('articulo', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='subastas.obra')),
            ],
        ),
        migrations.CreateModel(
            name='Puja',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('hora', models.TimeField()),
                ('monto', models.IntegerField()),
                ('cliente', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='subastas.comprador')),
                ('obra', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='subastas.obra')),
            ],
        ),
        migrations.AddField(
            model_name='obra',
            name='duenio',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='subastas.vendedor'),
        ),
        migrations.AddField(
            model_name='comprador',
            name='usuario_id',
            field=models.OneToOneField(null=True, on_delete=django.db.models.deletion.SET_NULL, to='subastas.usuario'),
        ),
    ]
