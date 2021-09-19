1. Go AWS Marketplace and subscribe "OpenVPN" into your account by discover products and type "openvpn inc"

2. Select first free BOYL option and accept terms and conditions.

3. Click Launch new instance from the marketplace screen and get AMI ID. Note- Properly select your region.

4. Create a key pair named "openvpckp"

### How to Use
1. Once, ASG is successfully launched an instance. Go to the instance and get Public IP or Public DNS and login with passed user id and password. `Note- Password can be found into AWS Parameter Store with name as output from terraform output.`
2. Download File by clicking on link 
```
Available Connection Profiles:
Yourself (user-locked profile)
```
3. Download OpenVPN Software from openvpn website.
4. Import downloaded profile into openvpn software and connect.
5. You can try to ssh into server with private IP address using key pair earlier created with user name as `openvpnas`