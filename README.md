# EC2 Startup Script - User Data Automation

![Shell](https://img.shields.io/badge/Shell-Bash_Script-green?style=for-the-badge&logo=gnu-bash&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EC2-orange?style=for-the-badge&logo=amazonaws&logoColor=white)
![Apache](https://img.shields.io/badge/Web_Server-Apache-red?style=for-the-badge&logo=apache&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)

---

## Objective

This lab introduces Linux automation and cloud initialisation by writing a startup script that configures an EC2 instance to host a front-facing static website. The script runs automatically at instance launch via EC2 User Data, installing and configuring a web server and generating a styled HTML page - all without any manual SSH intervention.

---

## What the Script Does

`startup.sh` executes top to bottom in 4 clear steps:

1. Updates the system package list and installs the Apache web server (`httpd`)
2. Starts the Apache service immediately and enables it to launch automatically on every reboot
3. Writes a complete HTML and CSS page directly to the Apache web root using a heredoc (`EOF`) block
4. Sets correct file ownership and permissions on the web directory so Apache can serve the content

---

## File Structure

```
EC2_StartupScript/
├── startup.sh     ← The User Data script (paste into EC2 on launch)
└── README.md
```

---

## Linux Commands Used

### 1. `yum update -y`
**Definition:** Upgrades all installed packages to their latest versions. The `-y` flag auto-confirms all prompts so the script runs non-interactively.  
**Why I used it:** Ensures the instance starts with a current, patched package list before any software is installed - a standard hardening step for new server provisioning.

---

### 2. `yum install -y httpd`
**Definition:** Installs the Apache HTTP Server package (`httpd`) from the Amazon Linux package repository. `-y` suppresses the confirmation prompt.  
**Why I used it:** Apache is the web server that listens for incoming HTTP requests and serves the HTML content to the browser. It must be installed before the service can be started.

---

### 3. `systemctl start httpd`
**Definition:** Starts the Apache service immediately in the current session.  
**Why I used it:** Installation alone does not start the server. This command brings Apache online so it begins accepting connections as soon as the User Data script finishes running.

---

### 4. `systemctl enable httpd`
**Definition:** Registers the Apache service to start automatically whenever the instance reboots.  
**Why I used it:** Without this, a reboot would leave the web server offline. Enabling the service ensures the site remains available after any restart without further manual action.

---

### 5. `cat <<EOF > /var/www/html/index.html`
**Definition:** A heredoc construct that redirects everything between `<<EOF` and the closing `EOF` marker directly into the target file, overwriting it. `/var/www/html/index.html` is Apache's default document root.  
**Why I used it:** Allows an entire HTML and CSS document to be written inline inside the Bash script in a single step - no separate file transfer or editor required. This is the standard pattern for generating web content in EC2 User Data scripts.

---

### 6. `chown -R apache:apache /var/www/html`
**Definition:** Recursively changes the owner and group of the web directory and all its contents to the `apache` system user.  
**Why I used it:** Apache runs as the `apache` user. If the files are owned by `root`, the server process may not have permission to read them. Setting correct ownership ensures content is served without permission errors.

---

### 7. `chmod -R 755 /var/www/html`
**Definition:** Recursively sets file permissions: owner gets read/write/execute (`7`), group and others get read/execute (`5`).  
**Why I used it:** The `755` permission model allows the Apache process (and any visiting user) to read and traverse the web directory while preventing unauthorised modification of the hosted files.

---

## Command Flags Summary

| Flag | Command | Purpose |
|---|---|---|
| `-y` | `yum update` / `yum install` | Suppress confirmation prompts for non-interactive execution |
| `-R` | `chown` / `chmod` | Apply the change recursively to all files and subdirectories |
| `start` | `systemctl` | Start the service immediately in the current session |
| `enable` | `systemctl` | Register the service to start automatically on every boot |

---

## Heredoc Used

| Construct | Context | Purpose |
|---|---|---|
| `<<EOF ... EOF` | `cat` redirect | Writes a multi-line HTML document inline in the script without requiring a separate file or text editor |

---

## Web Page Requirements Met

| Requirement | Implementation |
|---|---|
| Developer name | `<h1>Mister A (Alex)</h1>` in the page header |
| Background colour | `background-color: #e8f0fe` applied to the `body` via inline CSS |
| Embedded image | `<img>` tag in the About Me section sourcing an external Unsplash URL |
| Section 1: About Me | Describes the developer's focus on Linux automation and cloud infrastructure |
| Section 2: Project Description | Explains that the page was deployed via EC2 User Data without SSH |
| Section 3: Contact / Footer | Displays email address and lab year |

---

## EC2 Instance Details

| Field | Value |
|---|---|
| Instance name | `cpg_lab2_ec2` |
| Instance ID | `i-06ac7b6485ecdffb7` |
| Instance type | `t3.micro` |
| Availability Zone | `us-east-1d` |
| Public IPv4 address | `3.88.136.159` |
| Instance state | Running ✅ |
| Status checks | 3/3 passed ✅ |

---

## How to Deploy

```bash
# 1. Open the AWS Console and navigate to EC2 → Launch Instances

# 2. Under "Advanced Details", paste the contents of startup.sh
#    into the "User data" field

# 3. Ensure the Security Group allows inbound HTTP traffic on port 80

# 4. Launch the instance - no SSH required

# 5. Once running, open a browser and navigate to the public IP:
http://3.88.136.159
```

The live page is served from:
```
/var/www/html/index.html
```

---

## Screenshots

| Screenshot | Description |
|---|---|
| `03_cpg_lab2_ec2.png` | EC2 instance list showing `cpg_lab2_ec2` in Running state |
| `04_cpg_lab2_ec2_summary.png` | Instance summary panel with public IP and status checks |
| `05_website1.png` | Rendered page in browser - header and About Me section |
| `06_website2.png` | Rendered page in browser - Project Description and Contact/Footer |

---

## Git Workflow Used

```bash
git status
git add .
git status
git commit -m "Add EC2 startup script and README for User Data automation lab"
git push
```
