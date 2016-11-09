
#### MySQL
Now that we have an image and a container running we are still missing a critical piece, the database.
OpenShift provides out of the box an image and template for MySQL.  The only hangup with that image is that it uses MySQL's defaul collation and character set.  Jira requires utf8 and utf8_bin.  So how to solve this wrinkle?
