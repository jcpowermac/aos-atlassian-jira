# Running Atlassian Jira on Atomic OpenShift
---
The aos-atlassian-jira is an example and documentation for:
- Using nss_wrapper with a application
- Using [Ansible](http://docs.ansible.com/ansible/index.html) in a image build process
- Creating and using a OpenShift template

---
##### Documentation
- [Where to begin](docs/1_wheretobegin.md)
- [non-root and random uuid](docs/2_nonroot.md)
- [OpenShift and Jira](docs/3_openshift.md)
- [Jira's Database](docs/4_database.md)

---
##### Run project
```
oc new-project atlassian
curl https://raw.githubusercontent.com/jcpowermac/aos-atlassian-jira/master/jira-aos-template.yaml | oc create -f -
# more commands to follow
```

---
