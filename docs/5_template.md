##### OpenShift Template

Use examples!

```
oc export svc,is,dc,bc --as-template Jira > jira-aos-template.yaml
```

```
oc -o yaml export template cakephp-mysql-example -n openshift > ~/scratch/cake.yaml
```
