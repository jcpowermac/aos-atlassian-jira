##### TOC

- [Where to begin](docs/1_wheretobegin.md)
- [non-root and random uuid](docs/2_nonroot.md)
- [OpenShift and Jira](docs/3_openshift.md)
- [Jira's Database](docs/4_database.md)
- [OpenShift template](docs/5_template.md)

---

##### OpenShift Template

Use examples!

```
oc export svc,is,dc,bc --as-template Jira > jira-aos-template.yaml
```

```
oc -o yaml export template cakephp-mysql-example -n openshift > ~/scratch/cake.yaml
```
