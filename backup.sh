#!/bin/bash
#################################################################
# Project:     Linux Network Server — Automated Backup Script  #
# Author:      Romil Chauhan                                    #
# Schedule:    Every Sunday at 2:00 AM via cron                 #
# Description: Creates timestamped compressed backups of        #
#              /etc, /var/www/html, and /home directories.      #
#              Logs output to /var/log/backup.log               #
#################################################################

BACKUP_DIR="/backup/$(date +%Y-%m-%d)"
LOG_FILE="/var/log/backup.log"

echo "================================================" | tee -a "$LOG_FILE"
echo "Backup started: $(date)" | tee -a "$LOG_FILE"
echo "Destination:    $BACKUP_DIR" | tee -a "$LOG_FILE"
echo "================================================" | tee -a "$LOG_FILE"

# Create timestamped backup directory
mkdir -p "$BACKUP_DIR"

# Backup /etc — system configuration files
echo "Backing up /etc..." | tee -a "$LOG_FILE"
tar -czf "$BACKUP_DIR/etc-backup.tar.gz" /etc
echo "  ✓ /etc backed up" | tee -a "$LOG_FILE"

# Backup Apache web root
echo "Backing up /var/www/html..." | tee -a "$LOG_FILE"
tar -czf "$BACKUP_DIR/www-backup.tar.gz" /var/www/html
echo "  ✓ /var/www/html backed up" | tee -a "$LOG_FILE"

# Backup home directories
echo "Backing up /home..." | tee -a "$LOG_FILE"
tar -czf "$BACKUP_DIR/home-backup.tar.gz" /home
echo "  ✓ /home backed up" | tee -a "$LOG_FILE"

# Report disk usage of backup
echo "Backup size: $(du -sh "$BACKUP_DIR" | cut -f1)" | tee -a "$LOG_FILE"
echo "Backup completed successfully: $(date)" | tee -a "$LOG_FILE"
echo "================================================" | tee -a "$LOG_FILE"
