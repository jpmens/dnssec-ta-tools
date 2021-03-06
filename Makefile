all:

pip3:
	pip install -r csr2dnskey/requirements.txt
	pip install -r dnssec_ta_tool/requirements.txt

regress2_offline:
	(cd get_trust_anchor; $(MAKE) $@)

regress2_online:
	(cd get_trust_anchor; $(MAKE) $@)

regress3_online:
	(cd get_trust_anchor; $(MAKE) $@)
	(cd csr2dnskey; $(MAKE) $@)
	(cd dnssec_ta_tool; $(MAKE) $@)

regress3_offline:
	(cd get_trust_anchor; $(MAKE) $@)
	(cd csr2dnskey; $(MAKE) $@)
	(cd dnssec_ta_tool; $(MAKE) $@)
