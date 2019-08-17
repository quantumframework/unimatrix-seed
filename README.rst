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
