##### TOC

- [Where to begin](docs/1_wheretobegin.md)
- [non-root and random uuid](docs/2_nonroot.md)
- [OpenShift and Jira](docs/3_openshift.md)
- [Jira's Database](docs/4_database.md)
- [OpenShift template](docs/5_template.md)

---

#### Container as non-root user and random user id

Containers should not run as root.  Within OpenShift they run by default under a random user id. Fortunately Jira already runs as a non-root user Jira. Unfortunately the Jira application expects to run as the user Jira.  That is where our [starter-nsswrapper](https://github.com/RHsyseng/container-rhel-examples/tree/master/starter-nsswrapper) project comes in.
The starter-nsswrapper project contains an example Dockerfile and scripts when dealing with an application that requires a defined user.  In every situtation modification most likely be required.

---

##### Modification to starter-nsswrapper

1. Additional files need to be copied into the image
2. user_setup script
  * Changed useradd to usermod - Jira installer creates user, all we have to do is modify it.  **NOTE:** For the sed command in the [Dockerfile](../Dockerfile) to work correctly the gid of the user must be set to 0.
  * Added ${APP_HOME} to chown and chmod commands
3. Changed CMD from run to the script that starts Jira

---
