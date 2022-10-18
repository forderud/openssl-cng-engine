@echo off
:: Add OpenSSL to PATH
set PATH=%PATH%;C:\Program Files\OpenSSL\bin
set PATH=%PATH%;C:\Dev\openssl-cng-engine\bld\x64-Release-

set OPENSSL_CONF=C:\Dev\openssl-cng-engine\OpenSSL-CNG.conf

:: Test that engines can be loaded
::openssl engine dynamic -pre SO_PATH:engine-bcrypt -pre LOAD
::openssl engine dynamic -pre SO_PATH:engine-ncrypt -pre LOAD

echo List certificates in CurrentUser\My:
openssl storeutl -certs cert:/CurrentUser/My
set SELECTED_CERT=cert:/CurrentUser/My/afb743a7146d92b4c4d404449af8d64e28752e08

echo Extract public and private key:
openssl storeutl -certs -out cert.pem %SELECTED_CERT%
openssl storeutl -keys -out cert.key %SELECTED_CERT%

::echo Parse keys (private key parsing fail since it's really an opaque NCrypt handle):
::openssl x509 -in cert.pem -text -noout
::openssl rsa -in cert.key -text -noout

echo Test TLS handshake (doesn't work since the private key is really an opaque NCrypt handle):
openssl s_client -connect localhost:443 -cert cert.pem -key cert.key -state -debug

echo Test signing:
echo To be signed | openssl dgst -sha256 -keyform engine -engine engine-ncrypt -sign %SELECTED_CERT%

pause
