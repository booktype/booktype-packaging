booktype-packaging
==================

Debian packaging for https://github.com/sourcefabric/Booktype

The sourcefabric branch includes a pybundle for setup of a virtualenv. To create the pybundle in a clean environment:

```
virtualenv venv
venv/bin/pip bundle booktype-dependencies.pybundle -r requirements
```
