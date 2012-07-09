#!/bin/bash
# This script is used to export a ZNC user's settings to a self-extracting bash script.
# Programs expected to be available: tar, gzip
# (C) 2012 Willem Mulder
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

sed -nr "/<[uU]ser ${1:?Please specify a username}>/,/<\/[uU]ser>/p" configs/znc.conf >$1.conf

cat >$1.sh << EOF
#!/bin/bash
# Backup of $1's znc settings

[ -e $1.conf ] && echo $1.conf already exists - exiting && exit 1

tail -n +12 \$0 | tar xz # extract data
cat $1.conf >>configs/znc.conf
rm $1.conf

exit 0
#Here comes the data
EOF
tar cz $1.conf users/$1 >>$1.sh
chmod +x $1.sh
rm $1.conf
