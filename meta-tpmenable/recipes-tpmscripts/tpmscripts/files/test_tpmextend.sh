#!/bin/sh
#
echo "Extending pcr 23 by a sha1 hash"
tpm2_pcrextend 23:sha1=$(touch test.txt && echo "hello world" > test.txt && tpm2_hash -C e -g sha1 test.txt | hexdump -e '"%x"')
tpm2_pcrread
echo "You may reset pcr 23 with tpm2_pcrreset 23 or print again with tpm2_pcrread"
