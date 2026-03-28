# Flutter Web UI Deployment Guide

## Prerequisites
- EC2 Instance: `<EC2_PUBLIC_IP_OR_DNS>`
- SSH Key: `<path-to-key>.pem`
- Backend running on: `<EC2_PUBLIC_IP_OR_DNS>:3000`

---

## Step 1: Build Flutter Web App

```bash
flutter build web
```

---

## Step 2: Copy Build to EC2

```bash
scp -i <path-to-key>.pem -r build/web ubuntu@<EC2_PUBLIC_IP_OR_DNS>:/home/ubuntu/
```

---

## Step 3: SSH into EC2

```bash
ssh -i <path-to-key>.pem ubuntu@<EC2_PUBLIC_IP_OR_DNS>
```

---

## Step 4: Install & Configure Nginx

```bash
# Install Nginx
sudo apt update
sudo apt install nginx -y

# Copy web files to nginx directory
sudo cp -r /home/ubuntu/web/* /var/www/html/

# Set permissions
sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod 755 {} \;
sudo find /var/www/html -type f -exec chmod 644 {} \;

# Restart Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

---

## Step 5: Access Application

Open browser: `http://<EC2_PUBLIC_IP_OR_DNS>`

---

## Backend Configuration

Backend API endpoint configured in: `lib/screens/configuration/config.dart`

```dart
static const String ipAddress = '<EC2_PUBLIC_IP_OR_DNS>';
static const String port = '3000';
```

---

## Verify Backend Running

```bash
curl http://<EC2_PUBLIC_IP_OR_DNS>:3000
```

---

## Troubleshooting

**403 Forbidden Error:**
```bash
sudo ls -la /var/www/html
# Ensure files exist and permissions are correct
```

**Nginx Status:**
```bash
sudo systemctl status nginx
```

**Nginx Logs:**
```bash
sudo tail -f /var/log/nginx/error.log
```
