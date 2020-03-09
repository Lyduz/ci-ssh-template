# CI-SSH-Template
## Easy Cross Platform SSH CI/CD Template

## This is a maintained fork of https://gitlab.com/gitlab-cd/ssh-template.

## ssh
ssh helper ease remote connection from gilab-ci to your ssh host.  
**Actual limitation : your gitlab-ci.yml should have no "berore_script" section.**  
This library provides two commands, **ssh_init** and **ssh_run**.  

### ssh_run
Simply authenticate and execute remote command on a single line.
> **ssh_run** USER HOSTNAME $SSH_PRIVATE_KEY COMMAND  

```yaml
include: 'https://gitlab.com/gitlab-cd/ssh-template/raw/master/ssh.yml'

clean:
stage: build
script:
- ssh_run "root" "myownserver.com" "$SSH_PRIVATE_KEY" "rm -rf .cache"
```

### ssh_init
setup your SSH connection, then use any usual ssh command.  
> **ssh_init** $SSH_PRIVATE_KEY HOSTNAME    

Suppose i've declared my SSH key in the gitlab variable SSH_PRIVATE_KEY.  
Hereunder our use case :  
> As root user,  
> i want to ssh connect to 'myownserver.com',  
> in order to deploy and restart my server app.

Example implementation in .gitlab-ci.yml :  
```yaml
include: 'https://gitlab.com/gitlab-cd/ssh-template/raw/master/ssh.yml'

before_scripts:
- ssh_init "$SSH_PRIVATE_KEY" "myownserver.com"

promote:
stage: deploy
script:
- ssh root@myownserver.com "sudo pkill -9 java;
            wget https://gitlab.com/myownproject/-/jobs/120093218/artifacts/file/myownserverapp.jar;
            java -jar myownserverapp.jar"
- ssh root@myownserver.com "ps aux | grep myownserverapp"
```

### setup
- First, Add the private key (i.e: SSH_PRIVATE_KEY or SSH_TOKEN) as a variable to your gitlab project or group.  
![](https://docs.gitlab.com/ee/ci/variables/img/variables.png)
Note : you should not flag this variable as Protected if you want to use this variable with non-protected branch, otherwise ssh will fail.

- Then include the ssh.yml script from your .gitlab-ci.yml
```yaml
include: 'https://gitlab.com/gitlab-cd/ssh-template/raw/master/ssh.yml'
````
