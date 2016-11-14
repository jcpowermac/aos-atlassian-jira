##### OpenShift and Jira container
Now that we have a proper container image how do we get this running into OpenShift?
Since the project is in GitHub we can use the `oc new-app` command.

For our Jira project:
```
oc new-app https://github.com/jcpowermac/aos-atlassian-jira --context-dir . --strategy docker
```
