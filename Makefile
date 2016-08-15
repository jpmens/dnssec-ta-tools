SCRIPT=		dnssec_ta_tool.py csr2dnskey.py

VENV=		venv
MODULES=	pylint iso8601 xmltodict dnspython pyOpenSSL pyCrypto

TMPFILES=	root-anchors.xml root-anchors.p7s icannbundle.pem

CSR=		Kjqmt7v.csr

all:
	
lint:
	#pep8 --max-line-length=132 $(SCRIPT)
	pylint --reports=no -d line-too-long $(SCRIPT)

$(VENV):
	virtualenv -p python3 $(VENV)
	$(VENV)/bin/pip install $(MODULES)

demo: $(VENV) root-anchors.xml
	$(VENV)/bin/python dnssec_ta_tool.py --format dnskey --verbose

test: $(VENV)
	$(VENV)/bin/python dnssec_ta_tool.py --anchors test-anchors.xml --format dnskey --verbose

root-anchors.p7s:
	curl -o $@ https://data.iana.org/root-anchors/root-anchors.p7s

icannbundle.pem:
	curl -o $@ https://data.iana.org/root-anchors/icannbundle.pem

root-anchors.xml: root-anchors.p7s icannbundle.pem
	curl -o root-anchors.tmp https://data.iana.org/root-anchors/root-anchors.xml
	openssl smime -verify -inform der \
		-CAfile icannbundle.pem \
		-in root-anchors.p7s -out /dev/null \
		-content root-anchors.tmp
	mv root-anchors.tmp $@

csr: $(CSR)

Kjqmt7v.csr:
	curl -o $@ http://data.iana.org/root-anchors/Kjqmt7v.csr

clean:
	rm -f $(TMPFILES)
	rm -rf $(VENV)
