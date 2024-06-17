#!/bin/bash
echo "==================================================================================="
echo "==== Kerberos KDC and Kadmin ======================================================"
echo "==================================================================================="
echo "Setting up Kerberos KDC and Kadmin..."
KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM
KDC_KADMIN_SERVER=$(hostname -f)

echo "==================================================================================="
echo "==== /etc/krb5.conf ==============================================================="
echo "==================================================================================="
echo "Configuring /etc/krb5.conf..."
cat <<EOF > /etc/krb5.conf
[libdefaults]
    default_realm = $REALM

[realms]
  $REALM = {
    kdc_ports = 88,750
    kadmind_port = 749
    kdc = $KDC_KADMIN_SERVER
    admin_server = $KDC_KADMIN_SERVER
  }
EOF

echo "==================================================================================="
echo "==== /etc/krb5kdc/kdc.conf ========================================================"
echo "==================================================================================="
echo "Configuring /etc/krb5kdc/kdc.conf..."
mkdir -p /etc/krb5kdc
cat <<EOF > /etc/krb5kdc/kdc.conf
[realms]
  $REALM = {
    acl_file = /etc/krb5kdc/kadm5.acl
    max_renewable_life = 7d 0h 0m 0s
    supported_enctypes = $SUPPORTED_ENCRYPTION_TYPES
    default_principal_flags = +preauth
  }
EOF

echo "==================================================================================="
echo "==== /etc/krb5kdc/kadm5.acl ======================================================="
echo "==================================================================================="
echo "Configuring /etc/krb5kdc/kadm5.acl..."
cat <<EOF > /etc/krb5kdc/kadm5.acl
$KADMIN_PRINCIPAL_FULL *
noPermissions@$REALM X
EOF

echo "==================================================================================="
echo "==== Creating realm ==============================================================="
echo "==================================================================================="
echo "Creating realm..."
MASTER_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
kdb5_util create -s <<EOF
$MASTER_PASSWORD
$MASTER_PASSWORD
EOF

echo "==================================================================================="
echo "==== Creating default principals in the acl ======================================="
echo "==================================================================================="
echo "Creating default principals in the ACL..."
echo "Adding $KADMIN_PRINCIPAL principal"
kadmin.local -q "delete_principal -force $KADMIN_PRINCIPAL_FULL"
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD $KADMIN_PRINCIPAL_FULL"

echo "Adding noPermissions principal"
kadmin.local -q "delete_principal -force noPermissions@$REALM"
kadmin.local -q "addprinc -pw $KADMIN_PASSWORD noPermissions@$REALM"

echo "Starting Kerberos KDC and Kadmin..."
krb5kdc
kadmind -nofork
