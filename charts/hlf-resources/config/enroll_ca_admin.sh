# Check if is already enrolled
if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin/msp/cacerts/0-0-0-0-7054.pem ]; then
    echo "CA Admin Cert already exists."
    exit 0
fi

mkdir -p ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/crypto
cp ${FABRIC_CA_SERVER_HOME}/ca-cert.pem ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/crypto

export FABRIC_CA_CLIENT_TLS_CERTFILES=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin

# Enroll Admin
fabric-ca-client enroll -d -u https://${ADMIN}:${ADMINPW}@0.0.0.0:7054

rtnVal=${?}
if [ $rtnVal -ne 0 ]; then
    echo "**CA Admin Cert cannot be generatd. fabric-ca-client enroll return error"
    exit 1
fi

if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin/msp/cacerts/0-0-0-0-7054.pem ]; 
then
    echo "CA Admin Cert is enrolled successfully."
    exit 0
else
    echo "CA Admin Cert cannot be generatd."
    exit 1
fi