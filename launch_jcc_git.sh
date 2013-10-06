primerdir=$(pwd)
conflicto=
echo "Actualizando base de datos"
cd $HOME/.jCodeCollector/jCodeCollector
pulling=$(timeout 30 git pull --rebase 2>&1)
echo -.- ${pulling} -.-
if [[ "${pulling,,}" == *conflict* ]];then
   conflicto=true
   kdialog --passivepopup "Ocurrio un conflicto merging $(pwd)" 
fi
if [[ "${pulling,,}" == *"cannot pull"* ]];then
   conflicto=true
   kdialog --passivepopup "Pull no fue posible en $(pwd)"
fi
echo "Starting jCodeCollector"
cd ${primerdir}
java -jar jcodecollector.jar -Dawt.useSystemAAFontSettings=o
if [[ ! $conflicto ]];then
   echo "Subiendo base de datos al servidor"
   cd $HOME/.jCodeCollector/jCodeCollector
   git add -A
   git commit --amend -C master
   timeout 30 git push --mirror -u
else
   echo "Existen conflictos con el servidor, no guardo cambios"
   kdialog --passivepopup "Existen conflictos en $HOME/.jCodeCollector/jCodeCollector, no guardo cambios"
fi
