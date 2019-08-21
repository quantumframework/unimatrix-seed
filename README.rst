============================
Unimatrix Kubernetes Cluster
============================

This repository contains a versioned Kubernetes cluster, that
is managed by Unimatrix One.


Prerequisites
=============
- A Kubernetes cluster.
- An X.509 certificate and key to use as a cluster Certificate
  Authority (CA).
- Python 3.7 is installed on the system performing the cluster
  deployment.

Setup
=====

Importing the cluster CA
------------------------
Import your cluster default certificate authority, assuming
that the path to the key is ``tls.key`` and to the certificate
is ``tls.crt``.

.. code:: bash

  kubectl create -n kube-system secret tls\
    x509.ca.default --key tls.key --cert tls.crt


Also put the certificate in the ``./pki`` directory and
commit it to your version control system. **Note that the
certificate must have the .pem extension**.

.. note::

  If the CA is part of a hierarchy, make sure to include the
  chain (but do not include the root) in ``tls.crt``.


Preparing your environment
--------------------------
The Ansible playbooks require certain Python modules to
function properly. Certain Ansible Galaxy modules also
need to be installed on your system. These steps are
gathered in a handy ``make`` target:

.. code::

  make env


Next, if you want to configure your Ansible Tower instance to manage
this cluster, run the following commands. These steps are optional.

.. code:: bash

  export TOWER_HOST=<your Ansible Tower URL>
  export TOWER_USERNAME=<username>
  export TOWER_PASSWORD=<password>


Initial cluster configuration
-----------------------------
Create a configuration file for the appropriate environment(s)
in the ``ops/ansibles/vars`` folder. The below code snippet
shows an example of such a configuration file.

.. literalinclude:: ops/ansible/vars/example.yml
  :language: yaml


How-to
======

Import cluster trusted CAs into Java keystore
---------------------------------------------
Augment your ``docker-entrypoint`` with the following snippet:

.. code:: bash

  if ls ${CERTS_DIR}/*.pem 1> /dev/null 2>&1; then
    for fn in ${CERTS_DIR}/*.pem; do
      crt="${fn##*/}"
      keytool -keystore $TRUSTSTORE_PATH\
        -import -alias $crt\
        -file "$CERTS_DIR/$crt"\
        -storepass $TRUSTSTORE_PASSWORD\
        -keypass $TRUSTSTORE_PASSWORD\
        -noprompt
    done
  else
    export TRUSTSTORE_PATH="${JAVA_HOME}/jre/lib/security/cacerts"
  fi

Note that this example assumes that you have set the ``JAVA_HOME``
environment variable.

Appendix A: Logstash port allocation
====================================

============  ===========================
**Port**      **Consumer**
============  ===========================
**8000**      Reserved
**8001**      Squid access logs
**8002**      Reserved
**8003**      Nginx access logs (ingress)
**8004**      Reserved
============  ===========================
