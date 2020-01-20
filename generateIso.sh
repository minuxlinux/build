#!/usr/bin/env bash
#=====================HEADER=========================================|
#AUTOR
# Jefferson 'Slackjeff' Rocha <root@slackjeff.com.br
#
#LICENÇA
# mit
#
# Gerador de ISO para o minuX, execute no diretório raiz de onde
# está o sistema.
#====================================================================|

#==============================| Variáveis
SYSTEM='minuX'
VERSION='0.1'

#==============================| TESTES
# Existe?
type mkisofs &>/dev/null || { echo "mkisofs Não foi encontrado."; exit 1;}

[[ -z "$1" ]] && { echo "Passe um diretorio."; exit 1 ;}
pushd $1

# Verificando arquivos da raiz do sistema
for file in isolinux/{efiboot.img,iso{.sort,isolinux.b{in,oot}}}
do

echo -n "Verificando arquivo $file: "

if [[ -e $file ]]
then
    echo OK
else
    echo "falha ao encontrar arquivo $file"
    exit 1
fi

done 

#==============================| INICIO

echo "Executando mkisofs..."
sleep 2s
mkisofs -o /tmp/${SYSTEM}-${VERSION}-x86_64.iso          \
  -R -J -A "$SYSTEM"                                       \
  -hide-rr-moved                                           \
  -v -d -N                                                 \
  -no-emul-boot -boot-load-size 4 -boot-info-table         \
  -sort isolinux/iso.sort                                  \
  -b isolinux/isolinux.bin                                 \
  -c isolinux/isolinux.boot                                \
  -eltorito-alt-boot -no-emul-boot -eltorito-platform 0xEF \
  -eltorito-boot isolinux/efiboot.img                      \
  -m 'source' \
  -V "${SYSTEM}${VERSION}" .
