#!/bin/bash
# Check parameter
if [ "$#" = "0" ] ; then
    echo "usage: $(basename $0) [octopress markdown flie]"
    exit
fi

# Check file
if [ ! -f "$1" ] ; then
    echo "No such file: $1"
    exit
fi

# Let's create and process markdown
SCRIPT_FILE="/tmp/run_rake.sh"

cat << EOF_ > $SCRIPT_FILE
#!/bin/bash
rake isolate['$1']
rake generate
rake preview
rake integrate
rake generate
EOF_

chmod +x $SCRIPT_FILE
bash -x $SCRIPT_FILE
