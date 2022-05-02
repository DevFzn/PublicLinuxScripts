# Scripts Publicos

Selección de scripts de autoria propia

- [Exploracion de Logs](#buscalog)
- [Funciones Git](#funciones-git)
- [Funciones Python](#funciones-python)
- [Consola de Python a color](#interprete-a-color)
- [Otros](#otros)
  - [Estadisticas covid Chile](#covstats)
  - [Mpv Playlist](#mpvplaylist)
  - [Otras funciones](#otras-funciones)
- [Lol laucher y debug](#rito-pls)

> **NOTA:** Funciones ejecutadas con ***alias***  
> - ej: `alias mi_alias='/ruta/a/script funcion <arg(s)>'`
----


# Buscalog

Script a color, para explorar logs en `/var/log/` y directorios agregados en `~/.config/custom_log_dirs`.  
ej `custom_log_dirs`:
```txt
/ruta/a/directorio
/ruta/a/otro/directorio
/ruta/a otro/directorio con espacios
```
> - Los nombres de directorios terminan en `\n`


Lista los log disponibles en los directorios mencionados.  
> - archivos con extension `.log`  
> - archivos con permiso de lectura  

`./buscalog.sh listLog`
```txt
    Selección de Logs :
    -------------------
      0) log_a
      1) log_b 
      2) log_c 
      3) log_cd 
      4) custom/dir/log_a
      5) custom/dir/log_b
      6) otro/custom/dir/log_c
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
| LOG: /var/log/milog.log |  BUSQUEDA: \s404\s |  ECONTRADOS: 11  |
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
> - llaves ssh en `~/.ssh/keys/`

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

## crea_readmes()

Invoca `touch README.md` en los directorios a un sub-nivel del actual.  
ej. nombres de directorios:  `mi_dir/`, `mi dir con espacios/`.

ej. Directorios
```txt
📂️ .
├── 📂️  SubDir1
│   ├── 📂️  deepDir1
│   └── 📂️  deepDir2
└── 📂️  Sub Dir 2
    ├── 📂️  deepDir1
    └── 📂️  deepDir2
```

`./gitfun.sh crea_readmes`
```txt
📂️ .
├── 📂️ SubDir1
│   ├── 📂️ deepDir1
│   ├── 📂️ deepDir2
│   └── 📃️ README.md
└── 📂️ Sub Dir 2
    ├── 📂️ deepDir1
    ├── 📂️ deepDir2
    └── 📃️ README.md
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

### MpvPlaylist()

Función para administrar una 'playlist' para ser usada con [mpv](https://mpv.io)  
> archivo: `~/.cache/.playlist`

**Uso**  
ej. `alias mpvp='./otros.sh pvPlaylist'`
| Orden | Detalle |
| - | - |
|`mpvp` | Modo interactivo |
|`mpvp -h` | Mostrar ayuda |
|`mpvp https://link.video`| Agregar el link a *playlist* |
|`mpvp -r` | Reproducir *playlist* |
|`m̀pvp -s` | Reproducir *playlist* y apagar PC |

**Modo interactivo**  

```
  Playlist Manager
  ----------------

  1) Ver Lista
  2) Añadir link(s)
  3) Reproducir lista
  4) Reproducir y Apagar PC
  5) Borrar lista
  6) Editar
  s) Salir

 Elige una opción : 
```
| Opción | Detalle |
| - | - |
|`1`| Muestra el contenido del *playlist*  |
|`2`| Agrega uno, o mas links (v) volver, (s) salir  |
|`3`| Reproduce lista                  |
|`4`| Reproduce y apaga el equipo     |
|`5`| Borra la lista |
|`6`| Editar lista (neovim) |
|`s`| Salir |

### Otras Funciones

| Funcion | Explicación |
| - | - |
|`Caldera()` |  Lanza xfce terminal y corre el script [caldera.py](https://gitea.kickto.net/SyDeVoS/Caldera-ino/src/branch/master/scripts#python)|
|`Termo()` | Lanza xfce terminal y corre el script [caldera.sh](https://gitea.kickto.net/SyDeVoS/Caldera-ino/src/branch/master/scripts#bash)|
|`yutu()` | Busca video pasado como argumento, instancia [mpv](https://mpv.io/) con el resultado <br> ej. `./otros.sh yutu <video a buscar>`|
|`Neo()` | 'Envoltorio' para neofetch <br> `./otros.sh Neo -h` lista logos disponibles <br>`./otros.sh Neo <logo>` ejecuta neofetch con el logo especificado.|

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
