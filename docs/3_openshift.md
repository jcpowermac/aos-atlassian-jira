##### OpenShift
Now that we have a proper container image how do we get this running into OpenShift?

```
oc new-app https://github.com/jcpowermac/aos-atlassian-jira --context-dir . --strategy docker
```



Use Examples of existing templates
---
