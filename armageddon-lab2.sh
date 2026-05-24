#!/bin/bash

# 1. Update system and install Apache
yum update -y
yum install -y httpd

# 2. Start and enable Apache web server
systemctl start httpd
systemctl enable httpd

# 3. Create the web content
# We use a 'heredoc' (EOF) to write the HTML and CSS directly to the index file
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cloud Automation Lab</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f4f8; /* Background Color Requirement */
            margin: 0;
            padding: 0;
            color: #333;
        }
        header {
            background-color: #232f3e;
            color: white;
            padding: 2rem;
            text-align: center;
        }
        section {
            padding: 20px;
            margin: 20px auto;
            max-width: 800px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }
        footer {
            text-align: center;
            padding: 20px;
            font-size: 1.2rem;
            color: #666;
        }
    </style>
</head>
<body>

    <header>
        <h1>Mister A (Alex)</h1>
    </header>

    <!-- Section 1: About Me -->
    <section>
        <h2>About Me</h2>
        <p>I am exploring Linux automation and cloud infrastructure to build scalable web environments.</p>
        <!-- Embedded Image Requirement -->
        <img src="https://images.unsplash.com/photo-1519834785169-98be25ec3f84?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3VjY2Vzc3xlbnwwfHwwfHx8MA%3D%3D" alt="Cloud Technology">
    </section>

    <!-- Section 2: Project Description -->
    <section>
        <h2>Project Description</h2>
        <p>This page was deployed automatically via an EC2 User Data script. The script installs the Apache web server, configures the service, and generates this HTML file without any manual SSH intervention.</p>
    </section>

    <!-- Section 3: Contact / Footer -->
    <footer>
        <h3>Contact / Footer</h3>
        <p>Email: axzevia@gmail.com | AWS Cloud Lab 2026</p>
    </footer>

</body>
</html>
EOF

# 4. Set appropriate permissions for the web directory
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html