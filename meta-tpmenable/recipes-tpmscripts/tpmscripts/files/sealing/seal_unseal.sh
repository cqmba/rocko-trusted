#!/bin/bash
#


# SEAL AND UNSEAL
# 

echo "CREATE PRIMARY"
# create root key
tpm2_createprimary -a o -g sha256 -o prim.ctx
echo ""


echo "SEAL"
# create key to work with
# and encrypt data
tpm2_create -C prim.ctx -u seal.pub -r seal.priv -i seal.data
echo ""


echo "LOAD"
#tpm2_load -C prim.ctx -u seal.pub -r seal.priv -n unseal.key.name -o unseal.key.ctx
tpm2_load -C prim.ctx -u seal.pub -r seal.priv -o unseal.key.ctx
echo ""


echo "UNSEAL"
tpm2_unseal -c unseal.key.ctx
echo ""


echo "CLEANUP"
rm seal.pub
rm seal.priv
rm prim.ctx
rm unseal.key.ctx
rm unseal.key.name
tpm2_flushcontext -s
tpm2_flushcontext -l
tpm2_flushcontext -t
echo ""
