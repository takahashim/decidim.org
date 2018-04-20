#!/bin/bash
#
# Generator for decidim.org (data/cities.yml)
#
# Input CSV with this structure:
#   organization,type,status,company,notes,contact,country,url,image,repo,slug,tags,order,monitor
#   "Ajuntament de Barcelona",,,,,,,,"https://www.decidim.barcelona/","/images/partners/logo_partner_ajbcn.jpg",,,,,
#
# Output example:
# - barcelona
#   - name: Barcelona
#   - url: https://www.decidim.barcelona/
#   - image: /images/partners/logo_partner_ajbcn.jpg
# - helsinki
# (...)

slugify () {
  # https://stackoverflow.com/a/49035906
  echo "$1" | iconv -t ascii//TRANSLIT | sed -r s/[~\^]+//g | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z
}

INPUT='data.csv'
OLDIFS=$IFS
IFS=,
OUTPUT=data/cities.yml

# we need to order the data by column 13 (order)
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
ORD_INPUT=/tmp/data.csv
sort -n -t"," -k13 $INPUT > $ORD_INPUT

echo "# This is an autogenerated file." > $OUTPUT
echo "# If you want your installation to be on decidim.org, you can create us an issue on https://github/decidim/decidim.org" >> $OUTPUT
echo "# or say hi at hola [at] decidim.org" >> $OUTPUT
echo "" >> $OUTPUT

while read organization type status company notes contact country url image repo slug tags order monitor
do
  if [ $status == "Producción" ] && [ ! -z $url ] && [ ! -z $image ] ; then
    slug=$(slugify $organization)
    echo "- ${slug}:" >> $OUTPUT
    echo "  name: ${organization}" >> $OUTPUT
    echo "  url: ${url}" >> $OUTPUT
    echo "  image: ${image}" >> $OUTPUT
  fi
done < $ORD_INPUT
IFS=$OLDIFS
