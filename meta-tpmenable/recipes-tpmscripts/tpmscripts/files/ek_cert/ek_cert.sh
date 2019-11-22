#!/bin/bash
#


# ENDORSEMENT KEY AND ENDORSEMENT CERTIFICATE

echo "CREATE EK"
# this creates the file ek.ctx
tpm2_createek -G rsa -V
echo ""


echo "READ PUBLIC EK KEY"
# -f der|pem
tpm2_readpublic -c ek.ctx -o ek_pub.key -f pem
echo ""


echo "READ EK CERTIFICATE"
# read RSA certificate
tpm2_nvread -x 0x01C00002 -o ek_cert.crt -s 1184 
echo ""


echo "CONVERT DER (ek_cert.crt) to PEM (ek_cert.pem)"
openssl x509 -inform DER -in ek_cert.crt -out ek_cert.pem
echo ""

echo "VERIFY THE EK CERTIFICATE CHAIN WITH OPENSSL"
# root
# intermediate
# ek_cert
openssl verify -CAfile ./certs_infineon/Infineon-TPM_RSA_Root_CA-C-v01_00-EN.crt -untrusted ./certs_infineon/InfineonOPTIGA\(TM\)RSAManufacturingCA035.crt ek_cert.pem
echo ""

echo "CLEANUP"
tpm2_flushcontext -t
rm ek.ctx
rm ek_cert.pem
rm ek_cert.crt
rm ek_pub.key
echo ""
