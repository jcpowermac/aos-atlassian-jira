#### Where to begin...

##### Goals

- Install and configure application to run in a container
- Configure the image to run as a non-root user
- Configure the image to run as a random user id
- Configure the image to run in OpenShift

---

##### Example and background

For this example I will use [Atlassian Jira](https://www.atlassian.com/software/jira) - a issue and project tracking for teams.  I am using this as an example because a have previous experience with the product.

Jira has two options for installation:

1. Archive
2. Binary

For this example the binary option will be used.  Why:

1. Java is required for Jira to run and the binary provides the supported version that it requires.
2. Jira requires directory and user account creation which is automated by the binary installer.

---

##### Installation
As with any software it is important to read the documentation for [installation](https://confluence.atlassian.com/adminjiraserver071/installing-jira-applications-on-linux-802592173.html) and [requirements](https://confluence.atlassian.com/adminjiraserver071/jira-applications-installation-requirements-802592164.html).

For our example Jira the steps for pre and post install are as follows:

1. Download and extract the MySQL Java connector
2. For a silent install create the response.varfile
3. Download and run the installer
4. Copy the MySQL Java connector to the appropriate directory

Since Jira will be run in a container modifications to the steps are required:

1. Container-related prerequisites: nss_wrapper, gettext, go-md2man
2. Removal of binaries: Jira installer and MySQL Connector
3. Modifications to application directory permissions

The steps above are executed via Ansible - not necessarily a best practice but
an option for complex scanrios, see [init.yml](../init.yml) for an example.
