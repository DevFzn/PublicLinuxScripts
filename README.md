# Scripts Publicos

Selección de scripts de autoria propia

- [Exploracion de Logs](#buscalog)
- [Funciones Git](#funciones-git)
- [Funciones Python](#funciones-python)
- [Consola de Python a color](#Interprete-a-color)
- [Otros](#otros)
- [Lol laucher y debug](#rito-pls)

> NOTA: Funciones ejecutadas con ***alias***  
> ej: `alias mi_alias='/ruta/a/scritps/script funcion <arg(s)>'`
----


# Buscalog

Script a color, para explorar logs en `/var/log/` y/o directorios agregados en `~/.config/custom_log_dirs`.  
ej `custom_log_dirs`:
```txt
/ruta/a/directorio
/ruta/a/otro/directorio
/ruta/a/otro/directorio/mas
```

> nombres de directorios sin espacios ej `/ruta/a/dir/deLogs`
> nombres de directorios terminan en `\n`


Lista los log disponibles (con permiso de lectura) en los directorios mencionados.  

`./buscalog.sh listLog`
```txt
    Selección de Logs :
    -------------------
      0) logX
      1) logXY 
      2) logZ 
      3) logZX 
      4) custom/dir/logA 
      5) custom/dir/logB 
      6) otro/custom/dir/logC 
      s) Salir

  Ver log: 
```

Muestra el contenido del log 'seleccionado' en el menu utilizando **bat**, **bat-cat** o **cat**.  
```txt
.... .... ...
.... contenido del log
.... .... ...
```
Pie de página con información del log actual, patrón de búsqueda o búsqueda inversa y  
cantidad de resultados o entradas del log.  

```txt
| LOG: /var/log/milog.log |  BUSQUEDA: error |  ECONTRADOS: 11  |
```

Opciones en vista del log

| Opción | Detalle |
| - | - |
| **`v`** volver | Vuelve a la lista principal de logs
| **`r`** recargar | Actualiza el log en vista
| **`b`** buscar |  Búsqueda en el log (escapar caracteres de escape ej. `\\s`)
| **`B`** busqueda inversa | Busqueda inversa (escapar caracteres de escape)
| **`s`** salir | Termina el programa

```txt
 | v)olver | r)ecargar | b)uscar | B)usqueda inversa | s)alir |
Opción: 
```
Script: [buscalog.sh](./buscalog.sh)

----

# Funciones Git

Script a color con funciones git y creador de *READMES* en sub-directorios.

## gitUser()
Inicia repositorio como usuario especificado en `~/.config/.gitidents`  
ej. `.gitidents`
```txt
UsuarioGit1    user1@git.org   keyUser1
UsuarioGit2    user2@git.org   keyUser2
UsuarioGit3    user3@git.org   keyUser3
UsuarioGit4    user4@git.org   keyUser4
```
> llaves ssh en `~/.ssh/keys/`

### Listar usuarios agregados  
`./gitfun.sh gitUser`
```txt
   Debes ingresar un usuario válido!

   Identidades en ~/.config/.gitidents :
	-> UsuarioGit1
	-> UsuarioGit2
	-> UsuarioGit3
	-> UsuarioGit4
	m) manual

	╮(︶▽︶)╭
```

### Iniciar repositorio como  
`./gitfun.sh gitUser UsuarioGit3`
```txt
(￣▽￣)ノ Iniciando repositorio de UsuarioGit3

hint: Using 'master' as the name for the initial branch...
hint:  ... ...
hint:  ... ...
hint: 	git branch -m <name>
Initialized empty Git repository in /tmp/testi/.git/
```

### Iniciar repo manualmente
Solicita entrada de nombre, email y llave ssh.   

`.gitfun gitUser m` o `.gitfun gitUser manual`
```txt
Nombre : Usuario Manual
Correo : mail@user.git
SSH key: llaveSSH

Usuario: Usuario Manual  Correo: mail@user.git  Llave: llaveSSH
Iniciar repositorio con estos valores? (s/n/q):
```
Script: [gitfun.sh](./gitfun.sh)

----

# Funciones Python

## pyVirtEnvSel()

Lista, crea entornos virtuales, copia al portapapeles la orden para activarlo.

### Lista entornos virtuales
Del directorio **`PyVirtEnvDir`**, especificado en el script.

`./pythonfun.sh pyVirtEnvSel`
```txt
    Entornos Virtuales Python:

	0) virtEnv
	1) virtEnv1
	2) virtEnv2
	3) virtEnv3

	c) Crear
	q) Salir

    Ingresa una opción. -> 
```
### Crea entorno virtual
ej. ***entornoVirtual5***
```
    Crear nuevo entorno
    Nombre del entorno -> entornoVirtual5

Entorno virtual python: [entornoVirtual5] Creado 🐍️
```

### Copia al portapapeles el entorno seleccionado
```txt
    Orden copiada en portapapeles:
--------------------------------------------------------------------
source /ruta/a/directorio/virtual_envs/entornoVirtual5/bin/activate
--------------------------------------------------------------------
```


Otras funciones:
- \_pip()  
  Uso del modulo **pip_search** como `pip search <busqueda>`

- pyDebug()  
  *Debugear* archivo `./pythonfun pyDebug <archivo.py>`

- pyMarkdown()  
  Markdown para terminal `./pythonfun pyMarkdown <archivo.md>`

- pyMicroCalc()  
  Micro calculadora, ejs. `./pythonfun pyCalc 1+1`, `./pythonfun pyCalc "(1+1)/2"`

Script: [pythonfun.sh](./pythonfun.sh)

### Interprete a color

Color en la consola de python con módulo **rich**. [pyRichRepl.py](./pyRichRepl.py)

----

# Otros
| Funcion | Explicación |
| - | - |
|`Caldera()` |  Lanza xfce terminal y corre el script [caldera.py](https://gitea.kickto.net/SyDeVoS/Caldera-ino/src/branch/master/scripts#python)|
|`Termo()` | Lanza xfce terminal y corre el script [caldera.sh](https://gitea.kickto.net/SyDeVoS/Caldera-ino/src/branch/master/scripts#bash)|
|`yutu()` | Busca video pasado como argumento, instancia mpv con el resultado <br> ej. `./otros.sh yutu <video a buscar>`|
|`Neo()` | 'Envoltorio' para neofetch <br> `./otros.sh Neo -h` lista logos disponibles <br>`./otros.sh Neo <logo>` ejecuta neofetch con el logo especificado.|
  

### covStats()

Estadisticas covid Chile
`./otros.sh covStats`
```txt
 Estadisticas COVID Chile  🇨🇱️ 
 ============================
  Muertes totales : 0.29 %
  Muertes contagio: 1.62 %
 ----------------------------
  Contagios   : 3,541,792 
  Activos     : 125,059 
  Recuperados : 3,359,382 
  Muertes     : 57,351 
 ----------------------------
```
Script [otros.sh](./otros.sh)

----

# Rito pls
Lanza instancia de [kitty](https://sw.kovidgoyal.net/kitty/) terminal, con 3 splits (ventanas según creador).  

Layout tall:
- Ventana 1: `bpytop`
- Ventana 2: `tail -f debug.log`
- Ventana 3: Lanza league of legends, muestra información del proceso

Utilidad para monitorear procesos con bpytop, y rastreo de informes/errores en logs de Lutris y Lol.   
[ritopls](./ritopls): `kitty --start-as maximized --session ritopls &`  
