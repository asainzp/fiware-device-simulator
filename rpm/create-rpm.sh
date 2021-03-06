#!/bin/bash
# Copyright 2015 Telefónica Investigación y Desarrollo, S.A.U
#
# This file is part of the fiware-device-simulator (FI-WARE project).
#
# fiware-device-simulator is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# fiware-device-simulator is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with fiware-device-simulator.
# If not, see http://www.gnu.org/licenses/.
#
# For those usages not covered by the GNU Affero General Public License
# please contact with: [german.torodelvalle@telefonica.com]


function usage() {
    SCRIPT=$(basename $0)

    printf "\n" >&2
    printf "usage: ${SCRIPT} [options] \n" >&2
    printf "\n" >&2
    printf "Options:\n" >&2
    printf "\n" >&2
    printf "    -h                    show usage\n" >&2
    printf "    -v VERSION            Mandatory parameter. Version for rpm product preferably in format x.y.z \n" >&2
    printf "    -r RELEASE            Mandatory parameter. Release for product. I.E. 0.ge58dffa \n" >&2
    printf "\n" >&2
}

while getopts ":v:r:u:a:h" opt

do
    case $opt in
        v)
            VERSION_ARG=${OPTARG}
            ;;
        r)
            RELEASE_ARG=${OPTARG}
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            echo "invalid argument: '${OPTARG}'"
            exit 1
            ;;
    esac
done

BASE_DIR="$(cd ${0%/*} && pwd -P)/.."
RPM_BASE_DIR="${BASE_DIR}/rpm"

# Cleanup previous RPM build directories
rm -rf ${RPM_BASE_DIR}/{BUILD,BUILDROOT,RPMS,SRPMS}
mkdir -p ${RPM_BASE_DIR}/{BUILD,BUILDROOT,RPMS,SRPMS}

if [[ ! -z ${VERSION_ARG} ]]; then
	PRODUCT_VERSION=${VERSION_ARG}
else
	echo "A product version must be specified with -v parameter."
	usage
	exit 2
fi

if [[ ! -z ${RELEASE_ARG} ]]; then
	PRODUCT_RELEASE=${RELEASE_ARG}
else
	echo "A product reslease must be specified with -r parameter."
	usage
	exit 2
fi

RPM_USER="fiware-device-simulator"

rpmbuild -bb ${RPM_BASE_DIR}/SPECS/fiware-device-simulator.spec \
    --define "_topdir ${RPM_BASE_DIR}" \
    --define "_project_user ${RPM_USER}" \
    --define "_product_version ${PRODUCT_VERSION}" \
    --define "_product_release ${PRODUCT_RELEASE}"

