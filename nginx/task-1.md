# Nginx SSL Setup on App Server 3 (Nautilus Project)

This guide documents the steps to install, configure, and verify **Nginx with SSL** on **App Server 3 (stapp03)** in the Stork Datacenter.

---

## 1. Access App Server 3
First login to the **jump host** and then into **App Server 3**.

```bash
# Login to jump host
ssh thor@jump_host.stratos.xfusioncorp.com
# password: mjolnir123

# From jump host → App Server 3
ssh banner@stapp03
# password: BigGr33n
```

---

## 2. Install and Start Nginx
```bash
# For CentOS/RHEL
sudo yum install -y nginx

# For Ubuntu/Debian
# sudo apt-get install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
```

---

## 3. Move SSL Certificates
SSL certificate and key are provided in `/tmp`.

```bash
sudo mkdir -p /etc/nginx/ssl
sudo mv /tmp/nautilus.crt /etc/nginx/ssl/
sudo mv /tmp/nautilus.key /etc/nginx/ssl/
sudo chmod 600 /etc/nginx/ssl/nautilus.key
```

---

## 4. Configure Nginx for SSL
Create a new config file.

```bash
sudo vi /etc/nginx/conf.d/nautilus.conf
```

Add the following:

```nginx
server {
    listen 443 ssl;
    server_name stapp03.stratos.xfusioncorp.com;

    ssl_certificate /etc/nginx/ssl/nautilus.crt;
    ssl_certificate_key /etc/nginx/ssl/nautilus.key;

    root /usr/share/nginx/html;
    index index.html;
}

server {
    listen 80;
    server_name stapp03.stratos.xfusioncorp.com;
    return 301 https://$host$request_uri;
}
```

Test and reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 5. Create index.html
```bash
echo "Welcome!" | sudo tee /usr/share/nginx/html/index.html
```

(Optional, for bigger text you can use:)
```html
<h1>Welcome!</h1>
```

---

## 6. Verify Setup
From **jump_host**, test with `curl`.

### Headers only:
```bash
curl -Ik https://172.16.238.12/
```

Expected:
```
HTTP/1.1 200 OK
```

### Full HTML content:
```bash
curl -k https://172.16.238.12/
```

Expected:
```html
Welcome!
```
(or `<h1>Welcome!</h1>` depending on what you added)

---

✅ App Server 3 is now ready with **Nginx + SSL + Welcome Page**.
