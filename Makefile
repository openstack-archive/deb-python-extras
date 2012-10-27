# See README.rst for copyright and licensing details.

PYTHON=python
SOURCES=$(shell find extras -name "*.py")

check:
	PYTHONPATH=$(PWD) $(PYTHON) -m testtools.run extras.tests.test_suite

TAGS: ${SOURCES}
	ctags -e -R extras/

tags: ${SOURCES}
	ctags -R extras/

clean: clean-sphinx
	rm -f TAGS tags
	find extras -name "*.pyc" -exec rm '{}' \;

prerelease:
	# An existing MANIFEST breaks distutils sometimes. Avoid that.
	-rm MANIFEST

release:
	./setup.py sdist upload --sign
	$(PYTHON) scripts/_lp_release.py

snapshot: prerelease
	./setup.py sdist

### Documentation ###

apidocs:
	# pydoctor emits deprecation warnings under Ubuntu 10.10 LTS
	PYTHONWARNINGS='ignore::DeprecationWarning' \
		pydoctor --make-html --add-package extras \
		--docformat=restructuredtext --project-name=extras \
		--project-url=https://launchpad.net/extras

doc/news.rst:
	ln -s ../NEWS doc/news.rst

docs: doc/news.rst docs-sphinx
	rm doc/news.rst

docs-sphinx: html-sphinx

# Clean out generated documentation
clean-sphinx:
	cd doc && make clean

# Build the html docs using Sphinx.
html-sphinx:
	cd doc && make html

.PHONY: apidocs docs-sphinx clean-sphinx html-sphinx docs
.PHONY: check clean prerelease release
