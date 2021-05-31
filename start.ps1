# Script start.ps1

# Pfad zum yml-File:
$ymlFile = Join-Path $PWD ".github\workflows\build_n-doc_template.yml"

# Version aus yml-file
# yml-file einlesen, pipen nach Select-String mit Pattern 'container: ndesign/n-doc:', 
# den resultierenden Ausdruck als String handeln und hierauf Split-Operation mit Delimiter ':' aufrufen
# ==> split liefert dann einen Vektor mit den einzelnen token
$theversion = ((get-content $ymlFile | Select-String -CaseSensitive -Pattern 'container: ndesign/n-doc:') -split ':')[2]

# zur Kontrolle mal ausgeben:
"ermittelte Version: <$theversion>"

# Environment-var 'engine':
# $Env:engine, falls NULL dann foo
$opts = $engine ?? $theversion

"verwendete engine: <$opts>"

$TheDir = $PWD.path

docker run -d -i --name ndoc -v ${TheDir}:/data ndesign/n-doc:$opts

