FROM containers.intersystems.com/intersystems/iris-community:2021.2.0.649.0

ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

USER ${ISC_PACKAGE_MGRUSER}

COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP --chmod=+x irissession.sh /
COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP src /tmp

# RUN chmod +x /irissession.sh

RUN pip install asyncua==0.9.14 boto3 --no-cache-dir --target $ISC_PACKAGE_INSTALLDIR/mgr/python

SHELL ["/irissession.sh"]

RUN \
  zn "USER" \
  do ##class(%EnsembleMgr).EnableNamespace($Namespace, 1) \
  do $SYSTEM.OBJ.LoadDir("/tmp", "ck", , 1) \
  do ##class(dc.opcua.Threshold).Init() \
  set production = "dc.opcua.Production" \
  set ^Ens.Configuration("csp","LastProduction") = production \
  do ##class(Ens.Director).SetAutoStart(production)

# bringing the standard shell back
SHELL ["/bin/bash", "-c"]