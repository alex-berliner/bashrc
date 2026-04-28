: "${RC_REPO:?Error: RC_REPO environment variable is not defined}"
# add to bashrc, run from bashrc root
# echo export RC_REPO="`pwd`" >> ~/.bashrc
# echo . $RC_REPO/main.sh >> ~/.bashrc

. $RC_REPO/helper.sh
. $RC_REPO/fts.sh
