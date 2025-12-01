<h1 align="center">🚀 Bock One Frontend Deployment Guide (Flutter Web + EC2 + Nginx)</h1>

<hr>

<h2>📌 Step 1: Clone the Repository</h2>

<pre>
git clone https://github.com/BOCK-CHAIN/BockOneUI.git
</pre>

<hr>

<h2>📌 Step 2: Build Flutter Web</h2>

<ol>
  <li>Start your backend server on EC2.</li>
  <li>Edit <strong>config.dart</strong> and update the API base URL with your EC2 public IP.</li>
  <li>Run the Flutter web build command:</li>
</ol>

<pre>
flutter build web
</pre>

<hr>

<h2>📌 Step 3: Copy Web Build to EC2 Instance</h2>

<p>Run the following command in your local machine:</p>

<pre>
scp -i "&lt;path for key pair&gt;" -r "&lt;path of the web folder in the project&gt;" ubuntu@&lt;ip address of EC2&gt;:/home/ubuntu/web
</pre>

<hr>

<h2>📌 Step 4: Configure Nginx on EC2</h2>

<p>SSH into your EC2 instance and run the following commands in order:</p>

<pre>
sudo apt update && sudo apt upgrade -y

sudo apt install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

sudo rm -rf /var/www/html/*

sudo cp -r /home/ubuntu/web/* /var/www/html/

sudo chown -R www-data:www-data /var/www/html

sudo find /var/www/html -type d -exec chmod 755 {} \;
sudo find /var/www/html -type f -exec chmod 644 {} \;

sudo systemctl restart nginx
</pre>

<hr>

<h2>📌 Step 5: Access Your Frontend</h2>

<p>Open your browser and navigate to:</p>

<pre>
http://&lt;EC2-PUBLIC-IP&gt;
</pre>

<hr>

<h2 align="center">🎉 Deployment Complete</h2>

<p align="center">Your Flutter Web app is now successfully deployed on AWS EC2 with Nginx.</p>

