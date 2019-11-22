#!/bin/bash
#


# xy




echo "LIST PERSISTENT OBJECTS"
tpm2_listpersistent
echo ""


echo "CREATEPRIMARY"
# create a TRANSIENT primary key in the OWNER hierarchy
tpm2_createprimary -a o -g sha256 -o primary.ctx
echo ""


echo "MAKE PERSISTENT"
# -P optional
tpm2_evictcontrol -a o -c primary.ctx -p 0x81010002 
echo ""



echo "CREATE"
tpm2_create -C primary.ctx -g sha256 -u key.pub -r key.priv
echo ""


echo "LOAD"
# load the key pair
tpm2_load -C primary.ctx -u key.pub -r key.priv -o key.ctx
echo ""





echo "CLEANUP"
rm primary.ctx
rm key.pub
rm key.priv
rm key.ctx
echo ""
