#!/bin/bash
#

# 


echo "PRIM"
tpm2_createprimary -a o -o primary.ctx
echo ""


echo "AES KEY"
# The AES cipher has a bitsize and a mode. When the mode is not specified, 
# ie a "NULL" mode, the TPM will allow any mode usages on subsequent key uses.
# If the mode is specified during object creation, only that mode is allowed
# in subsequent use cases.
#
#    aes - Default AES selection. The default AES Selection is AES 128 with a NULL mode.
#    aes[128|192|256] - AES with a key size of 128, 192 and 256 respectively with a NULL mode.
#    aes[128|192|256][cbc|ocb|cfb|ecb] - AES with a key size of 128, 192 and 256 and a mode of cbc, ocb, cfb and ecb respectively.
#
# Examples
#
#    aes256cbc - AES with a key bitsize of 256 and a mode of cbc.
#    aes192cfb - AES with a bitsize of 192 and mode of cfb.
#    aes128 - AES with a bitsize of 128 and NULL mode.
#
# supported key algs
# aes:
#  value:      0x6
#  asymmetric: 0
#  symmetric:  1
#  hash:       0
#  object:     0
#  reserved:   0x0
#  signing:    0
#  encrypting: 0
#  method:     0
#
# cfb:
#  value:      0x43
#  asymmetric: 0
#  symmetric:  1
#  hash:       0
#  object:     0
#  reserved:   0x0
#  signing:    0
#  encrypting: 1
#  method:     0
tpm2_create -C primary.ctx -G aes128 -u aeskey.pub -r aeskey.priv
tpm2_load -C primary.ctx -u aeskey.pub -r aeskey.priv -o aeskey.ctx
echo ""


echo "CREATE IV"
# random 16 byte Initialisierungs-Vektor (IV)
dd if=/dev/urandom of=iv.dat bs=1 count=16
echo ""


echo "ENCRYPT"
# print start time
date
# run encryption
tpm2_encryptdecrypt -c aeskey.ctx -i data100.bin -o out.enc
# print end time
date
echo ""


echo "CLEANUP"
rm primary.ctx
rm iv.dat
rm aeskey.pub
rm aeskey.priv
rm aeskey.ctx
rm out.enc
tpm2_flushcontext -s
tpm2_flushcontext -l
tpm2_flushcontext -t
echo ""



