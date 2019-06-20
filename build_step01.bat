@echo off

set projectdir=C:\Users\Furo\wisecare\projects
set builddir=%projectdir%\build
set timestring=%date:~-10,4%%date:~-5,2%%date:~8,2%
set timestring=%timestring%%time:~0,2%%time:~3,2%%time:~6,2%

copy %builddir%\bundle\start.bat %builddir%
ren %builddir%\bundle bundle%timestring%
