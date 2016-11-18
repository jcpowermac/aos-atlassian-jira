##### TOC

- [Where to begin](docs/1_wheretobegin.md)
- [non-root and random uuid](docs/2_nonroot.md)
- [OpenShift and Jira](docs/3_openshift.md)
- [Jira's Database](docs/4_database.md)
- [OpenShift template](docs/5_template.md)

---

##### OpenShift and Jira container
Now that we have a proper container image how do we get this running into OpenShift?
Since the project is in GitHub we can use the `oc new-app` command.

For our Jira project:
```
oc new-app https://github.com/jcpowermac/aos-atlassian-jira --context-dir . --strategy docker
```
