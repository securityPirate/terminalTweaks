#!/bin/zsh

# Add autoload and compinit at the beginning of ~/.zshrc
echo "compinit" | cat - ~/.zshrc > temp && mv temp ~/.zshrc
echo "autoload -Uz compinit" | cat - ~/.zshrc > temp && mv temp ~/.zshrc


# Function to add alias if it doesn't exist
add_alias() {
    if ! grep -q "alias $1='$2'" ~/.zshrc; then
        echo "alias $1='$2'" >> ~/.zshrc
    fi
}

# Detect the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "# macOS-specific aliases and functions" >> ~/.zshrc
    
    # Add macOS-specific aliases and functions here
    add_alias "update" "brew update && brew upgrade"
    add_alias "cleanup" "brew cleanup"
    add_alias "doctor" "brew doctor"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "# Linux-specific aliases and functions" >> ~/.zshrc
    
    # Add Linux-specific aliases and functions here
    add_alias "update" "sudo apt update && sudo apt upgrade -y"
    add_alias "cleanup" "sudo apt autoremove -y && sudo apt clean"
    add_alias "update" "sudo apt update && sudo apt upgrade -y"
    add_alias "sysinfo" "inxi -Fxz"
    add_alias "meminfo" "free -m -l -t"
    add_alias "cpuinfo" "lscpu"
    add_alias "reboot" "sudo reboot"
    add_alias "shutdown" "sudo shutdown -h now"
    
else
    echo "Unsupported operating system. Aliases and functions not added."
    exit 1
fi

# General aliases
echo "# General aliases" >> ~/.zshrc
add_alias "ll" "ls -alF"
add_alias "la" "ls -A"
add_alias "l" "ls -CF"
add_alias "c" "clear"
add_alias "h" "history"
add_alias "hg" "history | grep"
add_alias "ports" "netstat -tulanp"

# Networking aliases
echo "# Networking aliases" >> ~/.zshrc
add_alias "ip" "curl ipinfo.io"
add_alias "ping1" "ping 1.1.1.1"
add_alias "ping8" "ping 8.8.8.8"

# Docker aliases
echo "# Docker aliases" >> ~/.zshrc
add_alias "d" "docker"
add_alias "dc" "docker-compose"
add_alias "dps" "docker ps"
add_alias "dpsa" "docker ps -a"
add_alias "di" "docker images"
add_alias "dexec" "docker exec -it"
add_alias "dl" "docker logs"
add_alias "dlf" "docker logs -f"
add_alias "drm" "docker rm"
add_alias "drmi" "docker rmi"
add_alias "db" "docker build"
add_alias "dup" "docker-compose up -d"
add_alias "ddown" "docker-compose down"
add_alias "dstart" "docker start"
add_alias "dstop" "docker stop"
add_alias "drestart" "docker restart"

# Git aliases
echo "# Git aliases" >> ~/.zshrc
add_alias "g" "git"
add_alias "gs" "git status -sb"
add_alias "ga" "git add"
add_alias "gc" "git commit"
add_alias "gpu" "git push"
add_alias "gl" "git log --oneline"
add_alias "gf" "git fetch"
add_alias "gb" "git branch"
add_alias "gp" "git pull"
add_alias "gco" "git checkout"
add_alias "gm" "git merge"
add_alias "gd" "git diff"
add_alias "gr" "git remote"
add_alias "gt" "git tag"
add_alias "gst" "git stash"

# Kubectl aliases
echo "# Kubectl aliases" >> ~/.zshrc
add_alias "k" "kubectl"
add_alias "kgp" "kubectl get pods"
add_alias "kgd" "kubectl get deployments"
add_alias "kgs" "kubectl get services"
add_alias "kgn" "kubectl get nodes"
add_alias "kd" "kubectl describe"
add_alias "kl" "kubectl logs"
add_alias "ka" "kubectl apply -f"
add_alias "kex" "kubectl exec -it"
add_alias "kns" "kubectl config set-context --current --namespace"

