#!/bin/bash
#



# das Script lässt vom TPM eine Signatur für externe Daten erzeugen
# das asymmetrische Schlüsselüaar wird auf dem TPM erzeugt
# der private Key verschlüsselt auf dem TPM und kann nicht ausgelesen werden
# der öffentliche Schlüssel wird gelesen und wird zurPrüfung der Signatur extrahiert
# mittels OpenSSL wird die Signatur extern (vom Linux) überprüft

echo "PRIM KEY"
# primary key for owner hierarchy
tpm2_createprimary -a o -o csr_prim.ctx
echo ""


echo "KEY"
# create signing key pair  
tpm2_create -C csr_prim.ctx -u csr.pub -r csr.priv
echo ""


echo "LOAD KEY"
#C SR pub/priv sind Binärblobs, können nicht ohne weiteres
# von OpenSSL verarbeitet werden
tpm2_load -C csr_prim.ctx -u csr.pub -r csr.priv -o csr_sub.ctx
echo ""


echo "HASH"
# this is not really important
# it compares the HASH output of the TPM and Linux 
tpm2_hash -a o -g sha256 input_hex.dat
sha256sum input_hex.dat
echo ""


echo "SIGN"
# the TPM signs external data with private signing key
# output the signautre to the file system
tpm2_sign -c csr_sub.ctx -g sha256 -m input_hex.dat -o signature_tpm.sig
echo ""


echo "CHECK SIG"
# TPM checks its own signature
# this will success :-D
tpm2_verifysignature -c csr_sub.ctx -g sha256 -m input_hex.dat -s signature_tpm.sig
echo ""


echo "READ PUB KEY FOR OPENSSL CHECK"
# extract the (unencrypted) public key from the TPM
# use PEM format for OpenSSL
tpm2_readpublic -c csr_sub.ctx -f pem -o csr.pem
echo ""


echo "EXTRACT SIGNATURE"
#
# the signature file has some additional header information
# this information will be deletet to be compatible to OpenSSL
# 

# THE FIRST SIX BYTES OF SIGNATURE.SIG WILL BE DELETED
# [0014 000b 0100]
# 
# pi@raspberrypi:~/development/csr $ xxd signature.sig 
# 00000000: 0014 000b 0100 54e6 6bb3 f16c a3ec 6968  ......T.k..l..ih
# 00000010: 77a4 bfec f453 0863 8978 5f67 8cac 5ee3  w....S.c.x_g..^.
# ...
# 000000e0: ba63 f805 7dbe cec5 a5a1 3824 fd01 b425  .c..}.....8$...%
# 000000f0: 219f 78ae 2ad1 7631 a74e 0e22 cce1 681c  !.x.*.v1.N."..h.
# 00000100: 745f 1fdf fe2d			     t_...-


# DD COMMANT CAN DO THIS JOB
#
# pi@raspberrypi:~/development/csr $ dd if=signature_tpm.sig of=signature_raw.sig bs=1 skip=6
# 256+0 Datens�tze ein
# 256+0 Datens�tze aus
# 256 bytes copied, 0,00864755 s, 29,6 kB/s


# CHECK THE OUTPUT
#
# pi@raspberrypi:~/development/csr $ xxd signature2.sig 
# 00000000: 54e6 6bb3 f16c a3ec 6968 77a4 bfec f453  T.k..l..ihw....S
# 00000010: 0863 8978 5f67 8cac 5ee3 477c d118 043f  .c.x_g..^.G|...?
# ...
# 000000e0: cec5 a5a1 3824 fd01 b425 219f 78ae 2ad1  ....8$...%!.x.*.
# 000000f0: 7631 a74e 0e22 cce1 681c 745f 1fdf fe2d  v1.N."..h.t_...-

dd if=signature_tpm.sig of=signature_raw.sig bs=1 skip=6
echo ""


echo "CHECK SIG WITH OPENSSL"
# use OpenSSL to check the signature
openssl dgst -sha256 -verify csr.pem -keyform pem -signature signature_raw.sig input_hex.dat
echo ""


echo "CLEANUP"
rm csr.pem
rm signature_tpm.sig
rm signature_raw.sig
rm csr.priv
rm csr.pub
rm csr_sub.ctx
rm csr_prim.ctx
echo ""
