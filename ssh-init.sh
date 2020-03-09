#test -n "$1" || SSH_PRIVATE_KEY=$1
#test -n "$2" || SSH_KNOWN_HOSTS=$2
echo ..:: ssh-init.sh ::..
test -n "$SSH_PRIVATE_KEY" || echo Fatal : missing variable SSH_PRIVATE_KEY 
test -n "$SSH_KNOWN_HOSTS" || echo Warn : missing variable SSH_KNOWN_HOSTS 

echo ..:: ssh-init.sh : variables set ::..

which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )
eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ -n $SSH_KNOWN_HOSTS ]; then
    ssh-keyscan -H "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
    chmod 644 ~/.ssh/known_hosts
fi