# Terraform aliases
echo "# Terraform aliases" >> ~/.zshrc
add_alias "t" "terraform"
add_alias "ti" "terraform init"
add_alias "tp" "terraform plan"
add_alias "ta" "terraform apply"
add_alias "td" "terraform destroy"
add_alias "to" "terraform output"
add_alias "tw" "terraform workspace"
add_alias "tv" "terraform validate"
add_alias "tc" "terraform console"
add_alias "ts" "terraform show"
add_alias "tr" "terraform refresh"

# SSH aliases
echo "# SSH aliases" >> ~/.zshrc
add_alias "s" "ssh"
add_alias "scp" "scp -r" # Always use recursive copy
add_alias "sa" "ssh-add"
add_alias "sl" "ssh-add -l"
add_alias "sd" "ssh-add -D"
add_alias "sc" "ssh-copy-id"
add_alias "sgen" "ssh-keygen -t rsa -b 4096"


# Docker functions
echo "# Docker functions" >> ~/.zshrc
cat << 'EOF' >> ~/.zshrc
dclean() { docker system prune -af; }
dstats() { docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"; }
dip() { docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"; }
dlogs() { docker logs -f "$@"; }
EOF

# Docker Compose functions
echo "# Docker Compose functions" >> ~/.zshrc
cat << 'EOF' >> ~/.zshrc
dcup() { docker compose up -d "$@"; }
dcdown() { docker compose down "$@"; }
dcstart() { docker compose start "$@"; }
dcstop() { docker compose stop "$@"; }
dcrestart() { docker compose restart "$@"; }
dclogs() { docker compose logs -f "$@"; }
dcexec() { docker compose exec "$@"; }
dcbuild() { docker compose build "$@"; }
EOF

# Git functions
echo "# Git functions" >> ~/.zshrc
cat << 'EOF' >> ~/.zshrc
gcp() { git add . && git commit -m "$1" && git push; }
gcb() { git checkout -b "$1"; }
gclean() { git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d; }
gsync() { git checkout master && git pull origin master && git checkout - && git rebase master; }
gundo() { git reset --soft HEAD~1; }
gstash() { git stash save "$1"; }
gstashp() { git stash pop; }
gstashl() { git stash list; }
gstashd() { git stash drop; }
gstashc() { git stash clear; }
EOF

# Kubectl functions
echo "# Kubectl functions" >> ~/.zshrc
cat << 'EOF' >> ~/.zshrc
kexec() { kubectl exec -it $1 -- ${2:-/bin/sh}; }
kctx() { kubectl config use-context $1; }
kpf() { kubectl port-forward $1 ${2:-8080}:${3:-80}; }
kdrain() { kubectl drain $1 --delete-local-data --force --ignore-daemonsets; }
kuncordon() { kubectl uncordon $1; }
EOF

# Terraform functions
echo "# Terraform functions" >> ~/.zshrc
cat << 'EOF' >> ~/.zshrc
tfplan() { terraform plan -out=tfplan && terraform show -json tfplan | jq '.' > tfplan.json; }
tfapply() { terraform apply -auto-approve; }
tfdestroy() { terraform destroy -auto-approve; }
tfworkspace() { terraform workspace select "$1" || terraform workspace new "$1"; }
EOF

# SSH functions
echo "# SSH functions" >> ~/.zshrc
cat << 'EOF' >> ~/.zshrc
ssht() { ssh -t "$1" "${2:-tmux attach || tmux new}"; }
sshp() { ssh -o ProxyCommand="ssh -W %h:%p $1" "$2"; }
sshfs_mount() { sshfs "$1:$2" "$3" -o allow_other,default_permissions; }
sshfs_umount() { fusermount -u "$1"; }
EOF

# Enable kubectl autocompletion
echo "# Kubectl autocompletion" >> ~/.zshrc
echo 'source <(kubectl completion zsh)' >> ~/.zshrc

# Source the zshrc file to apply changes
source ~/.zshrc

echo "Aliases and functions have been added to your ~/.zshrc file and applied."
