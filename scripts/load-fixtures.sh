#!/usr/bin/env bash
# Load data for the GSA PSHC discovery application, per the README instructions.

SCRIPT_DIR="$(cd "$(dirname "$([ `readlink "$0"` ] && echo "`readlink "$0"`" || echo "$0")")"; pwd -P)"
cd "$SCRIPT_DIR/../app"

# Load category fixtures

./manage.py load_categories

# Load vendor related fixtures

./manage.py loaddata vendors/fixtures/locations.json
./manage.py loaddata vendors/fixtures/vendors.json # reqs: locations, setasides
./manage.py loaddata vendors/fixtures/poolmemberships.json # reqs: pool, vendor
./manage.py loaddata vendors/fixtures/samloads.json
./manage.py loaddata vendors/fixtures/managers.json # reqs: vendors
./manage.py loaddata vendors/fixtures/manageremails.json # reqs: managers
./manage.py loaddata vendors/fixtures/managerphonenumbers.json # reqs: managers
./manage.py loaddata vendors/fixtures/contractmanagers.json # reqs: managers
./manage.py loaddata vendors/fixtures/projectmanagers.json # reqs: managers

# Load contract related fixtures

./manage.py loaddata contracts/fixtures/contractstatuses.json
./manage.py loaddata contracts/fixtures/pricingstructures.json
./manage.py loaddata contracts/fixtures/placesofperformance.json
./manage.py loaddata contracts/fixtures/contracts.json #reqs: naics, vendor, piid, contractstatus, pricingstructure, placeofperformance
./manage.py loaddata contracts/fixtures/fpdsloads.json #reqs: vendor
