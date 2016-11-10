##### OpenShift

```
oc new-app https://github.com/jcpowermac/aos-atlassian-jira --context-dir . --strategy docker
```

```
oc new-app -o yaml https://github.com/jcpowermac/mysql-container --strategy=docker --context-dir="./5.6/" > mysql-container.yaml
```

```
oc export svc,is,dc,bc --as-template Jira > jira-aos-template.yaml
```

```
oc -o yaml export template cakephp-mysql-example -n openshift > ~/scratch/cake.yaml
```

```
oc export svc,is,dc,bc --as-template Jira > jira-aos-template.yaml
```


Use Examples of existing templates
---
