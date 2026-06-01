# Linux Network Server Deployment — Fedora 38

> Full-stack server-client environment deployed on Fedora 38 in VMware Workstation — configuring DHCP, DNS, NFS, Samba, Apache, email services, printing, and remote desktop. Automated weekly backups with cron and bash scripting.

![OS](https://img.shields.io/badge/OS-Fedora_38-51A2DA?style=flat-square&logo=fedora&logoColor=white)
![VM](https://img.shields.io/badge/Platform-VMware_Workstation-607078?style=flat-square&logo=vmware&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-00FF94?style=flat-square)

---

## Overview

This project involves deploying and configuring a **production-style Linux server-client environment** from scratch inside VMware Workstation using Fedora 38. Every service was configured manually via terminal — no GUI wizards. The environment mirrors real enterprise infrastructure: static IP addressing, DNS resolution, cross-platform file sharing, web hosting, email delivery, print services, and encrypted remote access.

---

## Environment

| Role | OS | IP Address |
|------|----|-----------|
| Server | Fedora 38 | 192.168.x.1 (static) |
| Client | Fedora 38 | 192.168.x.x (DHCP) |
| Platform | VMware Workstation | Host-only network |

---

## Services Configured

| Service | Package | Purpose |
|---------|---------|---------|
| **DHCP** | `dhcpd` | Automatic IP assignment to clients |
| **DNS** | `BIND (named)` | Forward and reverse lookup zones |
| **NFS** | `nfs-utils` | Linux-to-Linux file sharing |
| **Samba** | `samba` | Cross-platform file sharing (Linux/Windows) |
| **Web Server** | `Apache (httpd)` | HTTP web hosting |
| **Mail (SMTP)** | `Sendmail` | Outbound email delivery |
| **Mail (IMAP)** | `Dovecot` | Inbound email retrieval |
| **Print** | `CUPS` | Network print service |
| **Remote Desktop** | `TigerVNC` | Graphical remote access |
| **Firewall** | `firewalld` | Port and service access control |

---

## Key Configurations

### DHCP — `/etc/dhcp/dhcpd.conf`
```bash
subnet 192.168.x.0 netmask 255.255.255.0 {
    range 192.168.x.100 192.168.x.200;
    option routers 192.168.x.1;
    option domain-name-servers 192.168.x.1;
    default-lease-time 600;
    max-lease-time 7200;
}
```

### DNS — Forward Zone `/var/named/forward.zone`
```bash
$TTL 86400
@   IN  SOA  server.local. admin.local. (
            2024010101 ; Serial
            3600       ; Refresh
            1800       ; Retry
            604800     ; Expire
            86400 )    ; Minimum TTL
@   IN  NS   server.local.
server IN A  192.168.x.1
client IN A  192.168.x.100
```

### DNS — Reverse Zone `/var/named/reverse.zone`
```bash
$TTL 86400
@   IN  SOA  server.local. admin.local. (
            2024010101 3600 1800 604800 86400 )
@   IN  NS   server.local.
1   IN  PTR  server.local.
100 IN  PTR  client.local.
```

### Samba — `/etc/samba/smb.conf`
```ini
[global]
    workgroup = WORKGROUP
    security = user

[shared]
    path = /srv/samba/shared
    browsable = yes
    writable = yes
    valid users = @samba
```

### Apache — `/etc/httpd/conf/httpd.conf`
```bash
ServerName server.local:80
DocumentRoot "/var/www/html"
DirectoryIndex index.html
```

### Automated Backup — `backup.sh`
```bash
#!/bin/bash
# Weekly backup script — runs via cron every Sunday at 2am
BACKUP_DIR="/backup/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/etc-backup.tar.gz" /etc
tar -czf "$BACKUP_DIR/www-backup.tar.gz" /var/www/html
tar -czf "$BACKUP_DIR/home-backup.tar.gz" /home
echo "Backup completed: $BACKUP_DIR"
```

### Cron Schedule — `/etc/crontab`
```bash
0 2 * * 0 root /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1
```

### Firewall — Open Required Ports
```bash
firewall-cmd --permanent --add-service=dhcp
firewall-cmd --permanent --add-service=dns
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=samba
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=smtp
firewall-cmd --permanent --add-service=imap
firewall-cmd --permanent --add-service=vnc-server
firewall-cmd --reload
```

---

## Setup Order

```
1.  Install Fedora 38 in VMware (server + client VMs)
2.  Set static IP on server
3.  Configure and start DHCP → verify client gets IP
4.  Configure BIND DNS → test with dig and nslookup
5.  Set up NFS shares → mount on client
6.  Configure Samba → test cross-platform access
7.  Deploy Apache → serve test HTML page
8.  Configure Sendmail + Dovecot → test send/receive
9.  Set up CUPS → add network printer
10. Install and configure TigerVNC → test remote desktop
11. Configure firewalld → open only required ports
12. Write and schedule backup.sh via cron
```

---

## Skills Demonstrated

- Linux system administration from terminal
- DNS zone file configuration (forward + reverse lookup)
- Cross-platform file sharing (NFS + Samba)
- Web server deployment and configuration
- Email server setup (SMTP + IMAP)
- Firewall management with firewalld
- Bash scripting and cron job automation
- VMware network configuration (host-only, NAT)

---

## Author

**Romil Chauhan** — Computer Engineering Technology, Seneca Polytechnic
📧 chauhanromil1@gmail.com
🌐 [romilchauhan.github.io](https://romilchauhan.github.io)
💼 [linkedin.com/in/romilchauhan1111](https://linkedin.com/in/romilchauhan1111)
