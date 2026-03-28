# Bock One UI

Frontend for Bock One built with Flutter.

## Environment setup

1. Copy the example env file:

```bash
cp .env.example .env
```

2. Open `.env` and fill in values for all keys.

3. Never commit `.env` or private keys.

## Build Flutter web

```bash
flutter pub get
flutter build web
```

Build output will be generated in `build/web`.

## Deploy with S3 + CloudFront

### Prerequisites

- AWS account with permissions for S3, CloudFront, and ACM.
- AWS CLI configured (`aws configure`).
- Domain hosted in Route 53 (optional but recommended).

### 1) Create and configure S3 bucket

Use a globally unique bucket name:

```bash
aws s3 mb s3://<your-bucket-name>
```

Keep the bucket private when using CloudFront Origin Access Control (recommended).

### 2) Upload the Flutter web build

```bash
aws s3 sync build/web s3://<your-bucket-name> --delete

or manully upload on aws platform make sure index.html is in the root
```

### 3) Create CloudFront distribution

In AWS Console:

1. Go to CloudFront -> Create distribution.
2. Set origin to your S3 bucket.
3. Enable Origin Access Control and attach it to the origin.
4. Viewer protocol policy: Redirect HTTP to HTTPS.
5. Default root object: `index.html`.


### 4) Allow CloudFront to read S3 bucket

Attach a bucket policy that allows only your CloudFront distribution. Replace placeholders before applying:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipalReadOnly",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::<your-bucket-name>/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::<account-id>:distribution/<distribution-id>"
        }
      }
    }
  ]
}
```

### 5) Invalidate cache after every deployment

```bash
aws cloudfront create-invalidation \
  --distribution-id <distribution-id> \
  --paths "/*"
```



## Legacy EC2 + Nginx deployment

If you still need EC2/Nginx deployment, see `DEPLOYMENT.md`.
