# Nginx Load Balancer Configuration for Nautilus Project

This guide provides detailed instructions for configuring Nginx as a load balancer for the Nautilus project using port 5004.

## Prerequisites

- Ubuntu/Debian system with root or sudo access
- Multiple backend servers/applications running the Nautilus project
- Nginx installed on the load balancer server

## Installation

### Install Nginx

```bash
# Update package list
sudo apt update

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Verify Nginx is running
sudo systemctl status nginx
```

## Configuration Steps

### 1. Create Nginx Configuration File

Create a new configuration file for the Nautilus project:

```bash
sudo nano /etc/nginx/sites-available/nautilus-loadbalancer
```

### 2. Load Balancer Configuration

Add the following configuration to the file:

```nginx
# Define upstream servers for Nautilus project
upstream nautilus_backend {
    # Define backend servers (replace with actual server IPs/hostnames)
    server 192.168.1.10:5004 weight=3 max_fails=3 fail_timeout=30s;
    server 192.168.1.11:5004 weight=3 max_fails=3 fail_timeout=30s;
    server 192.168.1.12:5004 weight=2 max_fails=3 fail_timeout=30s;
    
    # Load balancing method options:
    # least_conn;    # Route to server with least connections
    # ip_hash;       # Route based on client IP hash
    # Default: round_robin (no directive needed)
}

# Main server block for load balancer
server {
    listen 80;
    listen [::]:80;
    
    # Replace with your domain or server IP
    server_name nautilus.example.com your_server_ip;
    
    # Enable logging
    access_log /var/log/nginx/nautilus_access.log;
    error_log /var/log/nginx/nautilus_error.log;
    
    # Main location block - proxy to upstream
    location / {
        proxy_pass http://nautilus_backend;
        
        # Essential proxy headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Connection and timeout settings
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
        
        # Buffer settings for better performance
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
        
        # Health check headers
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_next_upstream_timeout 10s;
        proxy_next_upstream_tries 3;
    }
    
    # Health check endpoint (optional)
    location /health {
        access_log off;
        return 200 "Load balancer healthy\n";
        add_header Content-Type text/plain;
    }
    
    # Status page for monitoring (optional)
    location /nginx_status {
        stub_status on;
        access_log off;
        # Restrict access to local network only
        allow 127.0.0.1;
        allow 192.168.0.0/16;
        deny all;
    }
}

# Optional: HTTPS configuration
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    
    server_name nautilus.example.com your_server_ip;
    
    # SSL certificate paths (uncomment and configure if using SSL)
    # ssl_certificate /path/to/your/certificate.crt;
    # ssl_certificate_key /path/to/your/private.key;
    
    # SSL settings
    # ssl_protocols TLSv1.2 TLSv1.3;
    # ssl_ciphers HIGH:!aNULL:!MD5;
    # ssl_prefer_server_ciphers on;
    
    # Same location blocks as HTTP version
    location / {
        proxy_pass http://nautilus_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }
}
```

### 3. Enable the Configuration

```bash
# Create symbolic link to enable the site
sudo ln -s /etc/nginx/sites-available/nautilus-loadbalancer /etc/nginx/sites-enabled/

# Remove default Nginx configuration (optional)
sudo rm -f /etc/nginx/sites-enabled/default
```

### 4. Test Configuration

```bash
# Test Nginx configuration syntax
sudo nginx -t

# If test passes, reload Nginx
sudo systemctl reload nginx
```

## Backend Server Configuration

### Ensure Nautilus Applications are Running

On each backend server, ensure your Nautilus application is running on port 5004:

```bash
# Example for a Node.js application
node app.js --port 5004

# Or for a Python application
python app.py --port 5004

# Verify application is listening on port 5004
netstat -tlnp | grep :5004
# or
ss -tlnp | grep :5004
```

### Firewall Configuration

Ensure firewalls allow traffic:

```bash
# On load balancer server
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# On backend servers
sudo ufw allow 5004/tcp

# Allow traffic from load balancer IP (replace with actual IP)
sudo ufw allow from LOAD_BALANCER_IP to any port 5004
```

## Monitoring and Maintenance

### Check Load Balancer Status

```bash
# Check Nginx status
sudo systemctl status nginx

# View access logs
sudo tail -f /var/log/nginx/nautilus_access.log

# View error logs
sudo tail -f /var/log/nginx/nautilus_error.log

# Check upstream server status (if status module enabled)
curl http://your_server_ip/nginx_status
```

### Common Commands

```bash
# Reload Nginx configuration
sudo systemctl reload nginx

# Restart Nginx
sudo systemctl restart nginx

# Test configuration
sudo nginx -t

# View current connections
sudo netstat -tlnp | grep nginx
```

## Load Balancing Methods

### Round Robin (Default)
Requests are distributed evenly across all servers in sequence.

### Least Connections
Add `least_conn;` to upstream block. Routes to server with fewest active connections.

### IP Hash
Add `ip_hash;` to upstream block. Routes based on client IP hash for session persistence.

### Weighted Round Robin
Use `weight=N` parameter to give different servers different priorities.

## Troubleshooting

### Common Issues

1. **502 Bad Gateway Error**
   - Check if backend servers are running on port 5004
   - Verify firewall settings
   - Check Nginx error logs

2. **Configuration Test Fails**
   - Run `sudo nginx -t` to see specific errors
   - Check syntax in configuration file
   - Ensure all file paths are correct

3. **Backend Server Not Responding**
   - Check individual backend server health
   - Verify network connectivity
   - Check application logs on backend servers

### Debug Commands

```bash
# Test backend server directly
curl http://backend_server_ip:5004

# Check if Nginx is listening on correct ports
sudo netstat -tlnp | grep nginx

# Verify upstream configuration
sudo nginx -T | grep -A 10 upstream
```

## Security Considerations

1. **Limit Access**
   - Restrict admin endpoints to specific IPs
   - Use firewalls to control access

2. **SSL/TLS**
   - Configure HTTPS for production environments
   - Use proper SSL certificates

3. **Rate Limiting**
   - Add rate limiting to prevent abuse
   - Configure appropriate limits per IP

4. **Headers**
   - Hide Nginx version information
   - Set appropriate security headers

## Additional Notes

- Replace `192.168.1.x` with your actual backend server IPs
- Replace `nautilus.example.com` with your actual domain
- Adjust weights based on server capacity
- Configure SSL certificates for production use
- Monitor server health and performance regularly
- Consider implementing health checks for automatic failover

For more advanced configurations and troubleshooting, refer to the [official Nginx documentation](https://nginx.org/en/docs/).
